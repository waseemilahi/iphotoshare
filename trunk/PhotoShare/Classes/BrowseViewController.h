//
//  BrowseViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flickrapi.h"

@interface BrowseViewController : UIViewController <UIImagePickerControllerDelegate> {
	
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *pictureLabel;
	IBOutlet UIImagePickerController *imagePicker;
	
	//temporary, for testing:
	//IBOutlet UIWebView *webView;
	
	IBOutlet flickrapi *flickr;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) flickrapi *flickr;

//for testing:
//@property (nonatomic, retain) UIWebView *webView;	

- (IBAction) showPicture: (id) sender;

@end
