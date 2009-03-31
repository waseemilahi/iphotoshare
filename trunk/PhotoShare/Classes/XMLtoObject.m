// XMLToObject.m
#import "XMLtoObject.h"
//#import "photo.h"


// photo object

// photo.m
//#import "photo.h"
@implementation photo

@synthesize url;
-(void)setPhotoUrl:(NSString *)pid farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret {
	url = [NSMutableString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", farm, server, pid, secret];
	
	return;
}

@end


// frob object
@implementation frob

@synthesize value;
-(void)setValue:(NSString *)val {
	if(value) [value release];
	value = [[NSString alloc] initWithString:val];
	
	NSLog(@"frob value set: %@", val);
	return;
}

@end



// XMLtoObject

@implementation XMLtoObject

- (NSArray *)items
{
	return items;
}

- (id)parseXMLAtURL:(NSURL *)url 
		   toObject:(NSString *)aClassName 
		 parseError:(NSError **)error
{
	[items release];
	items = [[NSMutableArray alloc] init];
	
	className = aClassName;
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[parser setDelegate:self];
	
	[parser parse];
	
	if([parser parserError] && error) {
		*error = [parser parserError];
	}
	
	[parser release];
	
	return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict
{
	NSLog(@"Open tag: %@", elementName);
	for (id key in attributeDict)
		NSLog(@"key: %@, value: %@", key, [attributeDict objectForKey:key]);

	if([elementName isEqualToString:className]) {
		// create an instance of a class on run-time
		item = [[NSClassFromString(className) alloc] init];
		
		if ([elementName isEqualToString:@"photo"]) {
			//generate and set the item's url
			[(photo *)item setPhotoUrl:	[attributeDict objectForKey:@"id"]
								farm:	[attributeDict objectForKey:@"farm"]
								server:	[attributeDict objectForKey:@"server"]
								secret:	[attributeDict objectForKey:@"secret"]
			 ];
		} else if ([elementName isEqualToString: @"frob"]) {
			//this code is moved to didEndElement, since currentNodeContent is not filled yet when didStartElement is called
			//[(frob *)item setValue:currentNodeContent];
		}
	}
	else {
		currentNodeName = [elementName copy];
		currentNodeContent = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	NSLog(@"Close tag: %@", elementName);
	
	if([elementName isEqualToString:className]) {
		
		if ([elementName isEqualToString: @"frob"]) {
			[(frob *)item setValue:[currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		}
	
		[items addObject:item];
		
		[item release];
		item = nil;
	}
	else if([elementName isEqualToString:currentNodeName]) {
		// use key-value coding       
		[item setValue:currentNodeContent forKey:elementName];
		
		[currentNodeContent release];
		currentNodeContent = nil;
		
		[currentNodeName release];
		currentNodeName = nil;
	}
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{   
	[currentNodeContent appendString:string];
}

- (void)dealloc
{
	[items release];
	[super dealloc];
}

@end