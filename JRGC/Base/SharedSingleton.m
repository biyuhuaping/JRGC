//
//  SharedSingleton.m
//  LifeApp
//
//  Created by uway_soft on 13-6-17.
//  Copyright (c) 2013年 uway_soft. All rights reserved.
//

#import "SharedSingleton.h"
#import <MessageUI/MessageUI.h>
#import <CoreText/CoreText.h>
#import <Foundation/Foundation.h>
#import "BaseAlertView.h"

static SharedSingleton *_sharedObj = nil;


@implementation SharedSingleton

//基本方法实现
+(SharedSingleton *)sharedInstance
{
    @synchronized (self) {
        if (nil == _sharedObj) {
            _sharedObj = [[self alloc]init];
        }

    }
    return _sharedObj;
}

//重写allocWithZone方法
+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (_sharedObj == nil) {
            _sharedObj = [super allocWithZone:zone];
            return _sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];//往往放一些要初始化的变量.
        return self;
    }
}

+(id)getAUsefulInstanceWith:(NSDictionary *)attributes key:(NSString *)key{
    
    if ([[attributes objectForKey:key] isKindOfClass:[NSNumber class]] || [[attributes objectForKey:key] isKindOfClass:[NSString class]])
    {
        return [NSString stringWithFormat:@"%@", [attributes objectForKey:key]];
    }
    else
    {
        return @"";
//        NSLog(@"字段值Id读取异常(字段不存在或者值为空)");
    }
}

- (void)canViewController1:(UINavigationController *)vc1 goViewController2:(UIViewController *)vc2
{
    viewContoller1 = vc1;

    if (SingleUserInfo.loginData.userInfo.userId) {
        [vc1 pushViewController:vc2 animated:YES];
        viewContoller1 = nil;
        [vc2 release];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您尚未登录，是否前往登录呢？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
        alert.tag = 100;
        [alert release];
        
    }
    
}

- (void)canDelegete:(UIViewController *)target doAction:(SEL)selector{
    
    if (SingleUserInfo.loginData.userInfo.userId) {
        [target performSelector:selector withObject:nil];
        
    }else{
        viewContoller2 = target;
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您尚未登录，是否前往登录呢？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
        alert.tag = 200;
        [alert release];
        
    }
    
}

+ (NSString *)theInterValTimeFromCreateTime:(NSString *)createTime
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //两个日期对象
    NSDate *currentTime=[dateFormatter dateFromString:[dateFormatter stringFromDate:[[[NSDate alloc] init] autorelease]]];
    DDLogDebug(@"currentTime = %@",currentTime);
    [dateFormatter release];
    
    NSDate *cTime=[dateFormatter dateFromString:createTime];
    DDLogDebug(@"cTime = %@",cTime);
    NSTimeInterval time=[currentTime timeIntervalSinceDate:cTime];

    //间隔日期
    NSInteger days = time/(3600*24);
    NSInteger hours =  time/(3600);
    NSInteger minites =  time/60;
    DDLogDebug(@"components = %f",time);
    if (days >= 7) {
        NSString * tempStr = [dateFormatter stringFromDate:cTime];
        return [tempStr substringToIndex:10];
    }else if (days){
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }else if (hours){
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }else if(minites){
        return [NSString stringWithFormat:@"%ld分钟前",(long)minites];
    }
    return @"刚发布";
}

+ (BOOL)isTimeOlderThanCurrentTime:(NSString *)timeString
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate=[df dateFromString:timeString];
    NSLog(@"inputDate =%@",inputDate);
    
    NSDate * currentDate = [NSDate date];
    NSString * currentFateString = [df stringFromDate:currentDate];
    NSDate *standardCurrentDate=[df dateFromString:currentFateString];
    [df release];
    NSLog(@"standardCurrentDate =%@",standardCurrentDate);
    
    switch ([inputDate compare:currentDate]) {
        case NSOrderedSame:
            DDLogDebug(@"相等");
            return NO;
            break;
        case NSOrderedAscending:
            DDLogDebug(@"date1比date2小");
            return YES;
            break;
        case NSOrderedDescending:
            DDLogDebug(@"date1比date2大");
            return NO;
            break;
        default:
            [[BaseAlertView getShareBaseAlertView]showString:@"您输入的时间格式有误！"];
            return NO;
            break;
    }
    return YES;
    
}

