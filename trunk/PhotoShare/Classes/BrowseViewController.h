//
//  BrowseViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "flickrapi.h"
#import "PhotoShareAppDelegate.h"

@interface BrowseViewController : UIViewController <UIImagePickerControllerDelegate> {
	
	IBOutlet UIImageView *imageView;
	IBOutlet UILabel *pictureLabel;
	IBOutlet UIImagePickerController *imagePicker;
	
	//temporary, for testing:
	//IBOutlet UIWebView *webView;
	
	flickrapi *flickr;
	NSArray *photos;
	CGPoint startPoint;
	NSTimeInterval startTime;
	NSUInteger p;
}

@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *pictureLabel;
@property (nonatomic, retain) flickrapi *flickr;
@property (nonatomic, retain) NSArray *photos;
//@property (nonatomic, retain) CGPoint startPoint;
//@property (nonatomic, retain) NSTimeInterval startTime;

//for testing:
//@property (nonatomic, retain) UIWebView *webView;	

- (IBAction) showPicture: (id) sender;
- (void) loadPhoto:(NSUInteger)index;

@end
