#import <UIKit/UIKit.h>

// flickr
#define APIKEY @"7aa8298476e07cb421f8cc396e655978"
#define SECRET @"8db5a9f831e6a766"

@interface flickrapi : NSObject {
	NSMutableString *token;
	NSMutableDictionary *params;
}

@property (nonatomic, retain) NSMutableString *token;

-(void)addParam:(NSMutableString *)key withValue:(NSMutableString *)value;
-(void)clearParams;

-(NSMutableString *)getFrob;
-(NSMutableString *)getToken;

-(NSMutableString *)getParamList;
-(NSMutableString *)getSig;

@end
