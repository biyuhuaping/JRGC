//
//  CWFaceViewController.m
//  CloudwalkFaceSDK
//
//  Created by DengWuPing on 16/8/29.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import "CWFaceViewController.h"
#import "CWCamera.h"
#import "CWFinishedView.h"
#import "CWAudioPlayer.h"
#import "CWURLSession.h"
#import "CWLoadingView.h"

@interface CWFaceViewController ()<CaptureManagerDelegate,cwDelegate,CWAudioPlayerDelegate>{
    
    NSArray             *     actionArray;      //需要做的活体动作
    CWFinishedView      *     finishedView;     //检测结果显示页面
    BOOL                       isAudioPlay;        //当前是否正在播放
    NSString            *       audioFileName;      //当前播放的声音文件名
    AVCaptureVideoPreviewLayer  *  preLayer;
    NSData             *        bestFaceData; // 获取的最佳人脸图片
    CGRect                faceBoxRect;  //人脸框Rect
    BOOL                   isDetectFace;  //开始检测人脸是否在框内
    BOOL                   isFaceInBox;  //人脸是否在框内

    CWLoadingView         *  loadingView; //人脸比对的等待View
    BOOL                   isSamePerson;  //是否是同一个人
    double                 faceScore;  //人脸比对分数
    NSInteger              errorCode;  //返回的错误码
    NSInteger              sdkErrorCode;//SDK初始化返回码
}

@property(nonatomic,weak)IBOutlet NSLayoutConstraint   * guideTraillingConstraint;  //引导页距离左边的约束
@property(nonatomic,weak)IBOutlet NSLayoutConstraint   * guideLeadingConstraint; //引导页距离右边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startTopConstraint; //开始检顶部约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startHeightConstraint; //开始按钮高度
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint *textTopConstraint; //顶部提示文字“请正对手机” 距离顶部的约束
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint * bottomViewHeightConstraint; //底部动画的约束
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint * startButtonLeadingConstraint; //开始按钮的约束

@property (weak, nonatomic) IBOutlet  NSLayoutConstraint * startButtonTraillingConstraint; //开始按钮的约束
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint * actionNameBottom; //动作名称提示的约束
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint * imageWidthConstraint; //动作名称提示的约束
@property (weak, nonatomic) IBOutlet  NSLayoutConstraint * imageHeightConstraint; //动作名称提示的约束

@end

//屏幕宽
#define CWLIVESSSCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
//屏幕高
#define CWLIVESSSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
//RGB颜色
#define CWFR_ColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation CWFaceViewController

#pragma mark
#pragma mark-----------  viewWillAppear  //隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController != nil) {
        self.navigationController.navigationBarHidden = YES;
    }
}

-(id)init{
    if (self = [super init]) {
        [self setDefaultPara];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultPara];
    }
    return self;
}

#pragma mark
#pragma mark-------------------- initWithNibName 初始化 设置默认值

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setDefaultPara];
    }
    return self;
}

/**
 *  @brief 设置默认参数
 */
-(void)setDefaultPara{
    _thresholdScore = 0.7f;
    _isShowResultView = YES;
    _isFaceCompare = NO;
    _ipaddress = @"http://120.25.161.56:7000";
    _app_idStr = @"user";
    _app_secretStr = @"12345";
    _bestFaceTime = 1;
}

/**
 *  @brief 设置活体检测参数
 *
 *  @param authCode     SDK授权码
 *  @param isShowResult 是否显示结果页面
 *  @param isCompare    是否在活体完成之后进行人脸比对
 */
-(void)setLivessParam:(NSString *)authCode  isShowResultView:(BOOL)isShowResult isFaceCompare:(BOOL)isCompare{
    self.authCodeString = authCode;
    self.isShowResultView = isShowResult;
    self.isFaceCompare  = isCompare;
}

/**
 *  @brief 设置人脸比对参数
 *
 *  @param faceImage 比对基础照片
 *  @param ipaddress 云之眼服务器ip地址
 *  @param appID     云之眼app_id （私有云时默认为“user”）
 *  @param appSecret 云之眼服务器app_secret （私有云时默认为“12345”）
 *  @param score     人脸比对阈值 推荐阈值为 0.7
 */
