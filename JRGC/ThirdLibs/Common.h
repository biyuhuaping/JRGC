//
//  Common.h
//  

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PicType) {
    BannerInvestSuccess = 1,        //newPrdClaims/saveDeals
    BannerMorePic,                  //newuserregist/getBannerMore
    BannerRegistPic,                //newuserregist/getBanner
    BannerRegistShowPic             //newuserregist/getBannerRegist
};
@interface Common : NSObject
// 获取唯一标示钥匙串
+ (NSString *)getKeychain;
// 获取版本号
+ (NSString *)getIOSVersion;

+ (NSString*)machineName;
//清除cookies
+ (void)deleteCookies;
//清除cookies
+ (void)setHTMLCookies:(NSString *)value andCookieName:(NSString *)cookieName;

//添加灰度测试的cookies值
+ (void)addTestCookies;
// 获取机器类型
+ (NSString *)getDeviceVersion;
//获取机器类型
+ (NSString *)platformString;
//去掉字符串前面的空格
+(NSString *)deleteStrSpace:(NSString *)str;
//去掉所有空格
+(NSString *)deleteAllStrSpace:(NSString *)str;
//字典转换字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
//字典数组转json字符串
+ (NSString *)toJSONData:(id)theData;
//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//祛除首尾空格
+ (NSString *)deleteStrHeadAndTailSpace:(NSString *)str;
//获取字符串的高度
+ (CGSize)getStrHeightWithStr:(NSString *)str AndStrFont:(CGFloat)font AndWidth:(CGFloat)width;
//祛除字符串为空得情况
+ (NSString *)checkNullStr:(NSString *)nullStr;
//Md5加密
+ (NSString *)md5:(NSString *)str;
//先锋自定义MD5加密
+ (NSString *)customMd5:(NSString *)uniqueIEM;


+ (NSString *)getBBS;
//正常AES加密
+ (NSString *)aesJiami:(NSString *)count WithKey:(NSString *)key;
//AES 加密
+ (NSString *)AESWithKey:(NSString *)key WithData:(NSString *)data;
//AES 加密2
+ (NSString *)AESWithKey2:(NSString *)key WithDic:(NSDictionary *)dic;
//AES 解密
+ (NSString *)JieAESWith:(NSString *)key WithData:(NSString *)data;
//获取单行字体宽度
+ (CGSize)getStrWitdth:(NSString *)str Font:(CGFloat )font;
+ (NSString *)AESWithKeyWithNoTranscode:(NSString *)key WithData:(NSString *)data;
+ (NSString *)AESWithKeyWithNoTranscode2:(NSString *)key WithData:(NSDictionary *)dic;

//文件写入操作
//---------------------------------------------------------------------------------
//写入临时文件
+ (BOOL)writeToTmpFileWithFileName:(NSString *)fileName;


//把设备唯一编码存入钥匙串
+ (BOOL)saveUUIDToKeyChain;
////从钥匙串中取出唯一编码
//+ (NSString *)getUniqueStr;
/**
 *  判断是否含有特殊字符
 *
 *  @param orginalString 原字符串
 *
 *  @return NO 没有特殊字符 YES 含有特殊字符
 */
+ (BOOL)isContinSpecialCharacterWithOrginalString:(NSString *)orginalString;
//检测字符串中是否含有中文 YES 为有，NO为没有
+ (BOOL)stringIsIncludeChineseWord:(NSString *)orginalStr;
/**
 *  获取ip地址
 *
 *  @return ip地址
 */
//+ (NSString *)getIPAddress;

//判断是否为纯数字
+ (BOOL)isPureNumandCharacters:(NSString *)string;
/**
 *  像素转换磅值
 *
 *  @param pixel 像素数
 *
 *  @return 磅值
 */
+ (CGFloat)pixelConvertIntoPound:(CGFloat)pixel;
// 获取UA
+ (NSString *)getUserAgent;
/**
 *  Label显示不同色值的字体
 *
 *  @param diffColor 显示不同的颜色
 *  
 *  @param sectionText 显示不同的颜色的字体
 *
 *  @param lastStr label 的所有字体
 *  @return 磅值
 */
+ (NSMutableAttributedString *)oneSectionOfLabelShowDifferentColor:(UIColor *)diffColor
                                                   WithSectionText:(NSString *)sectionText
                                                   WithTotalString:(NSString *)lastStr;

+ (NSMutableAttributedString *)twoSectionOfLabelShowDifferentColor:(NSArray *)colors
                                                   WithSectionText:(NSArray *)sectionTexts
                                                   WithTotalString:(NSString *)lastStr;
/**
 *  对一段文本添加不同颜色
 *
 *  @param colors     颜色数组，按次序排列
 *  @param rangeArray 需要变色的文本位置
 *  @param lastStr    全部文本
 *
 *  @return 更给颜色后的文本
 */
+ (NSMutableAttributedString *)twoSectionOfLabelShowDifferentColor:(NSArray *)colors
                                                 WithTextLocations:(NSArray *)rangeArray
                                                   WithTotalString:(NSString *)lastStr;
/**
 *  对一段文本添加不同格式
 *
 *  @param attributeArr 格式数组，按次序排列
 *  @param rangeArray   需要更改格式的文本位置
 *  @param totalStr     全部文本
 *
 *  @return 更给格式后的文本
 */
