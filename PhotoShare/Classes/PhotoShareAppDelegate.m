//
//  PhotoShareAppDelegate.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright __PhotoShare__ 2009. All rights reserved.
//

#import "PhotoShareAppDelegate.h"

@implementation PhotoShareAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize webview;
@synthesize flickr;
@synthesize locmanager;

//The function that's called right after the app finishes loading.
//It initializes the flickr and the location manager objects.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	[tabBarController setDelegate:self ];
	
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	count = 0;
	flickr = [[flickrapi alloc] init];
	self.locmanager = [[CLLocationManager alloc] init ];
	[self.locmanager setDistanceFilter:1.0f];
	[self.locmanager setDelegate:self];
	[self.locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
	[self.locmanager startUpdatingLocation];
	
	tab_loc_count = 0;
			
}

//Shows the alertview on the application startup, letting the user know that the app uses the location services.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	
	if((self.tabBarController.selectedViewController == [self.tabBarController.viewControllers objectAtIndex:0]) && tab_loc_count == 0)
	{
		tab_loc_count++;
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"PhotoShare Will Use Your Current Location To Download/Upload Pictures" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[myAlertView show];
		[myAlertView release];
	}
}
	
//Called when user wants to return to the home screen after registering on the flickr.com
- (IBAction)homeAgainSignIn:(id)sender
{
	if(count >0)
	{
		
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromLeft;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0] ; 
		[[self.tabBarController.selectedViewController.view.subviews lastObject] removeFromSuperview];
		
		count--;
	}	
	
}

//Called when the register button is pressed on the main screen.
- (IBAction)homeRegister:(id)sender
{	
	
	count ++;
	
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromRight;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0] ;
	
	NSURL *url = [ [ NSURL alloc ] initWithString: @"http://m.flickr.com" ];
	
	webview = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 43,self.tabBarController.selectedViewController.view.bounds.size.width ,375)];	
	webview.delegate = self;
	webview.scalesPageToFit = YES;	
	[webview loadRequest: [NSURLRequest requestWithURL:url]];	
	[self.tabBarController.selectedViewController.view addSubview:webview];

}

//Takes you to the Account Tab when called.
- (IBAction)homeSignIn:(id)sender
{
	
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromLeft;
	[ tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ; 
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