-(void)setFaceCompare:(UIImage *)faceImage ipadress:(NSString *)ipaddress app_id:(NSString *)appID app_Secret:(NSString *)appSecret thresholdScore:(double)score{
    self.compareImage = faceImage;
    self.ipaddress = ipaddress;
    self.app_idStr = appID;
    self.app_secretStr = appSecret;
    self.thresholdScore = score;
}

#pragma mark
#pragma mark-----------  viewDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
    //适配4s 和ipad
    [self adaputUI];
    
    //SDK初始化
    errorCode = sdkErrorCode =  [[CloudwalkFaceSDK shareInstance] cwInit:self.authCodeString];
    
    //设置delegate
    [CloudwalkFaceSDK shareInstance].delegate = self;
    
    isDetectFace = NO;
    
    //设置提示lable根据宽度适应字体的大小
    self.actionNameLabel.adjustsFontSizeToFitWidth
    = YES;
}

#pragma mark
#pragma mark----------- adaputUI   //4s、6p适配
/**
 *  @brief 界面适配
 */
-(void)adaputUI{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.startTopConstraint.constant = 100;
        self.textTopConstraint.constant = 120;
        self.startButtonLeadingConstraint.constant = 100;
        self.startButtonTraillingConstraint.constant = 100;
        self.bottomViewHeightConstraint.constant = 260;
        self.actionNameBottom.constant = 30;
        self.imageWidthConstraint.constant *= 1.3;
        self.imageHeightConstraint.constant *= 1.3;
        self.startHeightConstraint.constant = 60;
        faceBoxRect = CGRectMake(80, 64, CWLIVESSSCREEN_WIDTH -160, CWLIVESSSCREEN_HEIGHT - self.bottomViewHeightConstraint.constant - 64);
    }
    else{
        if (CWLIVESSSCREEN_HEIGHT < 568) {
            self.startTopConstraint.constant = 20;
            self.textTopConstraint.constant = 20;
            self.bottomViewHeightConstraint.constant = 170;
        }
        else if(CWLIVESSSCREEN_HEIGHT >= 667){
            self.startHeightConstraint.constant = 50;
            self.startTopConstraint.constant = 80;
            self.textTopConstraint.constant = 80;
        }
    }
    if (CWLIVESSSCREEN_WIDTH <=320) {
        //中间的人脸框
        faceBoxRect = CGRectMake(50, 64, CWLIVESSSCREEN_WIDTH -100, CWLIVESSSCREEN_HEIGHT - self.bottomViewHeightConstraint.constant - 64);
    }else{
        //中间的人脸框
        faceBoxRect = CGRectMake(60, 64, CWLIVESSSCREEN_WIDTH -120, CWLIVESSSCREEN_HEIGHT - self.bottomViewHeightConstraint.constant - 64);
    }
}

#pragma mark
#pragma mark----------- startLivess   //视频流代理方法
/**
 *  @brief 开始活体检测
 *
 *  @param sender 开始进入活体检测界面
 */
-(IBAction)startLivess:(id)sender{
    
    if (sdkErrorCode == CW_FACE_DET_OK) {
        
        isSamePerson = NO;
        
        faceScore = 0.f;
        
        isFaceInBox = NO;
        
        isDetectFace  = YES;
        //打开摄像头
        [self startCamera];
        //隐藏引导界面 显示活体检测界面
        [UIView animateWithDuration:0.3f animations:^{
            self.guideLeadingConstraint.constant = - CWLIVESSSCREEN_WIDTH;
            self.guideTraillingConstraint.constant = CWLIVESSSCREEN_WIDTH;
            [self.view layoutIfNeeded];
        } completion:^(BOOL isfinished){
            self.guideView.hidden = YES;
            [self playMainAudio];
        }];
        self.tipsImageView.hidden = NO;
        self.actionNameLabel.text = @"请按图示将人脸放入取景框中!";
    }else{
        if (self.isShowResultView) {
            [self showFailedView:YES failedMessage:@"初始化失败,授权码无效!"];
        }else{
            [self backToHomeViewController:nil];
        }
    }
}

-(void)playMainAudio{
    audioFileName = @"main";
    [self playAudioFileName];
}

