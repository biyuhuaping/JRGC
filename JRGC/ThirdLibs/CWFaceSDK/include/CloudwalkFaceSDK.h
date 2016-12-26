//
//  CloudwalkFaceSDK.h
//  CloudwalkFaceSDK
//
//  Created by DengWuPing on 16/5/10.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSInteger,CW_LivenessCode){
    
    //活体检测代码返回
    CW_FACE_LIVENESS_OPENMOUTH = 700,     //检测到张嘴
    CW_FACE_LIVENESS_BLINK,               //检测到眨眼
    CW_FACE_LIVENESS_HEADPITCH,           //检测到抬头
    CW_FACE_LIVENESS_HEADDOWN,            //检测到点头
    CW_FACE_LIVENESS_HEADLEFT,            //检测到左转
    CW_FACE_LIVENESS_HEADRIGHT,           //检测到右转
    
    //活体检测失败
    CW_FACE_LIVENESS_NOPEPOLE,            //没有检测到人脸
    CW_FACE_LIVENESS_MULTIPERSONE,        //检测到多个人
    CW_FACE_LIVENESS_PEPOLECHANGED,       //检测到换人
    CW_FACE_LIVENESS_WRONGACTION,         //错误动作
    CW_FACE_LIVENESS_OVERTIME,            //检测超时
                                          //检测到攻击
    CW_FACE_LIVENESS_ATTACK_SHAKE = 711,  //检测到攻击-图像抖动
    CW_FACE_LIVENESS_ATTACK_MOUTH,        //检测到攻击-嘴被扣取
    CW_FACE_LIVENESS_ATTACK_RIGHTEYE,     //检测到攻击-右眼被扣取
    CW_FACE_LIVENESS_ATTACK_PICTURE,      //检测到攻击-图片攻击
    CW_FACE_LIVENESS_ATTACK_UNSTABLE,     //检测到攻击-人脸不稳定
    CW_FACE_LIVENESS_ATTACK_PAD,          //检测到攻击-方框(如纸片、pad)攻击
    CW_FACE_LIVENESS_ATTACK_VIDEO,        //检测到攻击-视频攻击
    
};


//人脸检测和活体检测的代理方法

@protocol cwDelegate <NSObject>

/**
 *  活体检测代理方法
 *  @param contextType    活体动作通过与否的编码
 *  @param imageData          活体通过时的人脸图片数据 JPG格式的
 */

@optional
//contextType  定义

-(void)cwLivessInfoCallBack:(CW_LivenessCode)contextType liveImage:( NSData  * __nullable)imageData;

/**
 *  人脸信息返回代理方法
 *  @param personsArry    人脸信息字典
 */

@optional
-(void)cwFaceInfoCallBack:(NSArray *__nullable)personsArry;

@end

//视频流格式
typedef NS_ENUM(NSInteger,CWFaceBufferType)
{
    CWFaceBufferBGRA=1,//视频流格式 BGRA    kCVPixelFormatType_32BGRA
    CWFaceBufferYUV420,//视频流格式  YUV420  kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
};

typedef NS_ENUM(NSInteger,CWLiveDetectlLevel){
    CWLiveDetectLow=0,        //活体检测难度低
    CWLiveDetectStandard,    //活体检测难度中等   转头区分左右、上下  检测出当前动作则为通过
    CWLiveDetectLevelHigh    //活体检测难度高     严格动作控制、检测出与当前提示不同的动作则为失败
};

//活体检测动作定义
typedef NS_ENUM(NSInteger,CWLiveDetectType)
{
    CWLiveHeadTurnLeft,//向左转头
    CWLiveHeadTurnRight,//向右转头
    CWLiveHeadRise,//向上抬头
    CWLiveHeadDown,//向下低头
    CWLiveOpenMouth,//张嘴
    CWLiveBlink,//眨眼
};

