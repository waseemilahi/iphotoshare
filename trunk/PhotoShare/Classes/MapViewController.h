//
//  MapViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "PhotoShareAppDelegate.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate>{
IBOutlet UILabel *mapLabel;
	IBOutlet UILabel *locLabel;
	IBOutlet UITextField *longitude;
	IBOutlet UITextField *latitude;
	IBOutlet UITextField *lastupdate;
	IBOutlet UIButton *save;
	IBOutlet UIActivityIndicatorView *indicatorview;
	 flickrapi *flickr;
	NSMutableArray *locations;
	IBOutlet MapView* mapView;
	BOOL isLocating;
	UILabel *messagesView;
	CLLocationManager *locmanager;
BOOL wasFound;
	int count;
	int image_count;
	NSArray *photos;
	IBOutlet UIImageView *imageView;
}
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic,retain) UIActivityIndicatorView *indicatorview;
@property (nonatomic, retain) CLLocationManager *locmanager;
@property (nonatomic, retain) flickrapi *flickr;
@property (nonatomic, retain) UIImageView *imageView;
- (IBAction) showMap: (id) sender;
- (IBAction) saveImage: (id)sender;
-(IBAction)goBack:(id)sender;

@end