#pragma mark
#pragma mark----------- startCamera   //打开摄像头
/**
 *  @brief 打开摄像头
 */
-(void)startCamera{
    self.cameraView.hidden = NO;
    preLayer = [[CWCamera SharedInstance] cwStartCamera:CameraTypeFront CameraOrientation:CameraOrientationPortrait delegate:self];
    preLayer.frame = self.cameraView.bounds;
    [self.cameraView.layer insertSublayer:preLayer atIndex:0];
}
#pragma mark
#pragma mark----------- captureOutputSampleBuffer   //视频流代理方法
/**
 *  @brief 视频流代理方法
 *
 *  @param sampleBuffer 视频流buffer
 *  @param bufferType   视频格式 1-BGRA kCVPixelFormatType_32BGRA  2-YUV420  kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 */

-(void)captureOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer bufferType:(NSInteger)bufferType{
    
    [[CloudwalkFaceSDK shareInstance] cwPushFrame:bufferType frameBuffer:sampleBuffer];
}

#pragma mark
#pragma mark-----------  playAudioFileName // 播放提示音
/**
 *  @brief 播放语音
 *
 *  @param audioFileName 语音文件名
 */
-(void)playAudioFileName{
    //如果当前正在播放语音  先停止播放
    if(isAudioPlay){
        [[CWAudioPlayer sharedInstance] stopPlay];
        isAudioPlay = NO;
    }
    if (isAudioPlay == NO ) {
        NSString * path = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"CWResource.bundle/%@.mp3",audioFileName]];
        [[CWAudioPlayer sharedInstance] startPlayAudio:path AndDelegae:self];
        isAudioPlay = YES;
    }
}
#pragma mark
#pragma mark-----------  audioPlayFinished // 语音播放完成的代理方法
/**
 *  @brief 语音播放完成代理方法
 */
-(void)audioPlayFinished{
    if ([audioFileName isEqualToString:@"main"]) {
        //提示语音播放完成之后 检测人脸是否在取景框内
        [self performSelector:@selector(cwGetBestFace) withObject:nil afterDelay:_bestFaceTime];
    }
}

//延迟几秒获取最佳人脸图片
-(void)cwGetBestFace{
    //只能调用一次最佳人脸 ，调用之后就会把之前的缓存给清理
    NSData * data =  [[CloudwalkFaceSDK shareInstance] cwGetBestFaceImage];
    //判断人脸是否在框内
    if (isFaceInBox) {
        if (data != nil) {
            //活体检测成功 获取最佳人脸图片
            bestFaceData = [[NSData alloc]initWithData:data];
            //进行人脸比对
            if (self.isFaceCompare) {
                [self faceCompare];
            }else{
                errorCode = 0;
                //活体检测成功停止活体动作检测
                if (self.isShowResultView) {
                    //播放检测成功的语音 显示成功界面
                    audioFileName =  @"detectSucess";
                    [self showFailedView:NO failedMessage:@"检测成功,感谢您的配合!"];
                    [self playAudioFileName];
                    
                }else
                    [self backToHomeViewController:nil];
            }
        }else{
            [self liveDetecteFailed:@"检测失败，请按照提示做出相应的动作!" audioFileName:@"detectFailed"];
        }
    }else{
        [self liveDetecteFailed:@"检测失败，请按照提示做出相应的动作!" audioFileName:@"detectFailed"];
    }
}
#pragma mark
#pragma mark----------- cwFaceInfoCallBack   //人脸检测代理方法
/**
 *  @brief 人脸检测代理方法
 *
 *  @param personsArry 返回人脸数组  人脸框坐标、关键点坐标 字典
 */
-(void)cwFaceInfoCallBack:(NSArray *)personsArry{
    
    if (personsArry.count >0) {
        
        NSDictionary  * dict = [personsArry objectAtIndex:0];
        
        CGRect  rect = CGRectFromString([dict objectForKey:@"FaceRect_KEY"]);
        // 人脸的坐标是根据 480 *640的图算的 所以需要转换
        float xscale = CWLIVESSSCREEN_WIDTH / 480;
        
        float yscale = (CWLIVESSSCREEN_HEIGHT -64) / 640;
        
        CGRect  newRect =   CGRectMake(rect.origin.x * xscale, rect.origin.y *yscale, rect.size.width * xscale, rect.size.height * yscale);
        //判断人脸坐标是否在取景框内
        if (isDetectFace && CGRectContainsRect(faceBoxRect,newRect)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                isDetectFace = NO;
                isFaceInBox = YES;
            });
        }
    }
}

