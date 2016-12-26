//
//  CWFaceViewController.h
//  CloudwalkFaceSDK
//
//  Created by DengWuPing on 16/8/29.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CloudwalkFaceSDK.h"

//获取最佳人脸图片的代理
@protocol cwBestFaceDelegate <NSObject>

/**
 *  @brief 活体检测代理方法
 *
 *  @param isSame  是否是同一个人
 *  @param faceScore 人脸比对的分数
 *  @param bestFaceData 获取的最佳人脸图片
 *  @param code 返回所有的错误码   0 成功，其他错误码
 */
-(void)cwFaceIsTheSamePerson:(BOOL)isSame faceScore:(double)faceScore errorCode:(NSInteger)code BestFace:(NSData  *)bestFaceData;

@end

@interface CWFaceViewController : UIViewController
/**
 *  @brief 代理
 */
@property(nonatomic,assign)id<cwBestFaceDelegate> delegate;

/**
 *  @brief SDK授权码 （必须传入正确的授权码）
 */
@property(nonatomic,strong)NSString * authCodeString;

/**
 *  @brief 获取最佳人脸图片的时间
 */
@property(nonatomic,assign)NSInteger bestFaceTime;

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


@property(nonatomic,weak)IBOutlet  UILabel  * titleLabel; //标题label

@property(nonatomic,weak)IBOutlet  UIView  * guideView; //进入活体检测的引导VIew

@property(nonatomic,weak)IBOutlet  UIView  * cameraView; //视频预览View

@property(nonatomic,weak)IBOutlet  UIView  * bottomView; //进入活体检测的引导VIew

@property(nonatomic,weak)IBOutlet  UIImageView  * tipsImageView; //提示将人脸放入取景框中

@property(nonatomic,weak)IBOutlet  UILabel  * actionNameLabel;//活体动作名称显示label


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
 *  @param isShowResult 是否显示结果页面
 *  @param isCompare    是否在获取最佳人脸图片之后进行人脸比对
 */
-(void)setLivessParam:(NSString *)authCode isShowResultView:(BOOL)isShowResult isFaceCompare:(BOOL)isCompare;


@end
