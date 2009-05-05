//
//  CameraViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __PhotoShare__. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController

@synthesize imageView;
@synthesize imagePicker;
@synthesize flickr;
@synthesize locmanager;

#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

//Get the photos from the phone's library to upload them.
-(void)viewPictures: (id) sender{
	
		self.imagePicker.sourceType =
		UIImagePickerControllerSourceTypePhotoLibrary;
	
	self.imagePicker.allowsImageEditing = YES; 
	
	[self presentModalViewController:self.imagePicker animated:YES]; 
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		
	NSDate *todaysDate = [NSDate date];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:todaysDate];
	
	myTextField = [[UITextField alloc] init];
	myTextField.text = [NSString stringWithFormat:@"PShare: %@", formattedDateString ];
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Photo's Upload Name" message:@"Enter The Name You Want To Give To Your Photo" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
	[myAlert addTextFieldWithValue:nil label:myTextField.text];
	[[myAlert textField] setTextAlignment:UITextAlignmentCenter];

	[[myAlert textField] becomeFirstResponder];
	
	[myAlert show];
	[myAlert release];
	myAlert = nil;
	
}

//The Action to take the picture to upload it.
- (void)takePicture: (id) sender{
			
	
		if([UIImagePickerController isSourceTypeAvailable:
			UIImagePickerControllerSourceTypeCamera]) { 
			self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else {
			self.imagePicker.sourceType =
			UIImagePickerControllerSourceTypePhotoLibrary;
		}
		self.imagePicker.allowsImageEditing = YES; 
		
	[self presentModalViewController:self.imagePicker animated:YES]; 
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
			
	NSDate *todaysDate = [NSDate date];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:todaysDate];
	
	myTextField = [[UITextField alloc] init];
	myTextField.text = [NSString stringWithFormat:@"PShare: %@", formattedDateString ];
	UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Photo's Upload Name" message:@"Enter The Name You Want To Give To Your Photo" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
	[myAlert addTextFieldWithValue:nil label:myTextField.text];
	[[myAlert textField] setTextAlignment:UITextAlignmentCenter];
	
	[[myAlert textField] becomeFirstResponder];
		
	[myAlert show];
	[myAlert release];
	myAlert = nil;	

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if([[[alertView textField] text] isEqualToString:@""]){}
	   else myTextField.text = [[alertView textField] text];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.imagePicker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker 
        didFinishPickingImage:(UIImage *)image 
                  editingInfo:(NSDictionary *)editingInfo {
	
	[image retain];
	if(NO == [flickr uploadPhoto:image withLat:locmanager.location.coordinate.latitude andLon:locmanager.location.coordinate.longitude withName:myTextField.text])
	{//Upload Failed. WHY?
		if(flickr.FROB == nil)
		{
			UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Upload Failed!" message:@"Login and Try Again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];		
			[newAlertView show];
					[newAlertView release];
		}
		else
		{
			UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Network ERROR!" message:@"Try Again Later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];		
			[newAlertView show];
					[newAlertView release];

		}
		
	}
	else //Upload Successfull
	{
		UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:@"Upload Successful!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];		
		[newAlertView show];
		[newAlertView release];
 		
	}
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
	
}

- (void)viewDidLoad {
	
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	locmanager = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate locmanager];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}


- (void)dealloc {
    self.imageView = nil;
	self.imagePicker = nil;
	[imagePicker release];
	[imageView release];
	[super dealloc];
}


@end