#pragma mark
#pragma mark----------- cwLivessInfoCallBack   //活体检测的代理方法
/**
 *  @brief 活体检测代理方法
 *
 *  @param contextType 活体检测的代码
 *  @param imageData       当前动作通过时保存的图片（JPG格式的）
 */
-(void)cwLivessInfoCallBack:(CW_LivenessCode)contextType liveImage:(NSData *)imageData{
}

#pragma mark
#pragma mark----------- faceCompare //人脸比对
/**
 *  @brief 人脸比对
 */
-(void)faceCompare{
    
    if (self.compareImage == nil) {
        errorCode = CW_FACE_EMPTY_FRAME;
        
        [self hidLoadingView];
        //比对失败
        [self compareFailed:@"请选择正确的人脸图片!"isFailed:YES];
    }else{
        
        [self showLoadingView];
        
        NSData  * imageAData = UIImageJPEGRepresentation(self.compareImage, .8f);
        
        NSString   * imageA = [imageAData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        //最佳人脸图片
        NSString   * imageB = [bestFaceData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        [[CWURLSession sharedClient] cwFaceCompare:self.ipaddress apiKey:self.app_idStr secretKey:self.app_secretStr imageA:imageA imageB:imageB block:^(NSInteger result, double score, NSString * _Nullable info) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCode = result;
                
                [self hidLoadingView];
                
                if(result == 0){
                    faceScore = score;
                    if( score >= self.thresholdScore){
                        isSamePerson = YES;
                        [self compareFailed:@"人脸验证成功,感谢您的配合!" isFailed:NO];
                    }
                    else{
                        isSamePerson = NO;
                        [self compareFailed:@"抱歉,人脸验证失败!" isFailed:YES];
                    }
                }else{
                    //比对失败
                    [self compareFailed:@"抱歉,人脸验证失败!" isFailed:YES];
                }
            });
        }];
    }
}

#pragma mark
#pragma mark------------------- compareFailed
/**
 *  @brief 人脸比对失败
 *
 *  @param messageStr 提示语
 *  @param isfailed   是否失败
 */
-(void)compareFailed:(NSString *)messageStr isFailed:(BOOL) isfailed{
    
    if (isfailed) {
        isSamePerson = NO;
        faceScore= 0.f;
    }
    if (self.isShowResultView) {
        if(isfailed){
            audioFileName = @"verifyFailed";
        }else{
            audioFileName = @"verifySucess";
        }
        [self playAudioFileName];
        
        [self showFailedView:isfailed failedMessage:messageStr];
    }else{
        [self backToHomeViewController:nil];
    }
}

#pragma mark
#pragma mark showLoadingView  人脸比对的等待View

-(void)showLoadingView{
    if (loadingView == nil) {
        loadingView = [[CWLoadingView alloc]init];
        loadingView.bgView.backgroundColor = [UIColor colorWithRed:34.0/255.f green:42.0/255.0 blue:64.0/255.0 alpha:1.0];
        [self.view addSubview:loadingView];
    }
    loadingView.hidden = NO;
    [self.view bringSubviewToFront:loadingView];
    [loadingView showWithTitle:@"人脸认证中...."];
}

-(void)hidLoadingView{
    if (loadingView) {
        [loadingView hide];
    }
}

#pragma mark
#pragma mark-----------  liveDetectFailed //当前动作检测失败
/**
 *  @brief 检测失败
 */
-(void)liveDetecteFailed:(NSString *)errorMsg audioFileName:(NSString *)audioName{
    //是否显示结果页面
    if (self.isShowResultView) {
        //活体检测失败 显示失败界面
        [self showFailedView:YES failedMessage:errorMsg];
        audioFileName = audioName;
        [self playAudioFileName];
    }else
        [self backToHomeViewController: nil];
    
}