+ (NSMutableAttributedString *)twoSectionOfLabelShowDifferentAttribute:(NSArray *)attributeArr
                                                     WithTextLocations:(NSArray *)rangeArray
                                                       WithTotalString:(NSString *)totalStr;

//根据机型等比例拉伸尺寸
+ (CGFloat)calculateNewSizeBaseMachine:(CGFloat)inputFloat;

//获取document下的路径
+ (NSString *)filePathWithFileName:(NSString *)fileName;
//给视图加上制定颜色的水平分割线，top YES 给上边加，NO 给下方加
+ (void)addLineViewColor:(UIColor *)color With:(UIView *)view isTop:(BOOL)top;
//给视图加上制定颜色的水平分割线，top YES 给上边加，NO 给下方加 ***备注 宽度为屏幕的宽度
+ (void)addLineViewColor:(UIColor *)color WithView:(UIView *)view isTop:(BOOL)top;
+ (UIView *)addSepateViewWithRect:(CGRect)rect WithColor:(UIColor *)color;
//验证身份证号
+ (BOOL)isIdentityCard: (NSString *)identityCard;
//判断只包含中英文、数字，0~30位
+(BOOL)isEnglishAndNumbers:(NSString *)string;
//是否是纯数字
+ (BOOL)isOnlyNumber:(NSString *)string;
//判断是否是纯汉字
+ (BOOL)isChinese:(NSString *)string;
//判断是否含有汉字
+ (BOOL)includeChinese:(NSString *)string;
//银行卡合法性校验
+(BOOL)isValidCardNumber:(NSString *)sting;
//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile;
/**
 *  判断数字类型字符串 a_String 和 b_String 的大小
 *
 *  @param a_String a_String
 *  @param b_String b_String
 *
 *  @return a_String 大于 b_String 返回 1,a_String 小于 b_String 返回 -1,  a_String 等于 b_String 返回 0
 */
+ (int)stringA:(NSString *) a_String ComparedStringB:(NSString *)b_String;
/**
 *  是否清楚图片缓存 不同banneer 图的更新时间
 *
 *  @param updateTime 更新时间
 *  @param type       图片类型
 *
 *  @return nil
 */
+ (void)checkCachePicIsNeedsClear:(NSString *)updateTime PicType:(PicType)type;

#pragma mark NSDate 转化为 NSString
/**
 @return 获取时间戳
 */
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate;//获取当前系统时间戳
+ (UIImage*)convertViewToImage:(UIView*)v;

//判断设备时候拥有touchID，如有新设备手动添加
+ (BOOL)deveiceIsHaveTouchId;

//获取当前展示ViewController
+ (UIViewController *)getCurrentVC;

//获取字体宽度
+ (CGSize)getStrWitdth:(NSString *)str TextFont:(UIFont *)font;

//获取字符串 添加段落 字号的高度
+ (CGSize)getStrHeightWithStr:(NSString *)str AndStrFont:(CGFloat)font AndWidth:(CGFloat)width AndlineSpacing:(CGFloat)lineSpacing;
//获取 添加段落 字号的 字典
+(NSDictionary *)getParagraphStyleDictWithStrFont:(CGFloat)font WithlineSpacing:(CGFloat )lineSpacing;
//验签
+ (NSString *) getSinatureWithPar:(NSString *) p;
+ (NSString *) getParStr:(NSString *) str;

//判断用户是否开启推送开关／是否允许推送消息设置
+(BOOL)isAllowedNotification;
//判断返回值是否为空、null、nil和<null>
+(BOOL)isNullValue:(id)value;

//UIImage:去色功能的实现（图片灰色显示）
+ (UIImage *)grayImage:(UIImage *)sourceImage;

//把字典转换为参数形式
+ (NSString *)getParameterByDictionary:(NSDictionary *)dic;
//获取启动页
+ (UIImage *)getTheLaunchImage;
//创建工场二维码图片
+(NSData *)createImageCode:(NSString *)gcmStr;
//创建工场二维码图片
+(UIImage *)createImageCode:(NSString *)gcmStr withWith:(CGFloat)width;
//合成图片
+ (UIImage *)composeImageCodeWithBackgroungImage:(UIImage *)backgroundImage withCodeImage:(UIImage *)codeImage;
// 获取网络图片
+(UIImage *) getImageFromURL:(NSString *)fileURL;

+ (void)storeImage:(NSURL *)imagePath2;
//batch按钮的背景图片获取方法
+ (UIImage *)batchImageSelectedState:(CGRect)rect;
+ (UIImage *)batchImageNormalState:(CGRect)rect;
//四舍五入方法
+(NSString *)notRounding:(double)price afterPoint:(int)position;
//改变一部分字体大小
+ (NSMutableAttributedString*) changeLabelWithAllStr:(NSString *)allStr Text:(NSString*)needText Font:(CGFloat)font;
//获取URL的指定参数对应值
+ (NSString *) paramValueOfUrl:(NSString *)url withParam:(NSString *) param;

+(NSString *)getNewBankNumWitOldBankNum:(NSString *)bankNum;

/**
 获取bundleID

 @return bundleID
 */
+(NSString*)getBundleID;

@end
