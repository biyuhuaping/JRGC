//
//  UCFToolsMehod.m
//  JRGC
//
//  Created by MAC on 14-9-21.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFToolsMehod.h"
#import "CommonCrypto/CommonDigest.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
@implementation UCFToolsMehod


+ (NSString *)isHaveWithString:(NSString *) str
{
    if([str isEqualToString:@"1"])
    {
        return @"有";
    }
    else
    {
        return @"无";
    }
}

+ (NSString *)getNameAdresss:(NSDictionary*)dic
{
    NSDictionary *userInfo = dic[@"orderUser"];
    //NSDictionary *otherInfo = dic[@"userOtherMsg"];
    NSString *strName = [userInfo objectForKey:@"realName"];
    NSString *proviceName = [userInfo objectForKey:@"provinceName"];
    NSString *cityName = [userInfo objectForKey:@"cityName"];
    if([proviceName isEqual:[NSNull null]] || proviceName == nil)
    {
        proviceName = @"";
    }
    if([cityName isEqual:[NSNull null]] || cityName == nil)
    {
        cityName = @"";
    }
    if ([proviceName isEqualToString:@""] && [cityName isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@",strName];
    }
    return [NSString stringWithFormat:@"%@/%@ %@",strName ,proviceName,cityName];
}

+ (NSString *)getBaseInfo:(NSDictionary*)dic
{
    NSDictionary *userInfo = dic[@"orderUser"];
    NSDictionary *otherInfo = dic[@"userOtherMsg"];
    NSString *sex = [[UCFToolsMehod isNullOrNilWithString:[userInfo objectForKey:@"sex"]] integerValue] == 1?@"男":@"女";
    NSString *age = [UCFToolsMehod isNullOrNilWithString:[otherInfo objectForKey:@"age"]];
    NSString *marriage = [UCFToolsMehod isNullOrNilWithString:[userInfo objectForKey:@"marriage"]];
    NSString *graduation = [UCFToolsMehod isNullOrNilWithString:[userInfo objectForKey:@"graduation"]];
    NSString *borrowInfo = [NSString stringWithFormat:@"%@ %@岁 %@ %@",sex,age,marriage,graduation];
    return borrowInfo;
}

+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Font1:(UIFont *)font1 Text2:(NSString *)text2 Color2:(UIColor *)color2 Font2:(UIFont *)font2 AllText:(NSString *)allText
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text1) {
        NSRange range1 = [allText rangeOfString:text1];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color1 range:range1];
        if (font1) {
            [str addAttribute:NSFontAttributeName value:font1 range:range1];
        }
    }
    
    if (text2) {
        NSRange range2 = [allText rangeOfString:text2];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color2 range:range2];
        if (font2) {
            [str addAttribute:NSFontAttributeName value:font2 range:range2];
            
        }
    };
    
    
    [str endEditing];
    
    return [str autorelease];
}

/**
 *  关键词特殊显示
 *
 *  @param content   源字符串
 *  @param aKeyword  关键词
 *  @param textColor 关键词颜色
 */
+ (NSAttributedString *)attributedString:(NSString *)content keyword:(NSString *)aKeyword color:(UIColor *)textColor
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:content];
    for (int i = 0; i <= content.length - aKeyword.length; i ++) {
        
        NSRange tmp = NSMakeRange(i, aKeyword.length);
        
        NSRange range = [content rangeOfString:aKeyword options:NSCaseInsensitiveSearch range:tmp];
        
        if (range.location != NSNotFound) {
            [string addAttribute:NSForegroundColorAttributeName value:textColor range:range];
        }
    }
    
    return string;
}
//给字符串添加逗号
+ (NSString *)AddComma:(NSString *)string{
    
    if(string.length == 0) {
        return nil;
    }
    NSRange range = [string rangeOfString:@"."];
    
    NSMutableString *temp = [NSMutableString stringWithString:string];
    int i;
    if (range.length > 0) {
        //有.
        i = (int)range.location;
    }
    else {
        i = (int)string.length;
    }
    
    while ((i-=3) > 0) {
        
        [temp insertString:@"," atIndex:i];
    }
    
    return temp;
}

+(NSString *)getStatus:(int) aStatus
{
    switch (aStatus) {
        case 0:
            return @"未审核";
            break;
        case 1:
            return @"等待确认";
            break;
        case 2:
            return @"立即投资";
            break;
        case 3:
            return @"流标";
            break;
        case 4:
            return @"满标";
            break;
        case 5:
            return @"还款中";
            break;
        case 6:
            return @"已还清";
            break;
        default:
            break;
    }
    return nil;
}

