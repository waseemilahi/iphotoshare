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


@interface MapViewController : UIViewController <CLLocationManagerDelegate>{
IBOutlet UILabel *mapLabel;
	IBOutlet UILabel *locLabel;
	IBOutlet UITextField *longitude;
	IBOutlet UITextField *latitude;
	IBOutlet UITextField *lastupdate;
	CLLocationManager *locmanager;
	NSMutableArray *locations;
	MapView* mapView;
	BOOL isLocating;
BOOL wasFound;
	int count;
}
- (IBAction) showMap: (id) sender;
- (IBAction) locate: (id) sender;
- (IBAction) backToLocate:(id)sender;

@end
