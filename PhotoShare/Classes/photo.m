/*
// photo.m
#import "photo.h"

@implementation photo

@synthesize url;

-(void)setPhotoUrl:(NSString *)pid farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret {
	url = [NSMutableString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", farm, server, pid, secret];
	
	return;
}

@end

*/