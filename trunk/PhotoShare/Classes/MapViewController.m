//
//  MapViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __PhotoShare__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize flickr;
@synthesize photos;
@synthesize locmanager;
@synthesize imageView;
@synthesize indicatorview;
@synthesize mapBar;

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

- (void)location:(location *)loc ForPhoto:(photo *)ph {
	if (loc == nil || ph == nil) return;
	
	[ph setLoc:loc];
	
	NSString* imageURL = [ph getPhotoUrl:4];
	NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];	
	UIImage* img = [[UIImage alloc] initWithData:imageData];
	
	MapMarker *marker = [MapMarker defaultRedMarkerWithLat:[[ph getLatitude] doubleValue] Lng:[[ph getLongitude] doubleValue] my_image:img ];
	marker.data = @"red";
	marker.draggable = NO;
	marker.delegate = self;
	
	[mapView addMarker:marker];
	[marker show];
}

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
	
	marker =  [MapMarker defaultCrosshairsWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"crosshairs_blue";
	marker.draggable = NO;
	[mapView addMarker:marker];
	[marker show];
	
	int loop_count = 30;
	if([photos count] < loop_count)loop_count = [photos count];
	
	for(i = 0; i <loop_count; i++)
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
		
	image_count = 0;	
	[[self.view.subviews lastObject] removeFromSuperview];
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
	
	[[self.view.subviews lastObject] removeFromSuperview];
	[[self.view.subviews lastObject] removeFromSuperview];
	
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
	
	int loop_count = 30;
	if([photos count] < loop_count)loop_count = [photos count];
	
	marker =  [MapMarker defaultCrosshairsWithLat:locmanager.location.coordinate.latitude Lng:locmanager.location.coordinate.longitude ];
	marker.data = @"crosshairs";
	marker.draggable = NO;
	[mapView addMarker:marker];
	[marker show];
	
	for(i = 0; i <loop_count; i++)
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}


- (void)dealloc {
	[locmanager release];
	[mapView release];
	[locations release];
	
	[indicatorview release];
	[photos release];
	[mapBar release];
	[super dealloc];
}


@end
