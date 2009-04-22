#import <CommonCrypto/CommonDigest.h>
#import "md5.h"

@implementation NSMutableString (md5)

+ (NSMutableString *) md5:(NSMutableString *)str {
	
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSMutableString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
	];	
}

@end