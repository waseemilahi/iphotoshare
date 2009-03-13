//
//  SettingsViewController.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController <UITextFieldDelegate>{

	IBOutlet UITextField *username;
	IBOutlet UITextField *password;
}

- (IBAction) signIn:(id)sender;

- (IBAction) Register:(id)sender;

@end
