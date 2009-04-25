//
//  PhotoShareAppDelegate.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "PhotoShareAppDelegate.h"
#import <QuartzCore/QuartzCore.h>


@implementation PhotoShareAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize webview;
@synthesize flickr;
@synthesize locmanager;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	count = 0;
	flickr = [[flickrapi alloc] init];
	self.locmanager = [[CLLocationManager alloc] init ];
	//[self.locmanager setDistanceFilter:1.0f];
	[self.locmanager setDelegate:self];
	[self.locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
	[self.locmanager startUpdatingLocation];
		
}

// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	
	CLLocation * currentLocation = locmanager.location;
	
	NSDate* newLocationeventDate = newLocation.timestamp;
	NSTimeInterval howRecentNewLocation = [newLocationeventDate timeIntervalSinceNow];
	
	// Needed to filter cached and too old locations
	if ((!currentLocation || currentLocation.horizontalAccuracy > newLocation.horizontalAccuracy) &&
		(howRecentNewLocation < -0.0 && howRecentNewLocation > -10.0)) {
		if (currentLocation)
			[currentLocation release];
		
		currentLocation = [newLocation retain];
	}
	
}


- (IBAction)homeAgainSignIn:(id)sender
{
	if(count >0)
	{
		//code goes here.
		
		
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromLeft;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0] ; 
		//[tabBarController.view addSubview: [tabBarController.viewControllers objectAtIndex:4]];
		//[tabBarController.view removeFromSuperview ];
		
		[[self.tabBarController.selectedViewController.view.subviews lastObject] removeFromSuperview];
		
		count--;
	}	
	
}


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
	
	
	
	
	
	//[ [ UIApplication sharedApplication ] openURL: url];
	
}

- (IBAction)homeSignIn:(id)sender
{
	//code goes here.
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromLeft;
	[ tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ; 
	//[tabBarController.view addSubview: [tabBarController.viewControllers objectAtIndex:4]];
	//[tabBarController.view removeFromSuperview ];
}
/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