+ (NSString*)dealmoneyFormart:(NSString*)mon
{
    if ([mon isEqualToString:@""]) {
        return @"";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSRange pointRg = [mon rangeOfString:@"."];
    NSString *ReString;
    if (pointRg.length == 0) {
        NSInteger mn = [mon integerValue];
        ReString = [formatter stringFromNumber:[NSNumber numberWithInteger:mn]];

    } else {
        NSString *afterPointStr = [mon substringFromIndex:pointRg.location+1];
        NSInteger mn = [mon integerValue];
        NSString *string = [formatter stringFromNumber:[NSNumber numberWithInteger:mn]];
        ReString = [string stringByAppendingString:[NSString stringWithFormat:@".%@",afterPointStr]];
    }

    return ReString;
}

+(NSString *)isNullOrNilWithString:(NSString *) str
{
    if([str isEqual:[NSNull null]] || str == nil || [str isEqualToString:@"(null)"])
    {
        return @"";
    }
    else
    {
        return str;
    }
}

+(NSString *)getMyCollectionTimeStr:(double)tInterval
{
    if(tInterval <= 0)
    {
        return @"";
    }
    NSString * str=nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"] autorelease]];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    NSDate *dt = nil;
    NSString *tIntervalStr = [NSString stringWithFormat:@"%.0lf",tInterval];
    if([tIntervalStr length]==13){//时间戳有10位和13位的分开判断
        dt = [NSDate dateWithTimeIntervalSince1970:tInterval  / 1000];
    }else{
        dt = [NSDate dateWithTimeIntervalSince1970:tInterval];
    }
    str = [formatter stringFromDate:dt];
    [formatter release];
    return str;
    
}
//处理服务器时间返回过长的问题
+(NSString *)subShortTimeStrWithLongTime:(NSString *) longTime
{
    if(longTime.length < 10)
    {
        return @"";
    }
    
    return [longTime substringToIndex:10];
}

//我的投资中根据state返回相应地状态
+(NSString *)getMyInvementWithState:(NSString *) state
{
    switch ([state intValue]) {
        case 2:
            return @"投标中";
            break;
        case 3:
            return @"流标";
            break;
        case 4:
            return @"满标";
            break;
        case 5:
            return @"回款中";
            break;
        case 6:
            return @"已回款";
            break;
        default:
            break;
    }
    return @"";
}
//我的借款根据state返回相应地状态
+(NSString *)getMyBorrowWithState:(NSString *) state
{
    switch ([state intValue]) {
        case 0:
            return @"未审核";
            break;
        case 1:
            return @"等待确认";
            break;
        case 2:
            return @"投标中";
            break;
        case 3:
            return @"流标";
            break;
        case 4:
            return @"满标";
            break;
        case 5:
            return @"还款中";
            break;
        case 6:
            return @"已还清";
            break;
        default:
            break;
    }
    return @"";
}
+(NSString *)getRepaymentWithState:(NSString *) state
{
    switch ([state intValue]) {
        case 0:
            return @"未还";
            break;
        case 1:
            return @"已还";
            break;
        case 2:
            return @"逾期未还";
            break;
        case 3:
            return @"逾期已还";
            break;
        case 4:
            return @"提前还款";
            break;
        default:
            break;
    }
    return @"";
}
+(NSString *)getMyBidWithStatus:(NSString *) status
{
    switch ([status intValue]) {
        case 0:
            return @"未收";
            break;
        case 1:
            return @"已收";
            break;
        case 2:
            return @"已转出";
            break;
        case 3:
            return @"已提前回款";
            break;
        default:
            break;
    }
    return @"";
}
+(NSString*)getRepaytimeWithState:(NSString *) state
{
//    if(state.intValue > 12)
//    {
//        return [NSString stringWithFormat:@"%@天",state];
//    }
//    NSArray *array = [[[[NSUserDefaults standardUserDefaults] objectForKey:DATADIC] objectForKey:@"result"] objectForKey:@"repay_time"];
//    for(NSDictionary *dic in array)
//    {
//        if([dic[@"itemValue2"] intValue] ==  [state intValue])
//        {
//            return dic[@"itemValue"];
//        }
//    }
    return [NSString stringWithFormat:@"%@",state];
;
    
}

+(NSString *)removePointZeroWithString:(NSString *)string
{
    NSString *tempStr = [NSString stringWithFormat:@"%.1f",[string doubleValue]];
    if ([tempStr hasSuffix:@"0"]) {
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
   tempStr = [tempStr stringByAppendingString:@"%"];
    return tempStr;
}

/** 去除文字标题中带括号的内容 */
+(NSString *)removeBracketsWithTitle:(NSString *)title
{
    NSRange rangeName = [title rangeOfString:@"（"];
    NSString *newName = nil;
    if (rangeName.length != 0) {
        newName = [title substringToIndex:rangeName.location];
    }else{
        newName = title;
    }
    return newName;
}


+(NSString *)getLoanTypeWithState:(NSString *) state
{
    NSArray *array = [[[[NSUserDefaults standardUserDefaults] objectForKey:DATADIC] objectForKey:@"result"] objectForKey:@"loan_type"];
    for(NSDictionary *dic in array)
    {
        if([dic[@"itemValue2"] intValue] == [state intValue])
        {
            return dic[@"itemValue"];
        }
    }
    return @"一次性还本付息";
}
+(NSString *)getContractTypeWithState:(NSString *) state
{
    NSArray *array = [[[[NSUserDefaults standardUserDefaults] objectForKey:DATADIC] objectForKey:@"result"] objectForKey:@"contract_type"];
    for(NSDictionary *dic in array)
    {
        if([dic[@"itemValue2"] intValue] ==  [state intValue])
        {
            return dic[@"itemValue"];
        }
    }
    return @"委托担保合同";
}

+(NSString *)getPrdGuaranteeTypeWithState:(NSString *) state
{
    
    NSArray *array = [[[[NSUserDefaults standardUserDefaults] objectForKey:DATADIC] objectForKey:@"result"] objectForKey:@"prd_guarantee_type"];
    for(NSDictionary *dic in array)
    {
        if([dic[@"itemValue2"] intValue] ==  [state intValue])
        {
            return dic[@"itemValue"];
        }
    }
    return @"出借机构";
}
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    if(phoneNumber.length == 0)
    {
        [MBProgressHUD displayHudError:@"请输入正确的手机号"];
        return NO;
    }
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch) {
        [MBProgressHUD displayHudError:@"请输入正确的手机号"];
        return NO;
        
    }
    
    return YES;
    
}
#define REFRESHTIME @"refreshTime"
#pragma mark - 状态相关
#pragma mark 设置最后的更新时间
+ (NSString *)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    // 1.归档
    [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:REFRESHTIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 2.更新时间
    return [self updateTimeLabel];
}

