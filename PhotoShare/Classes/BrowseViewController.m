//
//  BrowseViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __PhotoShare__. All rights reserved.
//


#import "BrowseViewController.h"

#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation BrowseViewController

@synthesize imageView;
@synthesize imagePicker;
@synthesize pictureLabel;
@synthesize flickr;
@synthesize locmanager;
@synthesize photos;
@synthesize update;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"touching...");
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	startPoint = [touch locationInView:[touch view]];
	startTime = [touch timestamp];
	
	NSLog(@"(%f, %f)@%f", startPoint.x, startPoint.y, startTime);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"...touched");
	
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
	CGPoint point = [touch locationInView:[touch view]];
	NSLog(@"(%f, %f)@%f-(%f, %f)@%f", startPoint.x, startPoint.y, startTime, point.x, point.y, [touch timestamp]);
	
	CGFloat dTime = [touch timestamp] - startTime;
	CGFloat dX = point.x - startPoint.x;
	CGFloat dY = point.y - startPoint.y;
	
	if (dTime < 1) {
		NSLog(@"Quick swipe:");
		if (dY < 50 && dY > -50) {
			if (dX > 25) {
				NSLog(@"to the right");
				
				if (p + 1 < [photos count]){ p++;
				CATransition *myTransition = [ CATransition animation];
				myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
				myTransition.type = kCATransitionPush;
				myTransition.subtype = kCATransitionFromLeft;
				[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
				self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1] ; 
				}
				[self loadPhoto:p];
			} else if (dX < -25) {
				
				NSLog(@"to the left");
				
				if (p > 0){ p--;
				
				CATransition *myTransition = [ CATransition animation];
				myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
				myTransition.type = kCATransitionPush;
				myTransition.subtype = kCATransitionFromRight;
				[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
				self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1] ; 
				}
				[self loadPhoto:p];
				
			}
		} else if (dX < 50 && dX > -50)  {
			if (dY > 25) {
				NSLog(@"downward");
				
			} else if (dY < -25) {
				
				NSLog(@"upward");
			}
		}
	} else {
		NSLog(@"Normal drag:");
		
		
	}
}

//Save the image to the photo library.
-(IBAction)saveImage:(id)sender{
	
	UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
	
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];	
	[myAlertView show];
	[myAlertView release];
	
}

//Load one Photo at a time.
- (void)loadPhoto:(NSUInteger)index {
	
	NSLog(@"loadPhoto:%d of %d", index + 1, [photos count]);
	if ([photos count] > 0) {
		[pictureLabel setText:[NSString stringWithFormat:@"%d of %d", index + 1, [photos count]]];
	} else {
		[imageView setImage:nil];
		[pictureLabel setText:@"No photos found."];
		
	}
	if (index >= 0 && index < [photos count]) {
		photo* ph = (photo *)[photos objectAtIndex:index];
		
		/** get location information for the photo and store it in the photo object **/
		[ph setLoc:(location *)[flickr getLocation:[[ph keys] objectForKey:@"id"]]];
		
		NSLog(@"photo");
		NSLog(@"-url: %@", [ph getPhotoUrl:4]);
		NSString* imageURL = [ph getPhotoUrl:4];
		
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
		
		UIImage* image = [[UIImage alloc] initWithData:imageData];
		[imageView setImage:image];
		[imageData release];
		[image release];
	}
}

- (void)showPicture: (id) sender{
	
	[photos release];
					
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];
	p = 0;
	
	if(count == 1){
	CATransition *myTransition = [ CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush;
	myTransition.subtype = kCATransitionFromLeft;
	[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
	self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1] ; 
		
	}
	[self loadPhoto:p];
	[photos retain];
}

//ImagePickerDelegate methods.
//----------------------------

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.imagePicker dismissModalViewControllerAnimated:YES];
	
}

- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image 
                  editingInfo:(NSDictionary *)editingInfo {
	int i=0;
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.png"];
	
	while([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
		uniquePath = [NSString stringWithFormat:@"%@/%@-%d.%@",DOCSFOLDER,@"selectedImage", ++i,@"png"];
	[UIImagePNGRepresentation(image) writeToFile : uniquePath atomically:YES];
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
}

//The Method called by viewDidLoad to Get the array of photos in the browse view.
-(void)showP{
	[photos release];
	
	NSLog(@"%f %f",locmanager.location.coordinate.latitude,locmanager.location.coordinate.longitude);
	
	photos = [NSArray arrayWithArray:[flickr getPhotos:locmanager.location.coordinate.latitude lng:locmanager.location.coordinate.longitude ]];
	p = 0;
	
	
		CATransition *myTransition = [ CATransition animation];
		myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
		myTransition.type = kCATransitionPush;
		myTransition.subtype = kCATransitionFromRight;
		[ self.tabBarController.view.layer addAnimation: myTransition forKey: nil];
		self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1] ; 
		

	count = 1;
	[self loadPhoto:p];
	
	[photos retain];
}

- (void)viewDidLoad {
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	locmanager = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate locmanager];
		
	imageView.multipleTouchEnabled = YES;
	
	count = 0;
	
	[pictureLabel setText:@"Searching For Photos."];
	
	[self performSelector:@selector(showP) withObject:nil afterDelay:3];
		
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc {
	
	self.imageView = nil;
	self.imagePicker = nil;

	[photos release];
	[pictureLabel release];
	[imageView release];
	[imagePicker release];

    [super dealloc];
}


@end