typedef NS_ENUM(NSInteger,CW_FaceDETCode){
    CW_FACE_DET_OK = 0, //成功
                        //算法SDK错误码返回
    CW_FACE_EMPTY_FRAME = 20000,		    // 空图像
    
    CW_FACE_UNSUPPORTFRAME,			      // 图像格式不支持
    CW_FACE_DATA_UNAVAILABLEORLOSE,             // 数据缺失或无效
    CW_FACE_DETECTED_NOFACE,                        // 没有人脸
    CW_FACE_SETROI_FAILED,						// ROI设置失败
    CW_FACE_SETMINMAX_FAILED,						// 最小最大人脸设置失败
    CW_FACE_OUTOF_RANGEERR,            // 数据范围错误
    CW_FACE_UNAUTHORIZED,				// 未授权
    CW_FACE_UNINITIALIZED,				// 尚未初始化
    CW_FACE_BUILDIN_MODELABSENCE,		// 没有内置模型
    CW_FACE_DETMODEL_FAILED,					// 加载检测模型失败
    CW_FACE_KEYPTMODEL_FAILED,				    // 加载关键点模型失败
    CW_FACE_QUALITYMODEL_FAILED,				// 加载质量评估模型失败
    CW_FACE_LIVENESSMODEL_FAILED,				// 加载活体检测模型失败
    CW_FACE_DET_FAILED,						    // 检测失败
    CW_FACE_KEYPT_FAILED,						// 提取关键点失败
    CW_FACE_ALIGN_FAILED,						// 对齐人脸失败
    CW_FACE_QUALITY_FAILED,					    // 质量评估失败
};

typedef NS_ENUM(NSInteger,CW_IdCardDETCode){
    CW_IDCARD_OK = 0,
    //身份证检测算法初始化
    CW_IDCARD_INIT_UNINITIALIZED =21000,					// SOMETHING IS NOT INITIALIZED.
    CW_IDCARD_INIT_INITIALIZEDFAILED,				// 初始化失败.
    CW_IDCARD_INIT_CHANNELUNAUTHORIZED,			// HAVEN'T BEEN AUTHORIZED.
    CW_IDCARD_INIT_CHANNELINVALID,					// NO VALID CHANNEL IS AVAILABLE
    CW_IDCARD_INIT_METHODINVALID,                  // METHOD IS INVALID.
    
    //身份证检测错误码
    //    CWIDCARDDET_OK = 0,            //身份证检测成功
    CW_IDCARD_DET_INPUTINVALID =21100,          // 输入参数非法
    CW_IDCARD_DET_INPUTUNRESOLVABLE,     // 输入图像数据解码失败
    CW_IDCARD_DET_FAILED_ERROR,                 // 身份证检测失败
    CW_IDCARD_DET_OUTPUTUNRESOLVABLE,    // 输出图像数据编码失败
    CW_IDCARD_DET_OUTPUTSIZEUNMATCHED,  // 输出数据长度大于预设长度
    CW_IDCARD_DET_UNKNOWNCODE,
    
};

//人脸信息字典key
#define POINTS_KEY @"KEY_Points_KEY"     //关键点

#define RECT_KEY   @"FaceRect_KEY"     //人脸框坐标
#define TRACKID_KEY   @"TrackID_KEY"     //跟踪ID

#define HEADPITCH_KEY   @"HeadPitch_KEY"  //是否抬头、低头
#define HEADYAW_KEY   @"HeadYaw_KEY"     //是否左右转头
#define MOUTHOPEN_KEY   @"MouthOpen_KEY"   //是否张嘴

#define BLINK_KEY       @"Blink_KEY"     //是否眨眼

#define FACESCORE_KEY   @"FaceScore_KEY"   //人脸质量分数
#define BRIGHTNESS_KEY   @"Brightness_KEY"  //亮度

#define CLEARNESS_KEY   @"Clearness_KEY"  //人脸清晰度

#define GLASSNESS_KEY   @"Glassness_KEY"  //是否戴眼镜

#define SKINNESS_KEY   @"Skiness_KEY"     //肤色

#define HEAD_PITCH_DEGREE_KEY @"Head_Pitch_Degree_KEY"   //抬头、低头的角度

#define HEAD_YAW_DEGREE_KEY  @"Head_Yaw_Degree_KEY"      //转头的角度

@interface CloudwalkFaceSDK : NSObject


@property(nonnull,assign)id<cwDelegate>delegate;

/**
 *  单例方法
 *
 *  @return 返回CloudwalkFaceSDK的一个单例
 */

