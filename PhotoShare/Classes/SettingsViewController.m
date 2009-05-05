//
//  SettingsViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __PhotoShare__. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize webview;
@synthesize signoutview;
@synthesize indicatorview;
@synthesize flickr;
@synthesize TOKEN;


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
	[[self.view.subviews lastObject] removeFromSuperview];
	
	count--;;
 	
	[flickr logout];
	
}


- (IBAction)signIn:(id)sender
{
	[username resignFirstResponder];
	[password resignFirstResponder];
	
	
   	if(signin_count == 0)[self.view addSubview:indicatorview];
	
	signin_count++;

	flickr.loginDelegate = self;
	NSLog(@"logout: %d", [flickr logout]);
	

	[flickr loginAs:username.text withPassword:password.text];
	 
}

- (void)signkeyin
{
	
	[password resignFirstResponder];
		flickr.loginDelegate = self;
	NSLog(@"logout: %d", [flickr logout]);
	
	[flickr loginAs:username.text withPassword:password.text];
	[self.view addSubview:indicatorview];
}


- (void) didLoginFail:(NSString *)fail withUserName:(NSString *)userName andFullName:(NSString *)fullName{
	
	if([fail isEqualToString:@"bad username/password"] ){
		[username resignFirstResponder];
		[password resignFirstResponder];
		username.text = @"Username";
		password.text = @"Password";
			
		NSLog(@"login failed!");		
		
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Bad Username/Password" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
	
		[myAlertView show];
		[myAlertView release];
		
		[flickr logout];
		if(signin_count == 1)[[self.view.subviews lastObject] removeFromSuperview];
		
		signin_count--;
		
	}
	else if([fail isEqualToString:@"bad internet connection"]){
		[username resignFirstResponder];
		[password resignFirstResponder];
		username.text = @"Username";
		password.text = @"Password";
				
		NSLog(@"login failed!");
		
		UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Bad Internet Connection" delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
		
		[myAlertView show];
		[myAlertView release];
	
		[flickr logout];
		if(signin_count == 1)[[self.view.subviews lastObject] removeFromSuperview];
		
		signin_count--;
		
		
	}
	else if([fail isEqualToString:@"http://www.flickr.com/services/auth/"]){ 
		if(username.text == @"Username" || password.text == @"Password")
			[self didLoginFail:@"bad username/password" withUserName:userName andFullName:fullName];
		else{
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromRight;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ;
			[[self.view.subviews lastObject] removeFromSuperview];
			screennameLabel.text = userName;
			fullnameLabel.text = fullName;
		if(signoutview != nil){[self.view addSubview:signoutview];count++;}
			signin_count--;
				
		}
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
				
		username.text = @"Username";
		password.text = @"Password";
		
		
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromLeft;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:4] ; 
		
		[[self.view.subviews lastObject] removeFromSuperview];
		[flickr logout];
		
		count--;
	}	
	
}

- (void)viewDidLoad {
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	signin_count = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
   	[username release];
	[password release];
	[webview release];	
	[screennameLabel release];
	[fullnameLabel release];
	[super dealloc];
}


@end