+ (BOOL) isTime1:(NSString *)time1String  orderThanTime2:(NSString *)time2String
{
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1=[df dateFromString:time1String];
    NSLog(@"date1 =%@",date1);
    if (time1String && date1 == nil) {
        return NO;
    }
    
    NSDate *date2=[df dateFromString:time2String];
    NSLog(@"date2 =%@",date2);
    [df release];

    if (time2String && date2 == nil) {
        return NO;
    }
    
    switch ([date1 compare:date2]) {
        case NSOrderedSame:
            DDLogDebug(@"相等");
            return NO;
            break;
        case NSOrderedAscending:
            DDLogDebug(@"date1比date2小");
            return YES;
            break;
        case NSOrderedDescending:
            DDLogDebug(@"date1比date2大");
            return NO;
            break;
        default:
            [[BaseAlertView getShareBaseAlertView]showString:@"您输入的时间格式有误！"];
            return NO;
            break;
    }
    return YES;
    
}


+ (NSString *)lastTime:(NSDate *)lockDate
{
    NSDate *currentDate = [[NSDate alloc] init];
    //获得两个日期之间的间隔
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:currentDate toDate:lockDate options:0];
    
    NSInteger minites = [components minute];
    NSInteger seconds = [components second];
    [currentDate release];
    [gregorian release];
    //编辑锁定栏且启动计时
    if (minites>0 || seconds >= 0) {
        
        if (seconds >= 10) {
        return  [NSString stringWithFormat:@"0%ld:%ld",(long)minites,(long)seconds];
        }else{
        return [NSString stringWithFormat:@"0%ld:0%ld",(long)minites,(long)seconds];
        }
    }
    return nil;
}
#pragma mark 计算方法

+ (CGSize) sizeOfCurrentString:(NSString *)aString font:(float)fontSize contentSize:(CGSize)size WithName:(NSString*)fontname
{
    CGSize stringSize = [aString sizeWithFont:[UIFont fontWithName:fontname size:(CGFloat)fontSize]
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize;
}

//字符串尺寸
+ (CGSize) sizeOfCurrentString:(NSString *)aString font:(float)fontSize contentSize:(CGSize)size
{
    CGSize stringSize = [aString sizeWithFont:[UIFont systemFontOfSize:fontSize]
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize;
}



+ (float) heightOfCurrentString:(NSString *)aString font:(float)fontSize contentSize:(CGSize)size
{
    CGSize stringSize = [aString sizeWithFont:[UIFont systemFontOfSize:fontSize]
                            constrainedToSize:size
                                lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize.height;
}

+ (NSString *)getANormalString:(NSString *)originString
{
    NSString *flowdesc = originString;
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"<!--br-->" withString:@"\n"];
    flowdesc = [flowdesc stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];

    return flowdesc;
}

+(BOOL)CallPhoneWithNumber:(NSString *)number{

    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];
    
}


+(BOOL)SendMessageWithRecip:(NSArray *)recip WithDelegate:(id)delegate{

    if([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
        controller.messageComposeDelegate = delegate;
        controller.recipients = recip;
        [delegate presentViewController:controller animated:YES completion:nil];
        
        return YES;
    }
    return NO;
    
}

+(BOOL)SendEmailWithRecipients:(NSArray*)recipients Delegate:(id)delegate{

    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc]init] autorelease];
        mailController.mailComposeDelegate = delegate;
        [mailController setToRecipients:recipients];
        [delegate presentViewController:mailController animated:YES completion:nil];
        
        return YES;
    }
    
    return NO;
}

+(bool)checkDevice:(NSString*)name
{
    NSString* deviceType = [UIDevice currentDevice].model;
    DDLogDebug(@"deviceType = %@", deviceType);
    
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}


