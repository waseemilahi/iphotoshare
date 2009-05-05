// XMLtoObject.h
#import <UIKit/UIKit.h>

@interface XMLtoObject : NSObject {
	NSString *className;
	NSMutableArray *items;
	NSObject *item; // stands for any class
    NSString *currentNodeName;
	NSMutableString *currentNodeContent;
}
- (NSArray *)items;
- (id)parseXMLinString:(NSString *)xml 
			  toObject:(NSString *)aClassName 
			parseError:(NSError **)error;

- (id)parseXMLAtURL:(NSURL *)url 
		   toObject:(NSString *)aClassName 
		 parseError:(NSError **)error;
@end


//photoid object
@interface photoid : NSObject {
	NSString *value;
}

@property (nonatomic, retain) NSString *value;

-(void)setValue:(NSString *)val;

@end


//location object
@interface location : NSObject {
	NSDictionary *keys;
}

@property (nonatomic, retain) NSDictionary *keys;
-(void)setKeys:(NSDictionary *)k;

-(NSString *)getLatitude;
-(NSString *)getLongitude;
-(NSString *)getAccuracy;

@end

@interface user : NSObject {
	NSDictionary *keys;
}

@property (nonatomic , retain) NSDictionary *keys;
-(void)setKeys:(NSDictionary *)k;

-(NSString *)getUserName;
-(NSString *)getFullName;

@end


//photo object
@interface photo : NSObject {
	//	NSString *url;
	NSDictionary *keys;
	location *loc;
}

@property (nonatomic, retain) NSDictionary *keys;
@property (nonatomic, retain) location *loc;

//-(void)setPhotoUrl:(NSString *)pid farm:(NSString *)farm server:(NSString *)server secret:(NSString *)secret;
-(NSString *)getPhotoUrl:(NSUInteger)size;
-(NSString *)getLatitude;
-(NSString *)getLongitude;

-(void)setKeys:(NSDictionary *)k;
-(void)setLoc:(location *)l;

@end


//frob object
@interface frob : NSObject {
	NSString *value;
}

@property (nonatomic, retain) NSString *value;

-(void)setValue:(NSString *)val;

@end


//form object (for stealth login)
@interface form : NSObject {
	NSMutableDictionary *fields;
	NSMutableString *action;
	NSMutableString *parameterlist;
}

@property (nonatomic, retain) NSMutableDictionary *fields;
@property (nonatomic, retain) NSMutableString *action;
@property (nonatomic, retain) NSMutableString *parameterlist;

-(void)clearFields;
-(void)setFields:(NSMutableDictionary *)fs;
-(void)addField:(NSMutableString *)field withValue:(NSMutableString *)value;

-(void)setAction:(NSMutableString *)action;

-(NSString *)getURL;

@end


//token object
@interface token : NSObject {
	NSString *value;
}

@property (nonatomic, retain) NSString *value;

-(void)setValue:(NSString *)val;

@end

