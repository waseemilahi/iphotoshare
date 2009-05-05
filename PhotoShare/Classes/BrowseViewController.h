//
//  BrowseViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __PhotoShare__. All rights reserved.
//

#import "PhotoShareAppDelegate.h"

@interface BrowseViewController : UIViewController <UIImagePickerControllerDelegate, CLLocationManagerDelegate> {
	
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *pictureLabel;
	IBOutlet UIImagePickerController *imagePicker;
    IBOutlet UIBarButtonItem *update;
	int count;
	CLLocationManager *locmanager;
		
	flickrapi *flickr;
	NSArray *photos;
	CGPoint startPoint;
	NSTimeInterval startTime;
	NSUInteger p;
}

@property (nonatomic, retain) UIBarButtonItem *update;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *pictureLabel;
@property (nonatomic, retain) flickrapi *flickr;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) CLLocationManager *locmanager;

- (IBAction) showPicture: (id) sender;
- (IBAction) saveImage: (id)sender;
- (void) loadPhoto:(NSUInteger)index;

@end
