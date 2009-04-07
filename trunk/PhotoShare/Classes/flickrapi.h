#import <UIKit/UIKit.h>

#import "XMLtoObject.h"

// flickr
#define APIKEY @"7aa8298476e07cb421f8cc396e655978"
#define SECRET @"8db5a9f831e6a766"

//extern flickrapi *FLICKR;
@protocol FlickrLoginDelegate <NSObject>

- (void)didLogin:(BOOL)success;

@end

@interface flickrapi : NSObject <UIWebViewDelegate> {
	NSMutableString *FROB;
	NSMutableString *TOKEN;
	NSMutableDictionary *params;
	
	id<FlickrLoginDelegate> loginDelegate;
}

@property (nonatomic, retain) NSMutableString *FROB;
@property (nonatomic, retain) NSMutableString *TOKEN;

@property (assign) id<FlickrLoginDelegate> loginDelegate; 

-(void)addParam:(NSMutableString *)key withValue:(NSMutableString *)value;
-(void)clearParams;

-(NSMutableString *)getFrob;
-(NSMutableString *)getLoginURL;

-(NSMutableString *)loginAs:(NSString *)USERNAME withPassword:(NSString *)PASSWORD;

-(NSMutableString *)getToken:(NSMutableString *)F;

-(NSMutableString *)getParamList;
-(NSMutableString *)getSig;


-(NSArray *)getPhotos;

-(void)webViewDidStartLoad:(UIWebView *)webView;
-(void)webViewDidFinishLoad:(UIWebView *)webView;

@end
