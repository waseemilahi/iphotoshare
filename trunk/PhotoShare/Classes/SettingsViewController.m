//
//  SettingsViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>



@implementation SettingsViewController

@synthesize webview;
@synthesize imageView;
@synthesize imagePicker;

- (IBAction)Register:(id)sender
{
	NSURL *url = [ [ NSURL alloc ] initWithString: @"http:flickr.com" ];
	[ [ UIApplication sharedApplication ] openURL: url];
	
}

- (IBAction)AgainSignIn:(id)sender
{
	//code goes here.
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromLeft;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ; 
	//[tabBarController.view addSubview: [tabBarController.viewControllers objectAtIndex:4]];
	//[tabBarController.view removeFromSuperview ];
	
	
}
- (IBAction)signIn:(id)sender
{
	[username resignFirstResponder];
	[password resignFirstResponder];
	//code goes here.	
	

	
		flickrapi *flickr = [[flickrapi alloc] init];
		
		[flickr addParam:@"test3" withValue:@"value1"];
		[flickr addParam:@"test2" withValue:@"value2"];
		[flickr addParam:@"test4" withValue:@"value3"];
		[flickr addParam:@"aaaaa" withValue:@"value4"];
		[flickr addParam:@"zzzzz" withValue:@"value5"];
		
		NSLog([flickr getParamList]);
		NSLog([flickr getSig]);
		
		NSLog([flickr getFrob]);
		NSLog([flickr getParamList]);
		
		NSLog([flickr getLoginURL]);
		NSLog([flickr getParamList]);
		
		
		
	
		webview = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 45,self.view.bounds.size.width ,375)];
	
		webview.delegate = self;
		webview.scalesPageToFit = YES;
	
		[webview loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[flickr getLoginURL]]]];
	
	
		[self.view addSubview:webview];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
	[username release];
	[password release];
	[webview release];
}


@end
