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

@synthesize flickr;
@synthesize photos;
@synthesize locmanager;
@synthesize imageView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


/*

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
 
 }

*/

-(MapMarker *) getMarker:(double)latitudes lng:(double)longitudes {//add lat and lng as parameters
	MapMarker *marker;
	
	
	switch (number) {
		case 0:
			marker = [MapMarker defaultBlueMarkerWithLat:latitudes Lng:longitudes];
			marker.data = @"red";
			break;
		case 1:
			marker = [MapMarker defaultGreenMarkerWithLat:latitudes Lng:longitudes];
			marker.data = @"green";
			break;
		case 2:
			marker = [MapMarker defaultRedMarkerWithLat:latitudes Lng:longitudes];
			marker.data = @"blue";
			break;
		case 3:
			marker = [MapMarker defaultYellowMarkerWithLat:latitudes Lng:longitudes];
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


-(void) clickedMarker:(MapMarker *) marker {
	NSString *message = [NSString stringWithFormat:@"[Lat: %lf, Lng: %lf] clicked",
						 marker.lat, marker.lng];
	messagesView.text = message;
	photo* ph = (photo *)[photos objectAtIndex:0];
	
	/** get location information for the photo and store it in the photo object **/
	[ph setLoc:(location *)[flickr getLocation:[[ph keys] objectForKey:@"id"]]];
	
	NSLog(@"photo");
	NSLog(@"-url: %@", [ph getPhotoUrl:4]);
	NSString* imageURL = [ph getPhotoUrl:4];
	
	NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
	
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	[imageView setImage:image];
	[self.view addSubview:imageView];
	[imageData release];
	[image release];
	
}


-(void) addUnDraggableMarker {
	MapMarker *marker = [self getMarker:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ];
	marker.draggable = YES;
	marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	
	locmanager = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate locmanager];
		
	mapView = [[MapView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];
	
	[self.view addSubview:mapView];
	
	messagesView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 375+20,self.view.bounds.size.width  , 20)];
	messagesView.backgroundColor = [UIColor blackColor];
	messagesView.textColor = [UIColor whiteColor];
	messagesView.font = [UIFont systemFontOfSize:13];
	messagesView.adjustsFontSizeToFitWidth = YES;
	[self.view addSubview:messagesView];
	
	MapMarker *marker =  [MapMarker defaultBlueMarkerWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"blue";
	marker.draggable = NO;
	marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
	
	[photos release];
	
	NSLog(@"%f %f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude);
	
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];

	[photos retain];
	
	UIButton *setCenterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[setCenterButton setTitle:@"draggable marker" forState:UIControlStateNormal];
	[setCenterButton addTarget:self action:@selector(addUnDraggableMarker) forControlEvents:UIControlEventTouchUpInside];
	setCenterButton.frame = CGRectMake(0, 360, 150, 30);
	[self.view addSubview:setCenterButton];
		
	
	
}
- (void)showMap: (id) sender{
	count++;
	
	if(mapView)[mapView release];
	
	mapView = [[MapView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];
	
	[self.view addSubview:mapView];
	
	messagesView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 375+20,self.view.bounds.size.width  , 20)];
	messagesView.backgroundColor = [UIColor blackColor];
	messagesView.textColor = [UIColor whiteColor];
	messagesView.font = [UIFont systemFontOfSize:13];
	messagesView.adjustsFontSizeToFitWidth = YES;
	[self.view addSubview:messagesView];
	
	MapMarker *marker =  [MapMarker defaultBlueMarkerWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"blue";
	marker.draggable = NO;
	marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
	
	[photos release];
	
	NSLog(@"%f %f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude);
	
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];
	
		
	
	
	[photos retain];
	
	
	
	UIButton *setCenterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[setCenterButton setTitle:@"draggable marker" forState:UIControlStateNormal];
	[setCenterButton addTarget:self action:@selector(addUnDraggableMarker) forControlEvents:UIControlEventTouchUpInside];
	setCenterButton.frame = CGRectMake(0, 360, 150, 30);
	[self.view addSubview:setCenterButton];
	
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