+(NSString*)ReplacingString:(NSString*)astring{
    
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    
    astring=[astring stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    return astring;
    
}

+(void) clearCookieAndCache{
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    
    //清除web缓存
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    
}

+(void) addSearchHistory:(NSString *)searchText
{
    if (searchText == nil || searchText.length == 0) {
        return;
    }
    NSString*datakey=[NSString stringWithFormat:@"%@data",[[NSUserDefaults standardUserDefaults]objectForKey:@"empId"]];
    
    NSMutableArray *searchHistory = [[[NSMutableArray alloc]initWithCapacity:2] autorelease];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:datakey]) {
        [searchHistory addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:datakey]];
    }
    

    if ([searchHistory containsObject:searchText])[searchHistory removeObject:searchText];

    [searchHistory insertObject:searchText atIndex:0];
    [[NSUserDefaults standardUserDefaults]setObject:searchHistory forKey:datakey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}



#pragma mark -

//+ (BOOL)validateMobile:(NSString *)mobile {
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
//}


+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    
    if (![self isValidateMsg:phoneNumber]) {
        return NO;
    }
    //NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSString *regex = @"^1[1,2,3,4,5,6,7,8,9,0]\\d{9}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch) {
        //[[BaseAlertView getShareBaseAlertView] showString:@"请输入有效手机号"];
        return NO;
        
    }
    
    return YES;
    
}

+ (BOOL)isNumber:(NSString *)numberString
{
    NSString *regex = @"[0-9]";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:numberString];
    
}

+(BOOL)isHanziWithString:(NSString *)aString{
    if (aString == nil || [aString isEqualToString:@""] || [[aString stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return NO;
    }
    
    NSString * Hanzi = @"^[\u4E00-\u9FA5]{2,20}$";
    NSPredicate *regextesthanzi = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Hanzi];
    return [regextesthanzi evaluateWithObject:aString];
}

//是否为英文字幕
+(BOOL)IsEGString:(NSString *)aString
{
    DDLogDebug(@"email = %@",aString);
    NSString *emailRegex = @"[A-Za-z]";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:aString];
    
}

