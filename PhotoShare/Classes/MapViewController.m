//
//  MapViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>

static int number = 0;

@implementation MapViewController

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backToLocate:(id)sender
{
	if(count >0)
	{
		//code goes here.
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromLeft;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2] ; 
		//[tabBarController.view addSubview: [tabBarController.viewControllers objectAtIndex:4]];
		//[tabBarController.view removeFromSuperview ];
		
		[[self.view.subviews lastObject] removeFromSuperview];
		
		[self setTitle:@"Map"];
		
		[locmanager startUpdatingLocation];
		
		count--;
	}	
	
}


- (void)showMap: (id) sender{
	count++;
	mapView = [[MapView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];
	[self setTitle:@"Map"];
//					 [[UIScreen mainScreen] applicationFrame]] autorelease];
	//[self.tabBarController.selectedViewController.view release];
	[self.view addSubview:mapView];
	
}


- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	if(newLocation.horizontalAccuracy > 0.0f && 
	   newLocation.horizontalAccuracy < 5.0f) { 
		if(locations.count > 3) { 
			[locmanager stopUpdatingLocation]; 
			[locmanager performSelector:@selector(startUpdatingLocation) 
							 withObject:nil 
							 afterDelay:10.0f]; 
		} 
		[locations addObject:newLocation]; 
	
		
		
			}
	
	latitude.text = [NSString stringWithFormat:@"%3.5f",
					 newLocation.coordinate.latitude];
	
	longitude.text = [NSString stringWithFormat:@"%3.5f",
					 newLocation.coordinate.longitude];
	[lastupdate resignFirstResponder];
	[longitude resignFirstResponder];
	[latitude resignFirstResponder];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ; 
	[inputFormatter setDateFormat:@"HH:mm:ss.SSSS"]; 
	NSDate *currentdate = [NSDate date];//[(CLLocation *)[locations lastObject] timestamp]; 
	lastupdate.text = [inputFormatter stringFromDate:currentdate];
	
	
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	[locations removeAllObjects];
	[locmanager stopUpdatingLocation];
	isLocating = NO;
}

/*

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
 
 }

*/

-(void)locate: (id) sender{
	
		wasFound = NO;
		[locmanager startUpdatingLocation];
	
}
-(MapMarker *) getMarker {//add lat and lng as parameters
	MapMarker *marker;
	GLatLng center = GLatLngMake(40.77,-73.988);//[mapView.map getCenterLatLng];
	
	switch (number) {
		case 0:
			marker = [MapMarker defaultRedMarkerWithLat:center.lat Lng:center.lng];
			marker.data = @"red";
			break;
		case 1:
			marker = [MapMarker defaultGreenMarkerWithLat:center.lat Lng:center.lng];
			marker.data = @"green";
			break;
		case 2:
			marker = [MapMarker defaultBlueMarkerWithLat:center.lat Lng:center.lng];
			marker.data = @"blue";
			break;
		case 3:
			marker = [MapMarker defaultYellowMarkerWithLat:center.lat Lng:center.lng];
			marker.data = @"yellow";
			break;
		default:
			break;
	}
	
	if (++number > 3)
		number = 0;
	
	return marker;
}

-(void) draggedMarker:(MapMarker *) marker {
	messagesView.text = @"dragging...";
}

-(void) releasedMarker:(MapMarker *) marker {
	NSString *message = [NSString stringWithFormat:@"[Lat: %lf, Lng: %lf]",
						 marker.lat, marker.lng];
	messagesView.text = message;
}


-(void) addDraggableMarker {
	MapMarker *marker = [self getMarker];
	marker.draggable = YES;
	marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
}


-(void) clickedMarker:(MapMarker *) marker {
	NSString *message = [NSString stringWithFormat:@"[Lat: %lf, Lng: %lf] clicked",
						 marker.lat, marker.lng];
	messagesView.text = message;
}


-(void) addUnDraggableMarker {
	MapMarker *marker = [self getMarker];
	marker.draggable = NO;
	marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	
	locmanager = [[CLLocationManager alloc] init ];
	[locmanager setDistanceFilter:1.0f];
	[locmanager setDelegate:self];
	[locmanager setDesiredAccuracy:kCLLocationAccuracyBest];
	[locmanager startUpdatingLocation];
	isLocating = YES;
//	locmanager.locations = [NSMutableArray arrayWithCapacity:32];
	locations = [NSMutableArray arrayWithCapacity:32];
	
	mapView = [[MapView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];
	[self setTitle:@"Map"];
	//					 [[UIScreen mainScreen] applicationFrame]] autorelease];
	//[self.tabBarController.selectedViewController.view release];
	[self.view addSubview:mapView];
	
	messagesView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 375+20,self.view.bounds.size.width  , 20)];
	messagesView.backgroundColor = [UIColor blackColor];
	messagesView.textColor = [UIColor whiteColor];
	messagesView.font = [UIFont systemFontOfSize:13];
	messagesView.adjustsFontSizeToFitWidth = YES;
	[self.view addSubview:messagesView];
	
	UIButton *setCenterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[setCenterButton setTitle:@"undraggable marker" forState:UIControlStateNormal];
	[setCenterButton addTarget:self action:@selector(addUnDraggableMarker) forControlEvents:UIControlEventTouchUpInside];
	setCenterButton.frame = CGRectMake(0, 360, 150, 30);
	[self.view addSubview:setCenterButton];
	
	UIButton *addMarkerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[addMarkerButton setTitle:@"draggable marker" forState:UIControlStateNormal];
	[addMarkerButton addTarget:self action:@selector(addDraggableMarker) forControlEvents:UIControlEventTouchUpInside];
	addMarkerButton.frame = CGRectMake(170, 360, 150, 30);
	[self.view addSubview:addMarkerButton];	
	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[locmanager release];
	[mapView release];
	[locations release];
	[longitude release];
	[latitude release];
	[lastupdate release];
	[locLabel release];
	[mapLabel release];
	[messagesView release];
	[super dealloc];
}


@end
