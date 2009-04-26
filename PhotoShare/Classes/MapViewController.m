//
//  MapViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>



@implementation MapViewController

@synthesize flickr;
@synthesize photos;
@synthesize locmanager;
@synthesize imageView;
@synthesize indicatorview;
@synthesize mapBar;

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




-(void) clickedMarker:(MapMarker *) marker {
		
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromRight;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2] ; 
		
	[imageView setImage:marker.markerImage];
	
	[self.view addSubview:imageView];
	
	
	
	[self.view addSubview:save];
		

	image_count++;	
	
}

-(IBAction)saveImage:(id)sender{
	
	UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
	
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[myAlertView show];
	[myAlertView release];
	
}

-(IBAction)goBack:(id)sender{
	if(image_count > 0){
		image_count--;
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromLeft;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2] ; 
		
		[[self.view.subviews lastObject] removeFromSuperview];
		[[self.view.subviews lastObject] removeFromSuperview];
	}
}





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	
	locmanager = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate locmanager];
	[self.view addSubview:mapBar];
	[self.view addSubview:indicatorview];
		
	[self performSelector:@selector(showM) withObject:nil afterDelay:3];
	
	
	
}
	 
-(void)showM{
	NSLog(@"%f %f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude);	
	[photos release];
	
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];
	
	int i;
	
	photo* ph;
	
	MapMarker *marker;
	
	mapView = [[MapView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];
	
	for(i = 0; i < 25/*[photos count]*/; i++)
	{
		ph = (photo *)[photos objectAtIndex:i];
		
		
		[ph setLoc:(location *)[flickr getLocation:[[ph keys] objectForKey:@"id"]]];
		
		NSString* imageURL = [ph getPhotoUrl:4];
		
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];	
		
		UIImage* image1 = [[UIImage alloc] initWithData:imageData];
		
		marker =  [MapMarker defaultRedMarkerWithLat:[[ph getLatitude] doubleValue] Lng:[[ph getLongitude] doubleValue] my_image:image1 ];
		marker.data = @"red";
		marker.draggable = NO;
		marker.delegate = self;
		[mapView addMarker:marker];
		//[marker show];
		
		
	}
	
	
	[photos retain];
	
	marker =  [MapMarker defaultBlueMarkerWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"blue";
	marker.draggable = NO;
	//marker.delegate = mapView;
	[mapView addMarker:marker];
	//[marker show];
	
	[mapView showMarkers];
	
	image_count = 0;	
	[[self.view.subviews lastObject] removeFromSuperview];
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromRight;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2] ; 
	
	[self.view addSubview:mapView];
	[self.view addSubview:mapBar];
}

	 
	 
	 
- (IBAction)showMap: (id) sender{
	
	if(image_count > 0)[[self.view.subviews lastObject] removeFromSuperview];
	
	if(mapView){
		[mapView clearMarkers];
		[mapView release];
	}
	
	
			
	[photos release];
	
	NSLog(@"%f %f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude);
	
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];
	
	int i;
	
	photo* ph;
	
	MapMarker *marker;
	
	mapView = [[MapView alloc] initWithFrame:CGRectMake(0.0, 43,self.view.bounds.size.width ,375)];

		
	for(i = 0; i < 25/*[photos count]*/; i++)
	{
		ph = (photo *)[photos objectAtIndex:i];
		
		
		[ph setLoc:(location *)[flickr getLocation:[[ph keys] objectForKey:@"id"]]];
		
		
		NSString* imageURL = [ph getPhotoUrl:4];
		
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];	
		
		UIImage* image1 = [[UIImage alloc] initWithData:imageData];
		
		marker =  [MapMarker defaultRedMarkerWithLat:[[ph getLatitude] doubleValue] Lng:[[ph getLongitude] doubleValue] my_image:image1 ];
		marker.data = @"red";
		marker.draggable = NO;
		marker.delegate = self;
		[mapView addMarker:marker];
		[marker show];
		
		
		
	}
	
	
	[photos retain];
	
	marker =  [MapMarker defaultBlueMarkerWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"blue";
	marker.draggable = NO;
	//marker.delegate = self;
	[mapView addMarker:marker];
	[marker show];
	
 
	
	image_count = 0;
	
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromLeft;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2] ; 
	
	[self.view addSubview:mapView];
		[self.view addSubview:mapBar];
	
	
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
