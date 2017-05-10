//
//  NSString+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (UcfLib)

@property (nonatomic, readonly) NSData   *base64DecodedData;
@property (nonatomic, readonly) NSString *base64EncodedString;
@property (nonatomic, readonly) NSString *base64DecodedString;
@property (nonatomic, readonly) NSString *long2key;
@property (nonatomic, readonly) NSString *md5;
@property (nonatomic, readonly) NSString *sha1;
@property (nonatomic, readonly) NSData   *bytesFromHexString;
@property (nonatomic, readonly) NSString *encodeUrl;
@property (nonatomic, readonly) NSString *encodeUrlAllCharacters;
@property (nonatomic, readonly) NSString *f2;
@property (nonatomic, readonly) NSString *safeMobileNumber;
@property (nonatomic, readonly) NSString *safeIDNumber;
@property (nonatomic, readonly) NSString *safeUserName;
@property (nonatomic, readonly) NSString *fenToYuan;
@property (nonatomic, readonly) NSString *yuanToFen;
@property (nonatomic, readonly) NSString *bankCodeFormatWithBlankSep;
@property (nonatomic, readonly) NSString *percentEscapedString;

@property (nonatomic, readonly) BOOL isValidPhoneNum;
@property (nonatomic, readonly) BOOL isValidStaffNum;
@property (nonatomic, readonly) BOOL isValidPassword;
@property (nonatomic, readonly) BOOL isValidSMSCode;
@property (nonatomic, readonly) BOOL isValidIdCardNum;
@property (nonatomic, readonly) BOOL isValidChineseName;
@property (nonatomic, readonly) BOOL isPureFloat;
@property (nonatomic, readonly) BOOL isBlankString;

@property (nonatomic, readonly) NSDecimalNumber *decimalNumber;

- (NSString *)rsaWithKey:(NSString *)rsaKey;

- (NSString *)numStringByAdding:(NSString *)string;//加
- (NSString *)numStringBySubtracting:(NSString *)string;//减
- (NSString *)numStringByMultiplyingBy:(NSString *)string;//乘
- (NSString *)numStringByDividingBy:(NSString *)string;//除
- (NSDecimalNumber *)decimalNumberWithBehavior:(id <NSDecimalNumberBehaviors>)behavior;

+ (NSString *)timestampLong2key;
- (CGSize)suggestedSizeWithFont:(UIFont *)font width:(CGFloat)width;
- (BOOL)isIncludeSubstring:(NSString *)substring;


@end
