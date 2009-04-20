//
//  CameraViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate>{
	
	
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *pictureLabel;
	IBOutlet UIImagePickerController *imagePicker;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;

- (IBAction) takePicture: (id) sender;
- (IBAction) viewPictures: (id) sender;

@end
