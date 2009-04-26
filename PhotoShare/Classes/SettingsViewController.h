//
//  SettingsViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flickrapi.h"


@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate , UIWebViewDelegate, FlickrLoginDelegate >{

	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	UIWebView *webview;
	int count ;
	
	NSMutableString *TOKEN;
	
	
	IBOutlet UIView *signoutview;
	IBOutlet UIView *invalidupview;
	IBOutlet UIView *badnetworkview;
	IBOutlet UIActivityIndicatorView *indicatorview;
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *fullnameLabel;
	IBOutlet UILabel *screennameLabel;
	IBOutlet UIImagePickerController *imagePicker;
	
	flickrapi *flickr;
}

- (IBAction) signIn:(id)sender;

- (IBAction) signOut:(id)sender;

- (IBAction) Register:(id)sender;

- (IBAction) AgainSignIn:(id)sender;

- (IBAction)InvalidsignIn:(id)sender;

- (IBAction)BNetworksignIn:(id)sender;

- (void) didLoginFail:(NSString *)fail withUserName:(NSString *)userName andFullName:(NSString *)fullName;
@property (nonatomic, retain) NSMutableString *TOKEN;
@property (nonatomic,retain) UIWebView *webview;
@property (nonatomic,retain) UIView *signoutview;
@property (nonatomic,retain) UIView *invalidupview;
@property (nonatomic,retain) UIView *badnetworkview;
@property (nonatomic,retain) UIActivityIndicatorView *indicatorview;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) flickrapi *flickr;

@end
