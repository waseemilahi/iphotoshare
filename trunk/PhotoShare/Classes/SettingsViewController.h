//
//  SettingsViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __PhotoShare__. All rights reserved.
//

#import "PhotoShareAppDelegate.h"

@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate , UIWebViewDelegate, FlickrLoginDelegate >{

	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	UIWebView *webview;
	int count ;	
	NSMutableString *TOKEN;
	int signin_count;	
	IBOutlet UIView *signoutview;	
	IBOutlet UIActivityIndicatorView *indicatorview;	
	IBOutlet UILabel *fullnameLabel;
	IBOutlet UILabel *screennameLabel;	
	flickrapi *flickr;
}

- (IBAction) signIn:(id)sender;

- (IBAction) signOut:(id)sender;

- (IBAction) Register:(id)sender;

- (IBAction) AgainSignIn:(id)sender;

- (void) didLoginFail:(NSString *)fail withUserName:(NSString *)userName andFullName:(NSString *)fullName;

@property (nonatomic, retain) NSMutableString *TOKEN;
@property (nonatomic,retain) UIWebView *webview;
@property (nonatomic,retain) UIView *signoutview;
@property (nonatomic,retain) UIActivityIndicatorView *indicatorview;
@property (nonatomic, retain) flickrapi *flickr;

@end
