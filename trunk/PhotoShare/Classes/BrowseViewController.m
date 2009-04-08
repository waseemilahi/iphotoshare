//
//  BrowseViewController.m
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import "BrowseViewController.h"
//#import "XMLtoObject.h"
#import "flickrapi.h"

#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
@implementation BrowseViewController

@synthesize imageView;
@synthesize imagePicker;
@synthesize flickr;
@synthesize photos;

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
	
	if (dTime < 0.5) {
		NSLog(@"Quick swipe:");
		if (dY < 15 && dY > -15) {
			if (dX > 25) {
				NSLog(@"to the right");
				
				if (p + 1 < [photos count]) p++;
				[self loadPhoto:p];
			} else if (dX < -25) {
				
				NSLog(@"to the left");
				
				if (p > 0) p--;
				[self loadPhoto:p];
			}
		} else if (dX < 15 && dX > -15)  {
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

- (void)loadPhoto:(NSUInteger)index {
	NSLog(@"loadPhoto:%d of %d", index + 1, [photos count]);
	if (index >= 0 && index < [photos count]) {
		photo* ph = (photo *)[photos objectAtIndex:index];
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
	// create the request
	/*
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=a107e8a07a8f464250562ea2424ccf25&tags=fun&api_sig=c9cde0ff8ca668ab84f8a2908cc03f71"]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	NSMutableData *receivedData;

	XMLtoObject *xo;
	*/
	
	//flickrapi *
//	if (flickr == nil) flickr = [[flickrapi alloc] init];
	[photos release];
	
	photos = [NSArray arrayWithArray:[flickr getPhotos]];
	p = 0;
	
	[self loadPhoto:p];
	[photos retain];
	/*
	/*
	NSURL *url = [NSURL URLWithString: @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=f46e7a1681dd43b589b442ada0bd5163&lat=40.7&lon=-74&api_sig=2b6b7498d315496df10afea749ab39a8"];
	NSString *class = @"photo";
	
	//NSError **err;
	
	//[xo parseXMLAtURL:url toObject:class parseError:err];
	
	// NSURL *url = [NSURL URLWithString: @"http://localhost/contacts.xml"];
	// XMLToObjectParser *myParser = [[XMLToObjectParser alloc] parseXMLAtURL:url toObject:@"Contact" parseError:nil];
	 
	
	//XMLtoObject *parser = [[XMLtoObject alloc] parseXMLAtURL:url toObject:class parseError:nil];
	*/

	
		
	/*
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		// Create the NSMutableData that will hold
		// the received data
		// receivedData is declared as a method instance elsewhere
		receivedData=[[NSMutableData data] retain];

		NSString* mapURL = @"http://www.google.com/intl/en_ALL/images/logo.gif";
		NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:mapURL]];
		
		UIImage* image = [[UIImage alloc] initWithData:imageData];
		[imageView setImage:image];
		[imageData release];
		[image release];
		
	} else {
		// inform the user that the download could not be made
	}
	*/
	
	
	/*
	self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	self.imagePicker.allowsImageEditing = YES; //<label id="code.imagepicker.allowsEditing"/>
	[self presentModalViewController:self.imagePicker animated:YES]; //<label id="code.imagepicker.present.modal"/>
	 */
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	flickr = [(PhotoShareAppDelegate *)[UIApplication sharedApplication].delegate flickr];
	imageView.multipleTouchEnabled = YES;
	[self showPicture:nil];
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

	[pictureLabel release];
	[imageView release];
	[imagePicker release];

    [super dealloc];
}


@end