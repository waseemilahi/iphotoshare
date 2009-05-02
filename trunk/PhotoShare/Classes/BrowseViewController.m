//
//  BrowseViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 PhotoShareGroup. All rights reserved.
//


#import "BrowseViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "XMLtoObject.h"


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

-(IBAction)saveImage:(id)sender{
	
	UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
	
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[myAlertView show];
	[myAlertView release];
	
}


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
		//imageView.frame = CGRectMake(0.0, 43.0,self.view.bounds.size.width ,375);
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

//START:code.PhotoViewController.didCancel
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.imagePicker dismissModalViewControllerAnimated:YES];
	//[self loadView ];
}
//END:code.PhotoViewController.didCancel
//START:code.PhotoViewController.didFinish
- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image 
                  editingInfo:(NSDictionary *)editingInfo {
	//imageView.image = image; //<label id="code.imagepicker.setimage"/>
	//[self dismissModalViewControllerAnimated:YES]; //<label id="code.imagepicker.dismiss"/>
	//[picker release];
	int i=0;
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.png"];
	
	while([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
		uniquePath = [NSString stringWithFormat:@"%@/%@-%d.%@",DOCSFOLDER,@"selectedImage", ++i,@"png"];
	[UIImagePNGRepresentation(image) writeToFile : uniquePath atomically:YES];
	//[UIImagePNGRepresentation(image) writeToFile: uniquePath atomically:YES];
	
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[self loadURL];
}

*/

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	locmanager = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate locmanager];
		
	imageView.multipleTouchEnabled = YES;
	
	count = 0;
	
	[pictureLabel setText:@"Searching For Photos."];
	
	[self performSelector:@selector(showP) withObject:nil afterDelay:3];
	
	
	//[self showPicture:update];
		
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
	
	self.imageView = nil;
	self.imagePicker = nil;

	//self.webView = nil;
	[photos release];

	[pictureLabel release];
	[imageView release];
	[imagePicker release];

    [super dealloc];
}


@end