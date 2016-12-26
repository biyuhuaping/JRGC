//
//  CWCamera.h
//  CWCamera
//
//  Created by dengwuping on 15/4/1.
//  Copyright (c) 2015年 dengwuping. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CaptureManagerDelegate <NSObject>

/**
 *  @brief 视频流回调
 *
 *  @param sampleBuffer 视频流
 *  @param bufferType   视频格式  1 kCVPixelFormatType_32BGRA  2 kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 */

-(void)captureOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer  bufferType:(NSInteger)bufferType;

@end

typedef NS_ENUM(NSInteger,CWCameraType)  //相机类型
{
    CameraTypeFront=1, // 前置摄像头
    CameraTypeBack, //后置摄像头
    
};

typedef NS_ENUM(NSInteger,CWCameraOrientation)  //摄像头采集视频的方向
{
    CameraOrientationPortrait=1, // 竖屏
    CameraOrientationPortraitUpsideDown,
    CameraOrientationLeft, //横屏向左
    CameraOrientationRight,//横屏向右
    
};

@interface CWCamera : NSObject

@property (assign) id <CaptureManagerDelegate>	delegate;

@property (readonly) AVCaptureSession				*session;

@property AVCaptureVideoOrientation					referenceOrientation; //摄像头方向

@property(nonatomic,assign)BOOL  ispush;//开始push视频流

/**
 *  @brief 单例方法
 *
 *  @return 返回类的一个实例
 */
+(instancetype)SharedInstance;

#pragma mark
#pragma mark-----------cwStartCamera 打开摄像头

/**
 *  @brief 打开摄像头
 *
 *  @param cameratype 相机类型 前置、后置
 *  @param orintation 屏幕方向
 *  @return 返回YES成功
 */

-(AVCaptureVideoPreviewLayer *)cwStartCamera:(CWCameraType)cameratype  CameraOrientation:(CWCameraOrientation)orintation   delegate:(id<CaptureManagerDelegate>)cameraDelegate;

#pragma mark
#pragma mark-----------cwStopCamera 关闭摄像头
/**
 *  关闭摄像头  在打开摄像头之后退出该界面需要关闭摄像头
 */

-(void)cwStopCamera;



@end


