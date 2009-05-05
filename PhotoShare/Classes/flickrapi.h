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

- (void)didLoginFail:(NSString *)fail withUserName:(NSString *)userName andFullName:(NSString *)fullName ;

@end

@protocol FlickrLocationDelegate <NSObject>

- (void)location:(location *)loc ForPhoto:(photo *)ph;

@end
/*
@interface PhotoConnection : NSURLConnection {
	photo *ph;
}
@property (nonatomic, retain) photo *ph;
@end
*/
@interface flickrapi : NSObject <UIWebViewDelegate , CLLocationManagerDelegate> {
	NSMutableString *FROB;
	NSMutableString *TOKEN;
	NSMutableDictionary *params;
	NSHTTPCookieStorage *cookies;
	NSArray *cookie;
	
	NSMutableData *receivedData;
	
	int count ;
	BOOL isLocating;
	
	id<FlickrLoginDelegate> loginDelegate;
	id<FlickrLocationDelegate> locationDelegate;
}

@property (nonatomic, retain) NSMutableString *FROB;
@property (nonatomic, retain) NSMutableString *TOKEN;
@property (nonatomic, retain) NSHTTPCookieStorage *cookies;
@property (nonatomic, retain) NSArray *cookie;



@property (assign) id<FlickrLoginDelegate> loginDelegate; 
@property (assign) id<FlickrLocationDelegate> locationDelegate; 

-(void)addParam:(NSMutableString *)key withValue:(NSMutableString *)value;
-(void)clearParams;

-(NSMutableString *)getFrob;
-(NSMutableString *)getLoginURL;

-(BOOL)logout;
-(NSMutableString *)loginAs:(NSString *)USERNAME withPassword:(NSString *)PASSWORD;

-(NSMutableString *)getToken;
-(BOOL)checkToken;
-(NSArray *)checkUserToken;

-(NSMutableString *)getParamList;
-(NSMutableString *)getSig;

-(NSArray *)getPhotos:(double)latitude lng:(double)longitude;
-(location *)getLocation:(NSString *)pid;
-(void)getLocationOfPhoto:(photo *)p;

-(BOOL)uploadPhoto:(UIImage *)image withLat:(double)lat andLon:(double)lon withName:(NSString *)imageName;

-(BOOL)setLocationOfPhoto:(NSString *)pid withLat:(double)lat andLon:(double)lon;

-(void)webViewDidStartLoad:(UIWebView *)webView;
-(void)webViewDidFinishLoad:(UIWebView *)webView;

@end
