//
//  CameraViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"
#import "flickrapi.h"


@implementation CameraViewController

@synthesize imageView;
@synthesize imagePicker;
@synthesize flickr;
@synthesize locmanager;

#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


//START:code.PhotoViewController.touchesEnded:withEvent:
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	if([[touches anyObject] tapCount] >=1) {
		// bring up image grabber
-(void)viewPictures: (id) sender{
	
		self.imagePicker.sourceType =
		UIImagePickerControllerSourceTypePhotoLibrary;
	
	self.imagePicker.allowsImageEditing = YES; //<label id="code.imagepicker.allowsEditing"/>
	
	[self presentModalViewController:self.imagePicker animated:YES]; 
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
	
	
	NSDate *todaysDate = [NSDate date];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:todaysDate];
	
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo's Upload Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
	myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 38.0, 260.0, 28.0)];
	[myTextField setBackgroundColor:[UIColor whiteColor]];
	myTextField.clearsOnBeginEditing = YES;
	myTextField.text = [NSString stringWithFormat:@"PShare: %@", formattedDateString ];
	[myAlertView addSubview:myTextField];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
	[myAlertView setTransform:myTransform];
	[myAlertView show];
	
}

- (void)takePicture: (id) sender{
			
	
		if([UIImagePickerController isSourceTypeAvailable:
			UIImagePickerControllerSourceTypeCamera]) { //<label id="code.imagepicker.sourceType"/>
			self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else {
			self.imagePicker.sourceType =
			UIImagePickerControllerSourceTypePhotoLibrary;
		}
		self.imagePicker.allowsImageEditing = YES; //<label id="code.imagepicker.allowsEditing"/>
		
	[self presentModalViewController:self.imagePicker animated:YES]; //<label id="code.imagepicker.present.modal"/>
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	
	
	
	NSDate *todaysDate = [NSDate date];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:todaysDate];
	
	UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Photo's Upload Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
	myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 38.0, 260.0, 28.0)];
	[myTextField setBackgroundColor:[UIColor whiteColor]];
	myTextField.clearsOnBeginEditing = YES;
	myTextField.text = [NSString stringWithFormat:@"PShare: %@", formattedDateString ];
	[myAlertView addSubview:myTextField];
	CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
	[myAlertView setTransform:myTransform];
	[myAlertView show];
	
//	}
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
	
	
	//int i=0;
	//NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.png"];
	
	//while([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
	//	uniquePath = [NSString stringWithFormat:@"%@/%@-%d.%@",DOCSFOLDER,@"selectedImage", ++i,@"png"];
//	[UIImagePNGRepresentation(image) writeToFile : uniquePath atomically:YES];
	//[UIImagePNGRepresentation(image) writeToFile: uniquePath atomically:YES];
	
	[image retain];
	if(NO == [flickr uploadPhoto:image withLat:locmanager.location.coordinate.latitude andLon:locmanager.location.coordinate.longitude withName:myTextField.text])
	{
		if(flickr.FROB == nil)
		{
			UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Upload Failed!" message:@"Login and Try Again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];		
			[newAlertView show];
		}
		else
		{
			UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Network ERROR!" message:@"Try Again Later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];		
			[newAlertView show];

		}
		
	}
	else 
	{
		UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Upload Successful!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];		
		[newAlertView show];
		
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
}
//END:code.PhotoViewController.didFinish
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}


*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	locmanager = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate locmanager];
		
	/*
 if([UIImagePickerController isSourceTypeAvailable:
 UIImagePickerControllerSourceTypeCamera]) { //<label id="code.imagepicker.sourceType"/>
 self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
 } else {
 self.imagePicker.sourceType =
 UIImagePickerControllerSourceTypePhotoLibrary;
 }
 self.imagePicker.allowsImageEditing = YES; //<label id="code.imagepicker.allowsEditing"/>
	
 [self presentModalViewController:self.imagePicker animated:YES];
*/
}
/*
- (void) imagePickerController:(UIImagePickerController *)picker
		 didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	int i=0;
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.png"];
	
	while([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
		uniquePath = [NSString stringWithFormat:@"%@/%@-%d.%@",DOCSFOLDER,@"selectedImage", ++i,@"png"];
	
	[UIImagePNGRepresentation(image) writeToFile: uniquePath atomically:YES];
	
 [self popToRootViewControllerAnimated:YES];

	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
	[picker release];
	 
	
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)CurrentPicker {
	//hide the picker if user cancels picking an image.
	[[CurrentPicker parentViewController] dismissModalViewControllerAnimated:YES];
	[CurrentPicker release];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;//(interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    self.imageView = nil;
	self.imagePicker = nil;
	[imagePicker release];
	[imageView release];
	[super dealloc];
}


@end
