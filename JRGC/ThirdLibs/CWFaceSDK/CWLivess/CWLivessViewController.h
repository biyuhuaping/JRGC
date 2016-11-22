//
//  LiveDetectViewController.h
//  CloudwalkFaceSDKDemo
//
//  Created by DengWuPing on 16/5/12.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudwalkFaceSDK.h"
#import "UCFBaseViewController.h"
//活体检测代理
@protocol cwIntegrationLivessDelegate <NSObject>

/**
 *  @brief 活体检测代理方法
 *
 *  @param isAlive       是否是活体
 *  @param bestFaceImage 获取的最忌人脸图片
 *  @param isSame  是否是同一个人
 *  @param faceScore 人脸比对的分数
 *  @param code 返回所有的错误码   0 成功，其他错误码
 */
@optional   -(void)cwIntergrationLivess:(BOOL)isAlive  isTheSamePerson:(BOOL)isSame faceScore:(double)faceScore errorCode:(NSInteger)code BestFaceImage:(NSData  *)bestFaceData;


#pragma mark - 刷脸登陆后反回的数据处理
@optional   - (void)transformCloudWalkReconise:(id)_data;


@end

@interface CWLivessViewController : UCFBaseViewController
/**
 *  @brief 代理
 */
@property(nonatomic,assign)id<cwIntegrationLivessDelegate> delegate;

/**
 *  @brief SDK授权码 （必须传入正确的授权码）
 */
@property(nonatomic,strong)NSString * authCodeString;

/**
 *  @brief 活体个数
 */
@property(nonatomic,assign)NSInteger livessNumber;

/**
 *  @brief 活体等级 默认为 CWLiveDetectStandard 中等难度
 */
@property(nonatomic,assign)CWLiveDetectlLevel liveLevel;

/**
 *  @brief 是否显示结果页面
 */
@property(nonatomic,assign)BOOL isShowResultView;

/**
 *  @brief 是否进行人脸比对
 */
@property(nonatomic,assign)BOOL isFaceCompare;

/**
 *  @brief 人脸比对基础图片
 */
@property(nonatomic,strong)UIImage * compareImage;

/**
 *  @brief 云之眼服务器ip地址
 */
@property(nonatomic,strong)NSString * ipaddress;
/**
 *  @brief 云之眼服务器 app_id
 */
@property(nonatomic,strong)NSString * app_idStr;

/**
 *  @brief 云之眼服务器 app_secret
 */
@property(nonatomic,strong)NSString * app_secretStr;

/**
 *  @brief 人脸比对的阈值
 */
@property(nonatomic,assign)double thresholdScore;


/**
 *  @flagway 0-人脸录入，1-人脸登录
 */

@property int flagway;

/**
 *  @ForwardPageuserName 在人脸登录时，需要上一次登录的账户名作为请求参数
 */
@property (strong,nonatomic) NSString* ForwardPageuserName;
/**
 *  @brief 禁用init方法 改用 initWithNibName:bundle
 *
 *  @return
 */
-(id)init NS_DEPRECATED_IOS(6_0,6_0,"Use -initWithNibName:bundle: instead");

/**
 *  @brief 禁用initWithCoder方法 改用 initWithNibName:bundle
 *
 *  @return
 */
-(id)initWithCoder:(NSCoder *)aDecoder NS_DEPRECATED_IOS(6_0,7_0,"Use -initWithNibName:bundle: instead");

/**
 *  @brief 设置人脸比对参数
 *
 *  @param faceImage 比对基础照片
 *  @param ipaddress 云之眼服务器ip地址
 *  @param appID     云之眼app_id （私有云时默认为“user”）
 *  @param appSecret 云之眼服务器app_secret （私有云时默认为“12345”）
 *  @param score     人脸比对阈值 推荐阈值为 0.7
 */
-(void)setFaceCompare:(UIImage *)faceImage ipadress:(NSString *)ipaddress app_id:(NSString *)appID app_Secret:(NSString *)appSecret thresholdScore:(double)score;

/**
 *  @brief 设置活体检测参数
 *
 *  @param authCode     SDK授权码
 *  @param activeNumber 活体动作个数
 *  @param level        活体难易等级
 *  @param isShowResult 是否显示结果页面
 *  @param isCompare    是否在活体完成之后进行人脸比对
 */
-(void)setLivessParam:(NSString *)authCode livessNumber:(NSInteger)activeNumber livessLevel:(CWLiveDetectlLevel)level  isShowResultView:(BOOL)isShowResult isFaceCompare:(BOOL)isCompare;
/**
 *  @brief 返回跟视图
 *
 *  @param sender 返回按钮
 */
-(IBAction)backToHomeViewController:(id)sender;
@end
