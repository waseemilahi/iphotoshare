//
//  CameraViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flickrapi.h"
#import "PhotoShareAppDelegate.h"

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, CLLocationManagerDelegate>{
	
	
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *pictureLabel;
	IBOutlet UIImagePickerController *imagePicker;
	CLLocationManager *locmanager;
	flickrapi *flickr;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) flickrapi *flickr;
@property (nonatomic, retain) CLLocationManager *locmanager;

- (IBAction) takePicture: (id) sender;
- (IBAction) viewPictures: (id) sender;

@end
