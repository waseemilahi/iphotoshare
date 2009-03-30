// photo.h
#import <UIKit/UIKit.h>

@interface photo : NSObject {
	NSString *url;
	/*
	NSString *pid;
	NSString *owner;
	NSString *secret;
	NSString *server;
	NSString *farm;
	NSString *title;
	NSString *ispublic;
	NSString *isfriend;
	NSString *isfamily;
	 */
}

@property (nonatomic, retain) NSString *url;
/*
@property (nonatomic, retain) NSString *pid;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *farm;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *ispublic;
@property (nonatomic, retain) NSString *isfriend;
@property (nonatomic, retain) NSString *isfamily;
*/

-(void)setPhotoUrl:(NSString *)pid farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret;

@end