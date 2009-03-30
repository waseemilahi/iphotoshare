// XMLtoObject.h
#import <UIKit/UIKit.h>

@interface XMLtoObject : NSObject {
	NSString *className;
	NSMutableArray *items;
	NSObject *item; // stands for any class    NSString *currentNodeName;
	NSMutableString *currentNodeContent;
}
- (NSArray *)items;
- (id)parseXMLAtURL:(NSURL *)url 
		   toObject:(NSString *)aClassName 
		 parseError:(NSError **)error;
@end