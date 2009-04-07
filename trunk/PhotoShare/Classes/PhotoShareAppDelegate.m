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

@synthesize flickr;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	
	flickr = [[flickrapi alloc] init];
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