+(BOOL)isValidateName:(NSString *)name
{
    if (name == nil || [name isEqualToString:@""] || [[name stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return NO;
    }
    NSString *nameRegex = @"(^[A-Za-z\u4E00-\u9FA5]{2,20}$)";
    NSPredicate *regextestName = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [regextestName evaluateWithObject:name];
}

+(BOOL)isValidateContent:(NSString *)content
{
    if (content == nil || [content isEqualToString:@""] || [[content stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return NO;
    }
    return content.length;
    
//    NSString *contentRegex = @"([0-9._%+－,。｜、／｀～！？（）《》<>@*()!?#$￥\u4E00-\u9FA5]{2,2000})";
//    
//    NSPredicate *contentTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", contentRegex];
//    
//    return [contentTest evaluateWithObject:content];
    
}

+(BOOL)isValidateEmail:(NSString *)email
{
    if (nil == email) {
        return NO;
    }
    DDLogDebug(@"email = %@",email);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

+(BOOL)isValidatePassWord:(NSString *)passWord
{
    if (![self isValidateMsg:passWord]) {
        return NO;
    }
   
//    NSString *passWordRegex = @"(^(?![^a-zA-Z]+$)(?!\\D+$).{6,16}$)";
    
//    NSString *passWordRegex = @"^(?![a-zA-z]+$)(?!\\d+$)(?![!@#$%^&*]+$)[a-zA-Z\\d!@#$%^&*]+$";
    NSString *passWordRegex = @"^(?![\\d]+$)(?![a-zA-Z]+$)(?![^\\da-zA-Z]+$).{6,20}$";
    NSPredicate *passWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordTest evaluateWithObject:passWord];
//    return [passWord isMatchedByRegex:passWordRegex];
}


+(BOOL)isValidateUserName:(NSString *)userName
{
    if (![self isValidateMsg:userName]) {
        return NO;
    }
    
    NSString *userNameRegex = @"(^[A-Za-z0-9\u4E00-\u9FA5]{6,16}$)";
    //NSString *userNameRegex = @"[a-z][A-Z][0-9]";
    
    NSPredicate *serNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    
    return [serNameTest evaluateWithObject:userName];
}

+(BOOL)isValidateMsg:(NSString *)data
{
    if (nil == data || [data isEqualToString:@""] || [[data stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] ) {
        return NO;
    }
    return YES;
}

+ (BOOL)isSearchTextTooShort:(NSString *)searchText
{
    if (nil == searchText) {
        return NO;
    }
    DDLogDebug(@"email = %@",searchText);
    NSString *searchTextRegex = @"[A-Za-z0-9]{1}";
    NSPredicate *searchTextTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", searchTextRegex];
    if ([searchTextTest evaluateWithObject:searchText]) {
        [[BaseAlertView getShareBaseAlertView]showString:@"您输入的关键词过短"];
    }
    return [searchTextTest evaluateWithObject:searchText];
    
}

+ (BOOL)isPINCodeIsWrong:(NSString *)pinCode
{
    NSArray *wrongNumbers = [[[NSArray alloc]initWithObjects:
                             @"0000",
                             @"1111",
                             @"2222",
                             @"3333",
                             @"4444",
                             @"5555",
                             @"6666",
                             @"7777",
                             @"8888",
                             @"9999",
                             @"0123",
                             @"1234",
                             @"2345",
                             @"3456",
                             @"6789",
                             @"7890",
                             @"8901",
                             @"9012", nil] autorelease];
    
    for (int i = 0; i<wrongNumbers.count; i++) {
        if ([pinCode isEqualToString:[wrongNumbers objectAtIndex:i]]) {

            [[BaseAlertView getShareBaseAlertView]showString:@"您的密码过于简单"];

            return YES;
        }
    }
    return NO;
    
}

+ (UILabel *)addAlabelForAView:(UIView *)aView withText:(NSString *)labelText frame:(CGRect)labelFrame font:(UIFont *)labelFont textColor:(UIColor *)labelColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.tag=2;
    label.text = labelText;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.backgroundColor = [UIColor clearColor];
    label.font = labelFont;
    if (labelColor) {
        label.textColor = labelColor;

    }
    [aView addSubview:label];
    return [label autorelease];
}

+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length != 15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            [regularExpression release];
            if(numberofMatch > 0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year % 4 ==0 || (year % 100 ==0 && year % 4 ==0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];// 测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
            [regularExpression release];
            if(numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)]; // 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
            }else {
                return NO;
            }
        default:
            return false;
    }
}

+ (UITextField *)getATFWithFrame:(CGRect)frame delegate:(id)delegate palceHolder:(NSString *)placeHolder image:(NSString *)imageName
{
    UITextField * textfeild = [[UITextField alloc]initWithFrame:frame];
    textfeild.delegate = delegate;
    [textfeild setBorderStyle:UITextBorderStyleNone];
    
    textfeild.autocorrectionType = UITextAutocorrectionTypeNo;
    textfeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textfeild.returnKeyType = UIReturnKeyDone;
    //    textfeild.textAlignment = NSTextAlignmentCenter;
    textfeild.placeholder =placeHolder;
    textfeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (imageName) {
        textfeild.leftViewMode = UITextFieldViewModeAlways;
        textfeild.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        
    }
    return [textfeild autorelease];
}

+ (UIButton *)getAButtonWithFrame:(CGRect)frame nomalTitle:(NSString *)title1 hlTitle:(NSString *)title2 titleColor:(UIColor *)tColor bgColor:(UIColor *)BgColor nbgImage:(NSString *)image1 hbgImage:(NSString *)image2 action:(SEL)selector target:(id)delegate buttonTpye:(UIButtonType)theButtonTpye
{
    UIButton *button = nil;
    if (theButtonTpye) {
        button = [UIButton buttonWithType:theButtonTpye];

    }else{
        button = [UIButton buttonWithType:UIButtonTypeCustom];
    }

    button.frame = frame;
    if (title1) {[button setTitle:title1 forState:UIControlStateNormal];}
    if (title2) {[button setTitle:title1 forState:UIControlStateHighlighted];}
    if (tColor) {
        [button setTitleColor:tColor forState:UIControlStateNormal];
    }
    
    if (BgColor) {
        [button setBackgroundColor:BgColor];
    }
    
    if (image1) {[button setBackgroundImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];}
    if (image2) {[button setBackgroundImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];}
    if (delegate && selector) {
        [button addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
    }

    return button;
    
}


+(void)addTopLine:(BOOL)isTop topLineColor:(UIColor *)TopLineColor bottomLine:(BOOL)isBottom  bottomLineColor:(UIColor *)BottomLineColor toCell:(UITableViewCell *)cell
{
    if (isTop) {
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, cell.frame.size.width, 0.5)];
        if (TopLineColor) {
            topLine.backgroundColor = TopLineColor;

        }else{
            topLine.backgroundColor = UIColorWithRGB(0xcccccc);

        }
        [cell addSubview:topLine];
        [topLine release];
    }
    
    if (isBottom) {
        
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0.0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5)];
        if (BottomLineColor) {
            bottomLine.backgroundColor = BottomLineColor;
            
        }else{
            bottomLine.backgroundColor = UIColorWithRGB(0xcccccc);
            
        }
        [cell addSubview:bottomLine];
        [bottomLine release];
    }

}

