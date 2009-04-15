//
//  SettingsViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotoShareAppDelegate.h"


@implementation SettingsViewController

@synthesize webview;
@synthesize signoutview;
@synthesize imageView;
@synthesize imagePicker;

@synthesize flickr;



- (IBAction)Register:(id)sender
{
	[username resignFirstResponder];
	[password resignFirstResponder];
	
	count++;
	
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromRight;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ;
	
	NSURL *url = [ [ NSURL alloc ] initWithString: @"http://m.flickr.com" ];
	
	webview = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];
	
	webview.delegate = self;
	webview.scalesPageToFit = YES;
	
	[webview loadRequest: [NSURLRequest requestWithURL:url]];
	
	
	[self.view addSubview:webview];
	
	
	
	
	
	//[ [ UIApplication sharedApplication ] openURL: url];
	
}
		
- (IBAction)signOut:(id)sender
{

	username.text = @"Username";
	password.text = @"Password";

	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromLeft;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ; 
	//[tabBarController.view addSubview: [tabBarController.viewControllers objectAtIndex:4]];
	//[tabBarController.view removeFromSuperview ];
	
	[[self.view.subviews lastObject] removeFromSuperview];
	
	count--;;
 
	
	[flickr logout];
	
}


- (IBAction)signIn:(id)sender
{
	[username resignFirstResponder];
	[password resignFirstResponder];
	//code goes here.	
	

	
/*	
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromRight;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ;
*/	
	flickr.loginDelegate = self;
	NSLog(@"logout: %d", [flickr logout]);
	

	[flickr loginAs:username.text withPassword:password.text];
/*		
	/*	webview = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];
	
		webview.delegate = self;
		webview.scalesPageToFit = YES;
	
	//	[webview loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:[flickr getLoginURL]]]];
	
	
		[self.view addSubview:webview];
	 */
}


- (void)signkeyin
{
	
	[password resignFirstResponder];
		flickr.loginDelegate = self;
	NSLog(@"logout: %d", [flickr logout]);
	
	
	[flickr loginAs:username.text withPassword:password.text];
}


- (void) didLoginFail:(BOOL)fail{
	
	if(fail){
	[username resignFirstResponder];
	[password resignFirstResponder];
	username.text = @"Username";
	password.text = @"Password";
	
		//login failed
		
			NSLog(@"login failed!");
		 
		 CATransition *myTransition = [ CATransition animation];
		 myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		 myTransition.type = kCATransitionPush;
		 myTransition.subtype = kCATransitionFromLeft;
		 [ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		 self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ;
		 
		 [flickr logout];
	}
	else{ 
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromRight;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ;

		if(signoutview != nil){[self.view addSubview:signoutview];count++;}
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	if(textField == password)[self signkeyin];
		
	return YES;
}

- (IBAction)AgainSignIn:(id)sender
{
	if(count >0)
	{
		//code goes here.
		
		username.text = @"Username";
		password.text = @"Password";
		
		
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromLeft;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ; 
		//[tabBarController.view addSubview: [tabBarController.viewControllers objectAtIndex:4]];
		//[tabBarController.view removeFromSuperview ];
		
		[[self.view.subviews lastObject] removeFromSuperview];
		[flickr logout];
		
		count--;
	}	
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//    [super viewDidLoad];
	
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
   	[username release];
	[password release];
	[webview release];
	
	[pictureLabel release];
	[imagePicker release];
	[imageView release];
	[super dealloc];
}


@end
