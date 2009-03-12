//
//  CameraViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController

@synthesize imagePickerController;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
 
 // Set up the image picker controller and add it to the view
 imagePickerController = [[UIImagePickerController alloc] init];
imagePickerController.delegate = self;
	imagePickerController.sourceType = 
 UIImagePickerControllerSourceTypeCamera;
 [self.view addSubview:imagePickerController.view];
 
 // Set up the image view and add it to the view but make it hidden
 imageView = [[UIImageView alloc] initWithFrame:[self.view bounds]];
	
	

 [self.view addSubview:imageView];
 
    [super viewDidLoad];
}

- (void) imagePickerController:(UIImagePickerController *)picker
		 didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	int i=0;
	NSString *uniquePath = [DOCSFOLDER stringByAppendingPathComponent:@"selectedImage.png"];
	
	while([[NSFileManager defaultManager] fileExistsAtPath:uniquePath])
		uniquePath = [NSString stringWithFormat:@"%@/%@-%d.%@",DOCSFOLDER,@"selectedImage", ++i,@"png"];
	
	[UIImagePNGRepresentation(image) writeToFile: uniquePath atomically:YES];
	 

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
