//
//  MapViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __PhotoShare__. All rights reserved.
//

#import "MapView.h"
#import "PhotoShareAppDelegate.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, FlickrLocationDelegate>{

	IBOutlet UIButton *save;
	IBOutlet UIActivityIndicatorView *indicatorview;
	IBOutlet UINavigationBar *mapBar;
	flickrapi *flickr;
	NSMutableArray *locations;
	IBOutlet MapView* mapView;
	BOOL isLocating;
	CLLocationManager *locmanager;
	BOOL wasFound;
	int count;
	int image_count;
	NSArray *photos;
	IBOutlet UIImageView *imageView;
}
@property (nonatomic, retain) UINavigationBar *mapBar;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic,retain) UIActivityIndicatorView *indicatorview;
@property (nonatomic, retain) CLLocationManager *locmanager;
@property (nonatomic, retain) flickrapi *flickr;
@property (nonatomic, retain) UIImageView *imageView;

- (void)location:(location *)loc ForPhoto:(photo *)ph;

- (IBAction) showMap: (id) sender;
- (IBAction) saveImage: (id)sender;
- (IBAction) goBack: (id)sender;

@end
