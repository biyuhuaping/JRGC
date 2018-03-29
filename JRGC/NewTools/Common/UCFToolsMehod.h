//
//  UCFToolsMehod.h
//  JRGC
//
//  Created by MAC on 14-9-21.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFToolsMehod : NSObject
{
    
}

+ (NSString*)dealmoneyFormartForDetailView:(NSString*)mon;//格式化标详情钱数

+ (void)viewAddLine:(UIView *)view Up:(BOOL)up;

+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Font1:(UIFont *)font1 Text2:(NSString *)text2 Color2:(UIColor *)color2 Font2:(UIFont *)font2 AllText:(NSString *)allText;

/**
 *  关键词特殊显示
 *
 *  @param content   源字符串
 *  @param aKeyword  关键词
 *  @param textColor 关键词颜色
 */
+ (NSAttributedString *)attributedString:(NSString *)content keyword:(NSString *)aKeyword color:(UIColor *)textColor;
//给字符串添加逗号
+ (NSString *)AddComma:(NSString *)string;
//返回相应地状态
+(NSString *)getStatus:(int) aStatus;
//处理字符串防止出现 NULl
+(NSString *)isNullOrNilWithString:(NSString *) str;
//时间戳转时间
+(NSString *)getMyCollectionTimeStr:(double)tInterval;
//处理服务器时间返回过长的问题
+(NSString *)subShortTimeStrWithLongTime:(NSString *) longTime;
//我的投资中根据state返回相应地状态
+(NSString *)getMyInvementWithState:(NSString *) state;
//我的借款根据state返回相应地状态
+(NSString *)getMyBorrowWithState:(NSString *) state;
+(NSString *)getRepaymentWithState:(NSString *) state;
//根据返回的数值，返回相应地还款期限
+(NSString*)getRepaytimeWithState:(NSString *) state;
/** 去掉数字后面.0,拼接%*/
+(NSString *)removePointZeroWithString:(NSString *)string;
/** 去除文字标题中带括号的内容 */
+(NSString *)removeBracketsWithTitle:(NSString *)title;
//根据返回数值，返回相应地还款方式
+(NSString *)getLoanTypeWithState:(NSString *) state;
//合同类型
+(NSString *)getContractTypeWithState:(NSString *) state;
//我的投资 根据status返回相应地状态
+(NSString *)getMyBidWithStatus:(NSString *) status;
//担保方类型
+(NSString *)getPrdGuaranteeTypeWithState:(NSString *) state;
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;
+ (NSString *)setLastUpdateTime:(NSDate *)lastUpdateTime;
+ (NSString*)updateTimeLabel;
+(NSString *)zhengZe:(NSString *) str;
+(NSString *) md5: (NSString *) inPutText;
+(NSString *) maSaiKaMobile:(NSString *) mobie;
+(NSString *) maSaiKeName:(NSString *) name;
+(BOOL) connectedToNetwork;
+ (NSString*)dealmoneyFormart:(NSString*)mon;

+ (NSString *)isHaveWithString:(NSString *) str;

+ (NSString *)getNameAdresss:(NSDictionary*)dic;

+ (NSString *)getBaseInfo:(NSDictionary*)dic;
@end