+ (UIView *)addLineToCell:(UITableViewCell *)cell frame:(CGRect)frame
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = UIColorWithRGB(0xcccccc);
    [cell.contentView addSubview:line];
    return [line autorelease];
}

+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Text2:(NSString *)text2 Color2:(UIColor *)color2 AllText:(NSString *)allText
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text1) {
        NSRange range1 = [allText rangeOfString:text1];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color1 range:range1];
        
    }
    
    if (text2) {
        NSRange range2 = [allText rangeOfString:text2];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color2 range:range2];
    }
    
    
    [str endEditing];
    
    return [str autorelease];
}

+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Font1:(UIFont *)font1 Text2:(NSString *)text2 Color2:(UIColor *)color2 Font2:(UIFont *)font2 AllText:(NSString *)allText
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text1) {
        NSRange range1 = [allText rangeOfString:text1];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color1 range:range1];
        if (font1) {
            //            CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)font1.fontName,font1.pointSize,NULL);
            //        [str addAttribute:(id)kCTFontAttributeName value:(id)helveticaBold range:range1];
            [str addAttribute:NSFontAttributeName value:font1 range:range1];
            
        }
    }
    
    if (text2) {
        NSRange range2 = [allText rangeOfString:text2];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color2 range:range2];
        if (font2) {
            [str addAttribute:NSFontAttributeName value:font2 range:range2];
            
        }
    }
    
    [str endEditing];
    
    return [str autorelease];
}

+ (NSArray *)bankArrayList
{
    NSArray *bankList = [[[NSArray alloc]initWithObjects:@"工商银行",@"农业银行",@"中国银行",@"建设银行",@"交通银行",@"华夏银行",@"光大银行",@"招商银行",@"中信银行",@"兴业银行",@"民生银行",@"深圳发展银行",@"广东发展银行",@"上海浦东发展银行",@"渤海银行",@"恒丰银行",@"浙商银行",@"北京银行",@"宁波银行",@"徽商银行",@"济南商业银行",@"石家庄商业银行",@"中国邮政储蓄银行", nil] autorelease];
    return bankList;
}

+(NSArray *)bankCardType
{
    NSArray *cardType = [[[NSArray alloc]initWithObjects:@"储蓄卡",@"信用卡",@"存折", nil] autorelease];
    return cardType;
}

+(void)resignFirstRespoder{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (void)firstResponder
{
    
}

+ (void)addLineToView:(UIView *)view frame:(CGRect)frame
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = UIColorWithRGB(0xcccccc);
    [view addSubview:line];
    [line release];
}

+ (void)addLineToView:(UIView *)view frame:(CGRect)frame color:(UIColor *)color
{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = color;
    [view addSubview:line];
    [line release];
}

- (void) dealloc
{
    [super dealloc];
}

@end
