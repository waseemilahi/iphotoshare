//
//  SettingsViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flickrapi.h"


@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate , UIWebViewDelegate, FlickrLoginDelegate>{

	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	UIWebView *webview;
	int count ;
		
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *pictureLabel;
	IBOutlet UIImagePickerController *imagePicker;
	
	flickrapi *flickr;
}

- (IBAction) signIn:(id)sender;

- (IBAction) Register:(id)sender;

- (IBAction) AgainSignIn:(id)sender;

- (void) didLogin:(BOOL)success;

@property (nonatomic,retain) UIWebView *webview;


@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) flickrapi *flickr;

@end
