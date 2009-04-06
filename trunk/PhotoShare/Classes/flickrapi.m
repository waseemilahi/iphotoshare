#import "flickrapi.h"
#import "md5.h"
#import "XMLtoObject.h"

@implementation flickrapi : NSObject

@synthesize FROB;
@synthesize TOKEN;
@synthesize webview;

-(void)addParam: (NSMutableString *)key withValue:(NSMutableString *)value {
	if (!params) params = [[NSMutableDictionary alloc] init];
	[params setObject:(NSMutableString *)value forKey:(NSMutableString *)key];
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
	
	return FROB;
}

-(NSMutableString *)getLoginURL {
	if (FROB == nil) [self getFrob];
	[self clearParams];
	
	[self addParam:(NSMutableString *)@"api_key" withValue:(NSMutableString *)APIKEY];
	[self addParam:(NSMutableString *)@"perms" withValue:@"write"];
	[self addParam:(NSMutableString *)@"frob" withValue:FROB];
	
	NSMutableString *sig = [self getSig];
	
	[self addParam:(NSMutableString *)@"api_sig" withValue:(NSMutableString *)sig];
	
	NSLog([NSString stringWithFormat:@"http://www.flickr.com/services/auth/%@", [self getParamList]]);
	
	return [NSString stringWithFormat:@"http://www.flickr.com/services/auth/%@", [self getParamList]];
}

-( NSMutableString *)doLogin {
	////[self getFrob];
	NSURL *url = [NSURL URLWithString: [self getLoginURL]];
	
	[ [ UIApplication sharedApplication ] openURL: url];
	
	
	NSString *xml = [NSString stringWithContentsOfURL:url];
	
	NSRange r = [xml rangeOfString:@"<form "];
	xml = [xml substringFromIndex:(NSUInteger)r.location];
	
	r = [xml rangeOfString:@"</form>"];
	r.length = r.location + 7;
	r.location = 0;
	xml = [xml substringWithRange:r];
	
	XMLtoObject *parser = [[XMLtoObject alloc] parseXMLinString:xml toObject:@"form" parseError:nil];
	
	
	//XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:@"form" parseError:nil];
	if ([[parser items] count] != 0) {
		NSLog(@"form:");
		
		form *FORM = (form *)[[parser items] objectAtIndex:0];
		NSLog([FORM action]);
		
		for (NSString *key in [[FORM fields] allKeys]) {
			NSLog(@"input '%@' = %@", key, [[FORM fields] objectForKey:key]);
			
		}
		NSLog([FORM getURL]);
		
		NSLog(@"/form");
	}
	
	return @"</form>";
}


-(NSMutableString *)getToken {
	////[self getFrob];
	//[self getLoginURL];
	[self clearParams];
	
	[self addParam:(NSMutableString *)@"method" withValue:(NSMutableString *)@"flickr.auth.getToken"];
	[self addParam:(NSMutableString *)@"api_key" withValue:(NSMutableString *)APIKEY];
	[self addParam:(NSMutableString *)@"frob" withValue:(NSMutableString *)FROB];
	
	NSMutableString *sig = [self getSig];
	
	[self addParam:(NSMutableString *)@"api_sig" withValue:(NSMutableString *)sig];
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.flickr.com/services/rest/%@", [self getParamList]]];
	
	XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:@"token" parseError:nil];
	if ([[parser items] count] != 0) {
		NSLog(@"token:");
		
		TOKEN = [NSMutableString stringWithString:(NSMutableString *)[(token *)[[parser items] objectAtIndex:0] value]];
		NSLog(TOKEN);
		NSLog(@"/token");
	}
	
	return TOKEN;
	
	
	return (NSMutableString *)@"";
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
		[list appendString:(NSString *)key];
		[list appendString:(NSString *)[params objectForKey:(NSString *)key]];
	}
	
	list = [NSMutableString md5:list];
	
	return list;
}


@end