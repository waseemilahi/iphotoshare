#import "flickrapi.h"
#import "md5.h"
#import "XMLtoObject.h"

@implementation flickrapi : NSObject

@synthesize token;

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
		
		NSLog([(frob *)[[parser items] objectAtIndex:0] value]);
		
//		NSLog([val value]);
	}
		
	return (NSMutableString *)@"";
}

-(NSMutableString *)getToken {
	
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