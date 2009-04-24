//
//  MapViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "PhotoShareAppDelegate.h"


@interface MapViewController : UIViewController <CLLocationManagerDelegate>{
IBOutlet UILabel *mapLabel;
	IBOutlet UILabel *locLabel;
	IBOutlet UITextField *longitude;
	IBOutlet UITextField *latitude;
	IBOutlet UITextField *lastupdate;
	 flickrapi *flickr;
	NSMutableArray *locations;
	MapView* mapView;
	BOOL isLocating;
	UILabel *messagesView;
	CLLocationManager *locmanager;
BOOL wasFound;
	int count;
}

@property (nonatomic, retain) CLLocationManager *locmanager;
@property (nonatomic, retain) flickrapi *flickr;
- (IBAction) showMap: (id) sender;

@end
