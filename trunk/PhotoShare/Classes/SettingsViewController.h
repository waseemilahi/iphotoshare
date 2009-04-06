//
//  SettingsViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLtoObject.h"
#import "flickrapi.h"


@interface SettingsViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate , UIWebViewDelegate>{

	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
	UIWebView *webview;
	int count ;
		
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *pictureLabel;
	IBOutlet UIImagePickerController *imagePicker;
	
}

- (IBAction) signIn:(id)sender;

- (IBAction) Register:(id)sender;

- (IBAction) AgainSignIn:(id)sender;

@property (nonatomic,retain) UIWebView *webview;


@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;

@end
