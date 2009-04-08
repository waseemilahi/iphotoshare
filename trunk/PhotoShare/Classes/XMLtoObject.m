// XMLToObject.m
#import "XMLtoObject.h"
//#import "photo.h"


// photo object

// photo.m
//#import "photo.h"
@implementation photo

@synthesize url;
-(void)setPhotoUrl:(NSString *)pid farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret {
	url = [NSMutableString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@.jpg", farm, server, pid, secret];
	[url retain];
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


// form object
@implementation form

@synthesize fields;
@synthesize action;
@synthesize parameterlist;

-(void)clearFields {
	if(fields) [fields release];
	fields = [[NSMutableDictionary alloc] init];
	
	NSLog(@"form fields cleared.");
	return;
}

-(void)setFields:(NSMutableDictionary *)fs {
	if(fields) [fields release];
	fields = fs;
	
	NSLog(@"form fields set.");
	return;
}

-(void)addField:(NSMutableString *)field withValue:(NSMutableString *)value {
	if(!fields) fields = [[NSMutableDictionary alloc] init];
	[fields setObject:value forKey:field];
	NSLog(@"form field added: %@ = %@.", field, value);
	return;
}

-(void)setAction:(NSMutableString *)act {
	action = act;
}

-(NSString *)getURL {
	NSMutableString *url = [NSMutableString stringWithString:@""];
	if (parameterlist) [parameterlist release];
	
	parameterlist = [NSMutableString stringWithString:@""];
	
	for (NSString* field in fields) {
		if([parameterlist length] > 0) [parameterlist appendString:@"&"];
		[parameterlist appendString:field];
		[parameterlist appendString:@"="];
		[parameterlist appendString:[fields objectForKey:field]];
	}
	[url appendString:action];
	[url appendString:parameterlist];
	
	NSLog(@"url = %@", url);
	
	return url;
}

@end


// token object
@implementation token

@synthesize value;
-(void)setValue:(NSString *)val {
	if(value) [value release];
	value = [[NSString alloc] initWithString:val];
	
	NSLog(@"token value set: %@", val);
	return;
}

@end


// XMLtoObject

@implementation XMLtoObject

- (NSArray *)items
{
	return items;
}

- (id)parseXMLinString:(NSString *)xml 
		   toObject:(NSString *)aClassName 
		 parseError:(NSError **)error
{
	//NSLog(@"xml string:");
	//NSLog(xml);
	
	[items release];
	items = [[NSMutableArray alloc] init];
	
	className = aClassName;
	
	NSData *data = [xml dataUsingEncoding: NSASCIIStringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	
	[parser parse];
	
	if([parser parserError] && error) {
		*error = [parser parserError];
	}
	
	[parser release];
	
	return self;
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
		} else if ([elementName isEqualToString: @"token"]) {
			//this code is moved to didEndElement, since currentNodeContent is not filled yet when didStartElement is called
			//[(frob *)item setValue:currentNodeContent];
		} else if ([elementName isEqualToString:@"form"]) {
			//set the form action
			[(form *)item setAction:[attributeDict objectForKey:@"action"]];
		}
	} else if ([elementName isEqualToString:@"input"] && [item isKindOfClass:[form class]]) {
		//add the form variables and their values
		[(form *)item addField:[attributeDict objectForKey:@"name"] withValue:[attributeDict objectForKey:@"value"]];
		
	} else {
		currentNodeName = [elementName copy];
		currentNodeContent = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	NSLog(@"Closing tag: %@", elementName);
	
	if([elementName isEqualToString:className]) {
		
		if ([elementName isEqualToString: @"frob"]) {
			[(frob *)item setValue:[currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		} else if ([elementName isEqualToString: @"token"]) {
			[(token *)item setValue:[currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		}
	
		[items addObject:item];
		
		[item release];
		item = nil;
	}
	else if([elementName isEqualToString:currentNodeName]) {
		// use key-value coding       
		//NSLog(@"currentNodeContent: %@", currentNodeContent);
		NSLog(@"elementName: %@", elementName);
		//[item setValue:currentNodeContent forKey:elementName];
		
		[currentNodeContent release];
		currentNodeContent = nil;
		
		[currentNodeName release];
		currentNodeName = nil;
	}
	NSLog(@"Closed tag.");
}

- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{   
	[currentNodeContent appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog([(NSError *)parseError localizedDescription]);
}

- (void)dealloc
{
	[items release];
	[super dealloc];
}

@end