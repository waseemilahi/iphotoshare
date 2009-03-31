// XMLtoObject.h
#import <UIKit/UIKit.h>

@interface XMLtoObject : NSObject {
	NSString *className;
	NSMutableArray *items;
	NSObject *item; // stands for any class
    NSString *currentNodeName;
	NSMutableString *currentNodeContent;
}
- (NSArray *)items;
- (id)parseXMLAtURL:(NSURL *)url 
		   toObject:(NSString *)aClassName 
		 parseError:(NSError **)error;
@end

//photo object
@interface photo : NSObject {
	NSString *url;
}

@property (nonatomic, retain) NSString *url;

-(void)setPhotoUrl:(NSString *)pid farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret;

@end

//frob object
@interface frob : NSObject {
	NSString *value;
}

@property (nonatomic, retain) NSString *value;

-(void)setValue:(NSString *)val;

@end