//
//  NSDateManager.h
//  

#import <Foundation/Foundation.h>

#define DEFAULT_DATE_FORMATTER @"yyyy-MM-dd HH:mm:ss"
#define DEFAULT_DATE_REPAYPERIOD @"yyyy-MM-dd"

@interface NSDateManager : NSObject

+ (NSString *)getDateDesWithDate:(NSDate *)date dateFormatterStr:(NSString *)dateFormatterStr;
+ (NSDate *)getDateWithDateDes:(NSString *)dateDes dateFormatterStr:(NSString *)dateFormatterStr;
+ (NSString *)getDateWithDateDes:(NSNumber *)dateDes;
@end
