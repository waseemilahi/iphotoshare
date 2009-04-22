#import <UIKit/UIKit.h>
#import <Foundation/NSHTTPCookieStorage.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

#import "XMLtoObject.h"

// flickr
#define APIKEY @"7aa8298476e07cb421f8cc396e655978"
#define SECRET @"8db5a9f831e6a766"

//extern flickrapi *FLICKR;
@protocol FlickrLoginDelegate <NSObject>

- (void)didLoginFail:(NSString *)fail;


@end

@interface flickrapi : NSObject <UIWebViewDelegate , CLLocationManagerDelegate> {
	NSMutableString *FROB;
	NSMutableString *TOKEN;
	NSMutableDictionary *params;
	NSHTTPCookieStorage *cookies;
	NSArray *cookie;
	NSHTTPURLResponse *response;
	CLLocationManager *locmanager;
	NSMutableArray *locations;
	int count ;
		BOOL isLocating;
	
	id<FlickrLoginDelegate> loginDelegate;
}

@property (nonatomic, retain) NSMutableString *FROB;
@property (nonatomic, retain) NSMutableString *TOKEN;
@property (nonatomic, retain) NSHTTPCookieStorage *cookies;
@property (nonatomic, retain) NSArray *cookie;
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, retain) CLLocationManager *locmanager;

@property (assign) id<FlickrLoginDelegate> loginDelegate; 

-(void)addParam:(NSMutableString *)key withValue:(NSMutableString *)value;
-(void)clearParams;
-(void)setLocationManager;

-(NSMutableString *)getFrob;
-(NSMutableString *)getLoginURL;

-(BOOL)logout;
-(NSMutableString *)loginAs:(NSString *)USERNAME withPassword:(NSString *)PASSWORD;

-(NSMutableString *)getToken;
-(BOOL)checkToken;

-(NSMutableString *)getParamList;
-(NSMutableString *)getSig;


-(NSArray *)getPhotos;

-(void)webViewDidStartLoad:(UIWebView *)webView;
-(void)webViewDidFinishLoad:(UIWebView *)webView;

@end
