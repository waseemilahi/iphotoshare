#import "flickrapi.h"
#import "md5.h"
#import "XMLtoObject.h"

//flickrapi *FLICKR;// = [[flickrapi alloc] init];

@implementation flickrapi : NSObject

@synthesize FROB;
@synthesize TOKEN;

@synthesize loginDelegate;

-(void)addParam: (NSMutableString *)key withValue:(NSMutableString *)value {
	if (!params) params = [[NSMutableDictionary alloc] init];
	if (value) [params setObject:(NSMutableString *)value forKey:(NSMutableString *)key];
}

-(void)clearParams {
	if (!params) params = [[NSMutableDictionary alloc] init];
	[params removeAllObjects];
}

-(NSMutableString *)getFrob {
	[self clearParams];
	
	[self addParam:(NSMutableString *)@"method" withValue:(NSMutableString *)@"flickr.auth.getFrob"];
	[self addParam:(NSMutableString *)@"api_key" withValue:(NSMutableString *)APIKEY];
	
	NSMutableString *sig = [self getSig];
	
	[self addParam:(NSMutableString *)@"api_sig" withValue:(NSMutableString *)sig];
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.flickr.com/services/rest/%@", [self getParamList]]];
	
	XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:@"frob" parseError:nil];
	if ([[parser items] count] != 0) {
		NSLog(@"frob:");
		
		FROB = [NSMutableString stringWithString:(NSMutableString *)[(frob *)[[parser items] objectAtIndex:0] value]];
		NSLog(FROB);
		NSLog(@"/frob");
	}
	
	[FROB retain];
	return FROB;
}

-(NSMutableString *)getLoginURL {
	if (FROB == nil) {
		NSLog(@"FROB == nil...  getting frob:");
		[self getFrob];
		
	}
	[self clearParams];
	
	[self addParam:(NSMutableString *)@"api_key" withValue:(NSMutableString *)APIKEY];
	[self addParam:(NSMutableString *)@"perms" withValue:@"write"];
	[self addParam:(NSMutableString *)@"frob" withValue:FROB];
	
	NSMutableString *sig = [self getSig];
	
	[self addParam:(NSMutableString *)@"api_sig" withValue:(NSMutableString *)sig];
	
	NSLog([NSString stringWithFormat:@"login url = http://www.flickr.com/services/auth/%@", [self getParamList]]);
	
	return [NSString stringWithFormat:@"http://www.flickr.com/services/auth/%@", [self getParamList]];
}