#pragma mark 更新时间字符串
+ (NSString*)updateTimeLabel
{
    NSDate *lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:REFRESHTIME];
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:lastUpdateTime];
    
    // 3.显示日期
    return  [NSString stringWithFormat:@"最后更新：%@", time];
}
#pragma mark -正则表达式
+(NSString *)zhengZe:(NSString *) str
{   NSString *searchString = str;
    NSString *regexString = @"\\{\\$.*?\\}";
    NSString *replaceWithString = @"";
    NSString *replacedString = NULL;
    replacedString = [searchString stringByReplacingOccurrencesOfRegex:regexString withString:replaceWithString];
    return replacedString;
}
#pragma mark -md5加密
+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}
+(NSString *) maSaiKaMobile:(NSString *) mobie
{
    if(mobie.length < 4)
    {
        return mobie;
    }
    NSString *head = [mobie substringToIndex:3];
    NSString *last = [mobie substringFromIndex:mobie.length-4];
    return [[head stringByAppendingString:@"***"] stringByAppendingString:last];
}
+(NSString *) maSaiKeName:(NSString *) name
{
    if(name.length > 0)
    {
        return [[name substringToIndex:1] stringByAppendingString:@"**"];
    }
    else
    {
        return @"";
    }
}
+(BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET6;

    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (void)viewAddLine:(UIView *)view Up:(BOOL)up
{
    if (up) {
        UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)] autorelease];
        lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [view addSubview:lineView];
    }else{
        UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, ScreenWidth, 0.5)] autorelease];
        lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [view addSubview:lineView];
    }
}

+ (NSString*)dealmoneyFormartForDetailView:(NSString*)mon
{
    if ([mon isEqualToString:@""]) {
        return @"";
    }
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSRange pointRg = [mon rangeOfString:@"."];
    NSString *afterPointStr = [mon substringFromIndex:pointRg.location+1];
    
    NSInteger mn = [mon integerValue];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInteger:mn]];
    
    string = [string stringByAppendingString:[NSString stringWithFormat:@".%@",afterPointStr]];
    return string;
}


@end
