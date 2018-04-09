//
//  CWCamera.m
//
//  Created by dengwuping on 15/4/1.
//  Copyright (c) 2015年 dengwuping. All rights reserved.
//

#import "CWCamera.h"
#import <CoreMedia/CoreMedia.h>
#import <CoreMedia/CMMetadata.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CWCamera () <AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession					*_captureSession;//相机session
    
    AVCaptureDevice                     *_videoDevice;//相机设备
    
    
    AVCaptureConnection					*_videoConnection; //视频
    
    AVCaptureVideoPreviewLayer          *_Prelayer; //视频流预览
    CWCameraOrientation                 _camraOrientaion;
    
    dispatch_queue_t                   _serialQueue;        //push线程
    
    AVCaptureVideoDataOutput    *  videoOut;
}

@property (readwrite, getter=isRecording) BOOL	recording;//是否录制

@end

#define CW_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

@implementation CWCamera

#pragma mark
#pragma mark------------ SharedInstance
+(instancetype)SharedInstance{
    static CWCamera * instance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t,^{
        instance = [[CWCamera alloc]initSingle];
    });
    return instance;
}

//只是把原来在init方法中的代码，全都搬到initSingle
- (id)initSingle{
    self = [super init];
    if(self){
        
        self.referenceOrientation = AVCaptureVideoOrientationPortrait;
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (id)init{
    return [CWCamera SharedInstance];
}

#pragma mark
#pragma mark----------- setupCaptureSessionCameraType //初始化相机

- (BOOL)setupCaptureSessionCameraType:(AVCaptureDevicePosition)cameraType{
    /*
     * Create capture session
     */
    _captureSession = [[AVCaptureSession alloc] init];
    
    //设置视频质量
    if([self.session canSetSessionPreset:AVCaptureSessionPreset640x480])
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    
    _videoDevice = [self videoDeviceWithPosition:cameraType];
    
    AVCaptureDeviceInput *videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];
    
    if ([_captureSession canAddInput:videoIn])
        [_captureSession addInput:videoIn];
    
    //添加vidiooutPut
    videoOut = [[AVCaptureVideoDataOutput alloc] init];
    
    [videoOut setAlwaysDiscardsLateVideoFrames:YES];
    
    //设置视频流格式为BGRA格式
    [videoOut setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey : [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    //kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
    
    dispatch_queue_t queue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    
    [videoOut setSampleBufferDelegate:self queue:queue];
    
    if ([_captureSession canAddOutput:videoOut])
        [_captureSession addOutput:videoOut];
    
    if ([_videoDevice lockForConfiguration:NULL] )
    {
        [_videoDevice setActiveVideoMinFrameDuration:CMTimeMake(10,300)];
        [_videoDevice setActiveVideoMaxFrameDuration:CMTimeMake(10,300)];
        [_videoDevice unlockForConfiguration];
    }
    
    /*
     * Create video connection
     */
    
    _videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    
    //前置摄像头镜像
    if(cameraType == AVCaptureDevicePositionFront){
        //是否镜像
        _videoConnection.videoMirrored = YES;
    }else
        _videoConnection.videoMirrored = NO;
    
    if (_videoConnection.supportsVideoOrientation ) {
        switch (_camraOrientaion) {
            case CameraOrientationPortrait:
                _videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
            case CameraOrientationPortraitUpsideDown:
                _videoConnection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            case CameraOrientationLeft:
                _videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case CameraOrientationRight:
                _videoConnection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            default:
                break;
        }
    }
    
    return YES;
}

#pragma mark
#pragma mark----------- videoDeviceWithPosition //获取相机设备 前后摄像头
- (AVCaptureDevice *)videoDeviceWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
        if (device.position == position)
            return device;
    return nil;
}

#pragma mark
#pragma mark----------- audioDevice //获取音频设备

- (AVCaptureDevice *)audioDevice{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if (devices.count > 0)
        return [devices firstObject];
    return nil;
}

#pragma mark
#pragma mark----------- StartCamera //打开相机获取摄像头视频流
/**
 *  @brief 打开相机
 *
 *  @param cameratype     相机类型、前置或后置
 *  @param orintation     屏幕方向
 *  @param rect           预览展示大小
 *  @param superView      展示预览layer的父View
 *  @param cameraDelegate 视频流回调代理
 *
 *  @return YES成功
 */
-(AVCaptureVideoPreviewLayer *)cwStartCamera:(CWCameraType)cameratype CameraOrientation:(CWCameraOrientation)orintation delegate:(id<CaptureManagerDelegate>)cameraDelegate{
    
    //判断是否支持前置摄像头
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
    {
        _camraOrientaion = orintation;
        
        _delegate = cameraDelegate;
        
        if (cameratype == CameraTypeFront) {
            [self setupCaptureSessionCameraType:AVCaptureDevicePositionFront];
        }else{
            [self setupCaptureSessionCameraType:AVCaptureDevicePositionBack];
        }
        //设置显示PreViewlayer
        _Prelayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        
        _Prelayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [_Prelayer setMasksToBounds:YES];
        
        [self rotateLayer];
        
        _ispush = YES;
        
        if (!_captureSession.isRunning)
            [_captureSession startRunning];
        
        return _Prelayer;
    }
    else
        return nil;
}

/**
 *  @brief 旋转preViewLayer
 *
 */

-(void)rotateLayer{
    
    switch (_camraOrientaion) {
        case CameraOrientationPortrait:
            break;
        case CameraOrientationLeft:
            _Prelayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case CameraOrientationRight:
            _Prelayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case CameraOrientationPortraitUpsideDown:
            _Prelayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark----------- captureOutput Delegate //获取音视频流
/**
 *  @brief 视频、音频流回调
 *
 *  @param captureOutput
 *  @param sampleBuffer  视频流数据
 *  @param connection
 */

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    dispatch_sync(_serialQueue, ^{
        if (connection == _videoConnection && _ispush){
            if (self.delegate && [self.delegate respondsToSelector:@selector(captureOutputSampleBuffer:bufferType:)]) {
                [self.delegate captureOutputSampleBuffer:sampleBuffer bufferType:1];
            }
        }
    });
}

#pragma mark
#pragma mark----------- cwStopCamera //关闭摄像头

-(void)cwStopCamera{
    
    self.delegate = nil;
    
    _ispush = NO; //停止push
    
    if (_captureSession)
        dispatch_async(dispatch_get_main_queue(), ^{
            [_captureSession stopRunning];
        });
}

- (AVCaptureSession *)session{
    return _captureSession;
}


@end