#pragma mark
#pragma mark-----------  showFailedView 、、显示是否检测成功的View
/**
 *  @brief 显示成功或失败的结果页面 (可替换成第三方自定义的结果页面)
 *
 *  @param isFailed  YES 失败页面、 NO 成功页面
 *  @param failedStr 成功、失败的提示语
 */

-(void)showFailedView:(BOOL)isFailed failedMessage:(NSString *)failedStr{
    
    //检测成功、失败界面显示时 需要先停止检测
    [self stopDetect];
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"CWFinishedView" owner:self options:nil];

    UIColor  * animationColor;
    //显示成功或失败的结果页面
    if (isFailed) {
        finishedView = [array objectAtIndex:0];
        //失败界面 返回按钮
        [finishedView.backButton addTarget:self action:@selector(backToHomeViewController:) forControlEvents:UIControlEventTouchUpInside];
        //重新检测按钮
        [finishedView.redoButton addTarget:self action:@selector(detectRedo) forControlEvents:UIControlEventTouchUpInside];
        animationColor = CWFR_ColorFromRGB(216, 40, 42);
        
    }else{
        finishedView  = [array lastObject];
        //确定按钮
        //[finishedView.suerButton addTarget:self action:@selector(backToHomeViewController:) forControlEvents:UIControlEventTouchUpInside];
        
        animationColor = CWFR_ColorFromRGB(50, 195, 99);
    }
    
    //finishedView.failedLabel.text = failedStr;
    
    [self.view addSubview:finishedView];
    
    [self.view bringSubviewToFront:finishedView];
    //设置坐标从右边出来
    finishedView.frame = CGRectMake(CWLIVESSSCREEN_WIDTH, 0,CWLIVESSSCREEN_WIDTH, CWLIVESSSCREEN_HEIGHT);
    //添加显示的动画
    [UIView animateWithDuration:0.2 animations:^{
        finishedView.frame = CGRectMake(0, 0, CWLIVESSSCREEN_WIDTH,CWLIVESSSCREEN_HEIGHT);
    } completion:^(BOOL flag){
        //[finishedView showAnimation:animationColor];
    }];
}

#pragma mark
#pragma mark-----------   stopDetect 停止检测
//停止检测
-(void)stopDetect{
    [preLayer removeFromSuperlayer];
    //关闭摄像头
    [[CWCamera SharedInstance] cwStopCamera];
    //停止活体检测
    [[CloudwalkFaceSDK shareInstance] cwStoptLivess];
}

#pragma mark
#pragma mark-----------   detectRedo 重新检测
/**
 *  @brief 重新检测
 */
-(void)detectRedo{
    //添加显示的动画
    [UIView animateWithDuration:0.3 animations:^{
        finishedView.frame = CGRectMake(CWLIVESSSCREEN_WIDTH, 0, CWLIVESSSCREEN_WIDTH,CWLIVESSSCREEN_HEIGHT);
    } completion:^(BOOL flag){
        
    }];
    
    self.guideView.hidden = NO;
    
    self.cameraView.hidden = YES;
    
    self.guideLeadingConstraint.constant = 0;
    
    self.guideTraillingConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark
#pragma mark----------- backToHomeViewController   //返回上一层界面
/**
 *  @brief 返回上一层界面
 *
 *  @param sender 返回按钮
 */
-(IBAction)backToHomeViewController:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //停止检测  关闭摄像头
        [self stopDetect];
        
        [[CloudwalkFaceSDK shareInstance] cwDestroy];
        
        //停止播放语音
        [[CWAudioPlayer sharedInstance] stopPlay];
        [CWAudioPlayer sharedInstance].delegate = nil;
        
        //执行代理方法
        if(self.delegate  && [self.delegate respondsToSelector:@selector(cwFaceIsTheSamePerson:faceScore:errorCode:BestFace:)]){
            [self.delegate cwFaceIsTheSamePerson:isSamePerson faceScore:faceScore errorCode:errorCode BestFace:bestFaceData];
        }
        
        if(self.navigationController != nil){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    });
}

#pragma mark
#pragma mark----------- preferredStatusBarStyle   //修改状态栏颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
