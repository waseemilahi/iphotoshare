//
//  PhotoShareAppDelegate.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright __PhotoShare__ 2009. All rights reserved.
//

#import "flickrapi.h"
#import <QuartzCore/QuartzCore.h>

@interface PhotoShareAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate,UIWebViewDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UIWebView *webview;
	int count;
	flickrapi *flickr;	
	CLLocationManager *locmanager;
	int tab_loc_count ;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic,retain) UIWebView *webview;
@property (nonatomic, retain) CLLocationManager *locmanager;
@property (nonatomic, retain) flickrapi *flickr;

- (IBAction) homeSignIn:(id)sender;
- (IBAction) homeRegister:(id)sender;
- (IBAction) homeAgainSignIn:(id)sender;
@end