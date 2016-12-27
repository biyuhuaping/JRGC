//
//  SharedSingleton.h
//  LifeApp
//
//  Created by uway_soft on 13-6-17.
//  Copyright (c) 2013年 uway_soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSingleton : NSObject
{
    UINavigationController * viewContoller1;
    UIViewController * viewContoller2;
}
//@property (nonatomic,strong)UIAlertView *shareAlertView;
//@property (nonatomic,strong)UIActionSheet*sheet;

+(SharedSingleton *)sharedInstance;

+(id)getAUsefulInstanceWith:(NSDictionary *)attributes key:(NSString *)key;

//检验用户是否已经登录
- (void)canViewController1:(UINavigationController *)vc1 goViewController2:(UIViewController *)vc2; //传递的vc2无需再释放了

- (void)canDelegete:(UIViewController *)target doAction:(SEL)selector;


+ (NSString *)theInterValTimeFromCreateTime:(NSString *)createTime;
+ (BOOL) isTimeOlderThanCurrentTime:(NSString *)timeString;   //比较时间是否比当前时间早
+ (BOOL) isTime1:(NSString *)time1String  orderThanTime2:(NSString *)time2String;   //比较两时间
+ (NSString *)lastTime:(NSDate *)lockDate;

//计算字符串
+ (CGSize) sizeOfCurrentString:(NSString *)aString font:(float)fontSize contentSize:(CGSize)size;
+ (CGSize) sizeOfCurrentString:(NSString *)aString font:(float)fontSize contentSize:(CGSize)size WithName:(NSString*)fontname;

//获取一个不含特殊字符串的正常字符串
+ (NSString *)getANormalString:(NSString *)originString;

//打电话
+ (BOOL)CallPhoneWithNumber:(NSString*)number;

//发短信
+(BOOL)SendMessageWithRecip:(NSArray*)recip WithDelegate:(id)delegate;

//发邮件
+(BOOL)SendEmailWithRecipients:(NSArray*)recipients Delegate:(id)delegate;

//检查设备名
+(bool)checkDevice:(NSString*)name;

//字符串替换
+(NSString*)ReplacingString:(NSString*)astring;

//清除webview的cookie和缓存

+(void) clearCookieAndCache;

//添加到搜索记录
+(void) addSearchHistory:(NSString *)searchText;

//返回一个可以变色的字符串
+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Text2:(NSString *)text2 Color2:(UIColor *)color2 AllText:(NSString *)allText;

+(NSMutableAttributedString *)getAcolorfulStringWithText1:(NSString *)text1 Color1:(UIColor *)color1 Font1:(UIFont *)font1 Text2:(NSString *)text2 Color2:(UIColor *)color2 Font2:(UIFont *)font2 AllText:(NSString *)allText;


//取消app的第一响应者
+(void)resignFirstRespoder;

//+ (BOOL)validateMobile:(NSString *)mobile;
//检查是否为有效电话号码
+ (BOOL)checkPhoneNumber:(NSString *)phoneNumber;

//是否为数字
+ (BOOL)isNumber:(NSString *)numberString;

//是否为有效用户名
+(BOOL)isValidateUserName:(NSString *)userName;

// 是否为空
+(BOOL)isValidateMsg:(NSString *)data;

//是否为有效邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

//是否有有效密码
+ (BOOL)isValidatePassWord:(NSString *)passWord;

//搜索字段是否过短
+ (BOOL)isSearchTextTooShort:(NSString *)searchText;

+ (BOOL)isPINCodeIsWrong:(NSString *)pinCode;

//输入的是否为汉字
+ (BOOL)isHanziWithString:(NSString*)aString;

//是否为英文字幕
+(BOOL)IsEGString:(NSString *)aString;

//是否为一个有效的姓名
+(BOOL)isValidateName:(NSString *)name;

//是否为有效的内容
+(BOOL)isValidateContent:(NSString *)content;


//给某个视图生成一个标签
+ (UILabel *)addAlabelForAView:(UIView *)aView withText:(NSString *)labelText frame:(CGRect)labelFrame font:(UIFont *)labelFont textColor:(UIColor *)labelColor;

// 身份证号码检测
+ (BOOL)validateIDCardNumber:(NSString *)value;

+ (UITextField *)getATFWithFrame:(CGRect)frame delegate:(id)delegate palceHolder:(NSString *)placeHolder image:(NSString *)imageName;

//获取一个按钮
+ (UIButton *)getAButtonWithFrame:(CGRect)frame nomalTitle:(NSString *)title1 hlTitle:(NSString *)title2 titleColor:(UIColor *)tColor bgColor:(UIColor *)BgColor nbgImage:(NSString *)image1 hbgImage:(NSString *)image2 action:(SEL)selector target:(id)delegate buttonTpye:(UIButtonType)theButtodnTpye;

//给cell添加上、下线
+(void)addTopLine:(BOOL)isTop topLineColor:(UIColor *)TopLineColor bottomLine:(BOOL)isBottom  bottomLineColor:(UIColor *)BottomLineColor toCell:(UITableViewCell *)cell;
+ (UIView *)addLineToCell:(UITableViewCell *)cell frame:(CGRect)frame;
+ (void)addLineToView:(UIView *)view frame:(CGRect)frame;
+ (void)addLineToView:(UIView *)view frame:(CGRect)frame color:(UIColor *)color;

@end
