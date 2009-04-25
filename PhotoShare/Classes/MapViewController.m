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
	
	
	int i;
	
	photo* ph;
	
	
	for(i = 0; i < [photos count]; i++)
	{
		ph = (photo *)[photos objectAtIndex:i];
		
		/** get location information for the photo and store it in the photo object **/
		[ph setLoc:(location *)[flickr getLocation:[[ph keys] objectForKey:@"id"]]];
	
	
	
		if(([[ph getLatitude] doubleValue] == marker.lat) && ([[ph getLongitude] doubleValue] == marker.lng))	
		{				
			NSString* imageURL = [ph getPhotoUrl:4];
		
			NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];	

			UIImage* image = [[UIImage alloc] initWithData:imageData];
		
			//imageView.frame = CGRectMake(0.0, 43.0,self.view.bounds.size.width ,375);
		
			[imageView setImage:image];
		
			[self.view addSubview:imageView];
		
			[imageData release];
		
			[image release];	
		
			image_count++;
			
			break;
	
		}
	}
	
}

-(IBAction)goBack:(id)sender{
	if(image_count > 0){
		image_count--;
		[[self.view.subviews lastObject] removeFromSuperview];
	}
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
			
	
	
	[photos release];
	
	NSLog(@"%f %f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude);
	
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];
	
	int i;
	
	photo* ph;
	
	
	for(i = 0; i < [photos count]; i++)
	{
		ph = (photo *)[photos objectAtIndex:i];
		
		/** get location information for the photo and store it in the photo object **/
		[ph setLoc:(location *)[flickr getLocation:[[ph keys] objectForKey:@"id"]]];
						
		MapMarker *marker =  [MapMarker defaultRedMarkerWithLat:[[ph getLatitude] doubleValue] Lng:[[ph getLongitude] doubleValue] ];
		marker.data = @"red";
		marker.draggable = NO;
		marker.delegate = self;
		[mapView addMarker:marker];
		[marker show];
		
	}
		

	[photos retain];
	
	MapMarker *marker =  [MapMarker defaultBlueMarkerWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"blue";
	marker.draggable = NO;
	marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
	
	image_count = 0;
	
	
}
- (IBAction)showMap: (id) sender{
	
	
	if(mapView)[mapView release];
	
	mapView = [[MapView alloc] initWithFrame:CGRectMake(0.0, 53,self.view.bounds.size.width ,375)];
	
	[self.view addSubview:mapView];
	
	
	
		
	[photos release];
	
	NSLog(@"%f %f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude);
	
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];
	
	int i;
	
	photo* ph;
	
		
	for(i = 0; i < [photos count]; i++)
	{
		ph = (photo *)[photos objectAtIndex:i];
		
		/** get location information for the photo and store it in the photo object **/
		[ph setLoc:(location *)[flickr getLocation:[[ph keys] objectForKey:@"id"]]];
		
		MapMarker *marker =  [MapMarker defaultRedMarkerWithLat:[[ph getLatitude] doubleValue] Lng:[[ph getLongitude] doubleValue] ];
		marker.data = @"red";
		marker.draggable = NO;
		marker.delegate = self;
		[mapView addMarker:marker];
		[marker show];
		
	}
	
	
	[photos retain];
	
	MapMarker *marker =  [MapMarker defaultBlueMarkerWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"blue";
	marker.draggable = NO;
	marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
	
	
	image_count = 0;
	
	
	
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