-(BOOL)logout {
	
	FROB = nil;
	TOKEN = nil;
	NSLog([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://login.yahoo.com/config/login?logout=1"]]);
	return ([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://login.yahoo.com/config/login?logout=1"]] != NULL);
}

-(NSMutableString *)loginAs:(NSString *)USERNAME withPassword:(NSString *)PASSWORD {
	
	NSLog(@"dologin...");
	////[self getFrob];
	NSURL *url = [NSURL URLWithString: [self getLoginURL]];
	
	//[ [ UIApplication sharedApplication ] openURL: url];	
	
	NSMutableString *xml = [NSMutableString stringWithContentsOfURL:url];
	
	NSRange r = [xml rangeOfString:@"<form method=\"post\" action=\"https://login.yahoo.com/config/login"];
	if (r.location == NSNotFound) {
		[xml appendString:@"<script>document.forms[1].submit();</script>"];
//		return xml;
	} else {
		[xml appendFormat:@"<script>document.getElementById('username').value='%@'; document.getElementById('passwd').value='%@'; document.login_form.submit();</script>",
		 USERNAME,
		 PASSWORD];
//		return xml;
	}

	UIWebView *wv = [[UIWebView alloc] init];
	[wv setDelegate:self];
	[wv loadHTMLString:(NSString *)xml baseURL:[NSURL URLWithString:@"http://www.flickr.com"]];
	
	return @"";
	
	xml = (NSMutableString *)[xml substringFromIndex:(NSUInteger)r.location];
	
	r = [xml rangeOfString:@"</form>"];
	r.length = r.location + 7;
	r.location = 0;
	
	//we only want the <form>...</form> tag
	xml = (NSMutableString *)[xml substringWithRange:r];
	
	//need to make sure xml is a NSMutableString
	xml = [NSMutableString stringWithString:xml];
	//[xml setString:fixEmptyTags(xml, @"input")];
	/*
	//fix malformed <input> tags:
	//change <input...> to <input.../>
	r.location = 0;
	r.length = [xml length];
	while((r = [xml rangeOfString:@"<input" options:NSCaseInsensitiveSearch range:r]).location != NSNotFound) {
		r.length = [xml length] - r.location;
		r = [xml rangeOfString:@">" options:NSCaseInsensitiveSearch range:r];
		
		NSLog(@"range: %d, %d", r.location, r.length);
		[xml replaceCharactersInRange:r withString:@"/>"];
		r.length = [xml length] - r.location;
	}
	
	//remove all <label>...</label> tags... because XMLParser is too stupid to handle them for some reason
	//specifically, the problem is tags with attributes being nested inside tags that also have attributes.
	//
	r.location = 0;
	r.length = [xml length];
	while((r = [xml rangeOfString:@"<label" options:NSCaseInsensitiveSearch range:r]).location != NSNotFound) {
		NSUInteger oldloc = r.location;
		r.length = [xml length] - r.location;
		r = [xml rangeOfString:@"</label>" options:NSCaseInsensitiveSearch range:r];
		r.length = r.location - oldloc + 8;
		r.location = oldloc;
		NSLog(@"range: %d, %d", r.location, r.length);
		[xml deleteCharactersInRange:r];
		r.length = [xml length] - r.location;
	}

	//return (NSMutableString *)xml;
	
	XMLtoObject *parser = [[XMLtoObject alloc] parseXMLinString:xml toObject:@"form" parseError:nil];	
	
	//XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:@"form" parseError:nil];
	if ([[parser items] count] != 0) {
		NSLog(@"form:");
		NSLog(@"count: %d", [[parser items] count]);
		
		form *FORM = (form *)[[parser items] objectAtIndex:0];
		[FORM addField:@"username" withValue:USERNAME];
		//[FORM addField:@"passwd" withValue:PASSWORD];
		
		[FORM addField:@"passwd" withValue:[NSMutableString md5:
										   [NSMutableString stringWithFormat:@"%@%@",
										    [NSMutableString md5:PASSWORD], 
										    [[FORM fields] objectForKey:@".challenge"]
											]]];
		
		[FORM addField:@".md5" withValue:@"1"];
		[FORM addField:@".hash" withValue:@"1"];
		[FORM addField:@".js" withValue:@"1"];
		
		NSLog([FORM action]);
		
		for (NSString *key in [[FORM fields] allKeys]) {
			NSLog(@"input '%@' = %@", key, [[FORM fields] objectForKey:key]);

		}
		NSLog([FORM getURL]);
		
		
		NSLog(@"url:");
		
		NSMutableURLRequest *post = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [FORM action], [FORM parameterlist]]]];
		[post setHTTPMethod:@"GET"];
//		[post setHTTPBody:[NSData dataWithBytes:[[FORM parameterlist] dataUsingEncoding:NSASCIIStringEncoding] length:[[FORM parameterlist] length]]];
//		[post addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//		[post addValue:[NSString stringWithFormat:@"%d", [[FORM parameterlist] length]] forHTTPHeaderField:@"Content-Length"];
		
		NSURLResponse **response;
		NSError **err;
		
		NSLog(@"data:");
		
		NSLog(@"%@", [FORM parameterlist]);
		
		//NSURLConnection *conn = [NSURLConnection alloc];  //initWithRequest:(NSURLRequest *)post delegate:self];
		//NSData *data = [NSURLConnection sendSynchronousRequest:post returningResponse:response error:err];
		
		//NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
		
		//[conn start];
		
		NSLog(@"/form");
	}
	*/
	//NSLog(@"/dologin");
	return [NSString stringWithFormat:@"<html><head><script src=\"https://a248.e.akamai.net/sec.yimg.com/lib/reg/js/login_md5_1_14.js\" type=\"text/javascript\"></script></head><body>%@<script>document.getElementById('username').value='%@'; document.getElementById('passwd').value='%@'; document.login_form.submit();</script></body></html>", xml, USERNAME, PASSWORD];
}


-(NSMutableString *)getToken {
	////[self getFrob];
	//[self getLoginURL];
	
	
	[self clearParams];
	
	[self addParam:(NSMutableString *)@"method" withValue:(NSMutableString *)@"flickr.auth.getToken"];
	[self addParam:(NSMutableString *)@"api_key" withValue:(NSMutableString *)APIKEY];
	[self addParam:(NSMutableString *)@"frob" withValue:(NSMutableString *)[self FROB]];
	
	NSMutableString *sig = [self getSig];
	
	[self addParam:(NSMutableString *)@"api_sig" withValue:(NSMutableString *)sig];
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.flickr.com/services/rest/%@", [self getParamList]]];
	NSLog(@"token url: %@", [url absoluteURL]);
	
	XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:@"token" parseError:nil];
	if ([[parser items] count] != 0) {
		NSLog(@"token:");
		
		TOKEN = [NSMutableString stringWithString:(NSMutableString *)[(token *)[[parser items] objectAtIndex:0] value]];
		NSLog(TOKEN);
		NSLog(@"/token");
	}
	[TOKEN retain];
	return TOKEN;
}


-(BOOL)checkToken {
	[self clearParams];
	
	[self addParam:(NSMutableString *)@"method" withValue:(NSMutableString *)@"flickr.auth.checkToken"];
	[self addParam:(NSMutableString *)@"api_key" withValue:(NSMutableString *)APIKEY];
	[self addParam:(NSMutableString *)@"auth_token" withValue:(NSMutableString *)TOKEN];
	
	NSMutableString *sig = [self getSig];
	[self addParam:(NSMutableString *)@"api_sig" withValue:(NSMutableString *)sig];
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.flickr.com/services/rest/%@", [self getParamList]]];
	NSLog(@"check token url: %@", [url absoluteURL]);
	
	//NSLog(@"%@", [NSString stringWithContentsOfURL:url]);
	
	XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:@"token" parseError:nil];
	if ([[parser items] count] != 0) {
		
		return ([TOKEN isEqualToString:[(token *)[[parser items] objectAtIndex:0] value]]);
	}
	
	return NO;
}

-(NSMutableString *)getParamList {
	NSMutableString *list;
	list = [[NSMutableString alloc] init];
	[list setString:@"?"];
	
	for(NSString *key in [params allKeys]) {
		if ([list compare:@"?"] != NSOrderedSame)
			[list appendString:@"&"];
	
		[list appendString:(NSMutableString *)key];
		[list appendString:@"="];
		[list appendString:(NSString *)[params objectForKey:(NSString *)key]];
	}
	
	
	return list;
}

-(NSMutableString *)getSig {
	NSMutableString *list;
	list = [[NSMutableString alloc] init];
	[list setString:SECRET];
	
	for(NSString *key in [[params allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]) {
		NSLog(@"key '%@' = '%@'", key, [params objectForKey:(NSString *)key]);
		[list appendString:(NSString *)key];
		[list appendString:(NSString *)[params objectForKey:(NSString *)key]];
	}
	
	list = [NSMutableString md5:list];
	
	return list;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	NSLog(@"loading started");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSString *url = [NSString stringWithString:webView.request.URL.absoluteString];
	//NSRange r;
	//r.location = 0;
	//r.length = 36;
	NSLog(@"loaded: %@", url);
	
	if ([url isEqualToString:@"http://www.flickr.com/"]) {
		NSLog(@"bad internet connection?");
	
		if (loginDelegate != NULL) [loginDelegate didLogin:NO];
	
	} else if ([url isEqualToString:@"https://login.yahoo.com/config/login?"]) {
		NSLog(@"bad username/password?");
		
		if (loginDelegate != NULL) [loginDelegate didLogin:NO];
		
		
	} else if ([url isEqualToString:@"http://www.flickr.com/services/auth/"]) {
		NSLog(@"token: %@", [self getToken]);
		if (loginDelegate != NULL) [loginDelegate didLogin:YES];
		
		NSLog(@"%d", [self checkToken]);
	} else if ([url length] < 36) {
		//do nothing
	} else if ([[url substringToIndex:(NSUInteger)36] isEqualToString:@"http://www.flickr.com/services/auth/"]) {
		NSLog(@"submit: %@", [webView stringByEvaluatingJavaScriptFromString:@"document.forms[1].submit();"]);
	} else if (NO) {
		if (loginDelegate != NULL) [loginDelegate didLogin:NO];
	}
	
	NSLog(@"finished loading");
}


-(NSArray *)getPhotos {	
	[self clearParams];
	[self addParam:@"method" withValue:@"flickr.photos.search"];
	[self addParam:@"api_key" withValue:APIKEY];
	[self addParam:@"lat" withValue:@"40.7"];
	[self addParam:@"lon" withValue:@"-74"];
	[self addParam:@"extras" withValue:@"date_taken,date_upload,original_format,original_secret"];
	
	NSString *sig = [self getSig];
	
	[self addParam:@"api_sig" withValue:[NSString stringWithString:sig]];
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://api.flickr.com/services/rest/%@",
				  [self getParamList]]];
				  //method=flickr.photos.search&api_key=7aa8298476e07cb421f8cc396e655978&lat=40.7&lon=-74"];
	NSLog(@"xml: %@", [NSString stringWithContentsOfURL:url]);
	XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:@"photo" parseError:nil];
	
	return [parser items];
}

@end