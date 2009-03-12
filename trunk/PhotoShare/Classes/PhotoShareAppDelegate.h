//
//  PhotoShareAppDelegate.h
//  PhotoShare
//
//  Created by Waseem Ilahi on 3/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoShareAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UIImageView * imageTmp;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIImageView * imageTmp;
- (IBAction) homeSignIn:(id)sender;
@end