+(instancetype __nonnull)shareInstance;

#pragma mark
#pragma mark-----------cwInit SDK初始化

/**
 *  人脸SDK初始化
 *  @param AuthCodeStr  授权码
 *  @param return       0成功 非0失败 错误码
 */

-(NSInteger)cwInit:(NSString * __nonnull)AuthCodeStr;

/**
 *  @brief 算法参数设置
 *
 *  @param maxFaceNumber 设置最大检测人脸个数
 *  @param minSize       检测的最小人脸框 默认设置为100
 *  @param maxSize       检测最大人脸框   默认设置为400
 *  @param perfmonLevel  效率等级1-5，默认值为2
 *  @return       0成功，非0错误码
 */

-(NSInteger)cwSetParamMaxFaceNumber:(int)maxFaceNumber minFaceSize:(int)minSize maxFaceSize:(int)maxSize   perfmonLevel:(int)perfmonLevel; //建议使用默认参数

/**
 *  @brief 重置跟踪ID
 */
-(void)cwresetParam;

/**
 *  @brief 释放资源
 *
 */

-(void)cwDestroy;


#pragma mark
#pragma mark-----------cwPushFrame push摄像头获取的每一帧图片
/**
 *  push摄像头获取的每一帧图片
 *  @param bufferType   视频流格式 CWFaceBufferBGRA,// BGRA    kCVPixelFormatType_32BGRA
 *  @param sampleBuffer   视频流数据
 *  @return 返回0成功
 */

-(NSInteger)cwPushFrame:(CWFaceBufferType)bufferType  frameBuffer:(__nonnull CMSampleBufferRef)sampleBuffer;

#pragma mark
#pragma mark-----------cwGetBestFaceImage 获取最佳人脸

/**
 *  获取最佳人脸
 *  @return              NSData  返回人脸图片二进制数据 JPG格式
 */

-(NSData * __nullable)cwGetBestFaceImage;

/**
 *  活体检测难易等级设置
 *  @param level     活体检测的难易等级
 *  @return 返回0成功
 */

-(NSInteger)cwSetLivessLevel:(CWLiveDetectlLevel)level;

#pragma mark
#pragma mark-----------cwStartLiveDetect 启动活体检测

/**
 *  启动活体检测
 *  @param detectType     传入活体动作的类型
 */

-(NSInteger)cwStartLivess:(CWLiveDetectType)detectType;

#pragma mark
#pragma mark-----------cwStoptLiveDetect 停止活体检测
/**
 *  停止活体检测
 */
-(void)cwStoptLivess;

/**
 *  @brief 图片人脸检测
 *  @param score 图片质量分数
 *  @param idImage 抠取的人脸图像
 */

typedef void(^cwFaceImageQualityBlock)(double score,UIImage *  __nullable idImage,CGRect  rect);

/**
 *  @brief 图片检测
 *  @param faceImage 人脸图片JPG
 *  @param block  图片质量检测结果返回
 */

-(void)cwFaceImageQuality:(UIImage * __nonnull)faceImage completion:(cwFaceImageQualityBlock __nullable)block;

/**
 *  身份证检测SDK初始化
 *  @param AuthCodeStr  授权码
 *  @param return       0成功 非0失败 错误码
 */

-(NSInteger)cwIDCardInit:(NSString * __nonnull)AuthCodeStr;

/**
 *  @brief 身份证图片检测
 *  @param flag 1表示正面 0表示反面
 *  @param ret 检测错误码返回
 *  @param idImage 抠取的身份证图像
 */
typedef void(^cwIDCardDetectBlock)(UIImage *  __nullable idImage,NSInteger flag,NSInteger ret);

/**
 *  @brief 身份证图片检测
 *  @param idCardImage 身份证图片JPG
 *  @param block  身份证图片检测结果返回
 */

-(void)cwIDCardCheck:(UIImage * __nonnull)idCardImage completion:(cwIDCardDetectBlock __nullable)block;

/**
 *  @brief 获取SDK版本信息
 *
 *  @return 返回算法SDK版本信息
 */
+(NSString * __nullable)cwGetVersion;


@end
