//
//  CameraViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	UIImageView* imageView;
	
UIImagePickerController* imagePickerController;
}

@property (nonatomic, retain) UIImagePickerController *imagePickerController;

@end
