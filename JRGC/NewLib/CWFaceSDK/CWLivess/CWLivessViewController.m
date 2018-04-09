//
//  LiveDetectViewController.m
//  CloudwalkFaceSDKDemo
//
//  Created by DengWuPing on 16/5/12.
//  Copyright © 2016年 DengWuPing. All rights reserved.
//

#import "CWLivessViewController.h"
#import "CWCamera.h"
#import "CWProgressView.h"
#import "CWFinishedView.h"
#import "CWAudioPlayer.h"
#import "CWAnimationView.h"
#import "CWURLSession.h"
#import "CWLoadingView.h"
#import "NSData+Base64.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface CWLivessViewController ()<CaptureManagerDelegate,cwDelegate,CWAudioPlayerDelegate>{
    
    NSArray             *     allDataArray;     //总的动作
    NSArray             *     actionArray;      //需要做的活体动作
    CWFinishedView      *     finishedView;     //检测结果显示页面
    CWProgressView      *      progressView;    // 进度条View
    BOOL                       isAudioPlay;        //当前是否正在播放
    NSDictionary        *      imageNameDictionary;//图片字典
    NSInteger                   stepIndex;          //执行检测的索引
    CWAnimationView     *       animationView;     //底部动画显示
    NSString            *       audioFileName;      //当前播放的声音文件名
    AVCaptureVideoPreviewLayer  *  preLayer;
    
    NSData             *        bestFaceData; // 获取的最佳人脸图片
    BOOL                         isALive;  //活体检测是否成功
    CGRect                faceBoxRect;  //人脸框Rect
    BOOL                   isDetectFace;  //开始检测人脸是否在框内
    
    CWLoadingView         *  loadingView; //人脸比对的等待View
    
    BOOL                   isSamePerson;  //是否是同一个人
    
    double                 faceScore;  //人脸比对分数
    
    NSInteger              errorCode;  //返回的错误码
    NSInteger              sdkErrorCode;//SDK初始化返回码
    
}

@property (weak, nonatomic) IBOutlet UILabel *navTitileText;   //导航条文字

@property(nonatomic,strong)NSTimer    *   timer;       //倒计时定时器
@property(nonatomic,weak)IBOutlet  UIView  * cameraView; //视频预览View
@property(nonatomic,weak)IBOutlet  UIView  * guideView; //进入活体检测的引导VIew

@property(nonatomic,weak)IBOutlet  UIView  * bottomView; //进入活体检测的引导VIew

@property(nonatomic,weak)IBOutlet  UIImageView  * tipsImageView; //提示将人脸放入取景框中

@property(nonatomic,weak)IBOutlet  UILabel  * actionNameLabel;//活体动作名称显示label

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

#define  LivessOverTime 8  //活体检测的超时时间
                           //屏幕宽
#define CWLIVESSSCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
//屏幕高
#define CWLIVESSSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
//RGB颜色
#define CWFR_ColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

//这里是会报警告的代码
@implementation CWLivessViewController

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
    _liveLevel = CWLiveDetectStandard;
    _livessNumber = 3;
}

/**
 *  @brief 设置活体检测参数
 *
 *  @param authCode     SDK授权码
 *  @param activeNumber 活体动作个数
 *  @param level        活体难易等级
 *  @param isShowResult 是否显示结果页面
 *  @param isCompare    是否在活体完成之后进行人脸比对
 */
-(void)setLivessParam:(NSString *)authCode livessNumber:(NSInteger)activeNumber livessLevel:(CWLiveDetectlLevel)level  isShowResultView:(BOOL)isShowResult isFaceCompare:(BOOL)isCompare{
    self.authCodeString = authCode;
    self.livessNumber = activeNumber;
    self.liveLevel = level;
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
    self.fd_interactivePopDisabled = YES;
    [super viewDidLoad];
    //适配4s 和ipad
    [self adaputUI];
    //所有活体动作  可以去掉不想要的动作
    allDataArray = @[@"向左转头",@"向右转头",@"张嘴",@"眨眼",@"抬头",@"点头"];
    //相应的活体动作图片
    imageNameDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"openMouth",@"张嘴",@"turnLeft",@"向左转头",@"trunRight",@"向右转头",@"rise",@"抬头",@"down",@"点头",@"blink",@"眨眼", nil];
    //添加动画View
    animationView = [[CWAnimationView alloc]initWithFrame:CGRectMake(0, 0, CWLIVESSSCREEN_WIDTH, 180)];
    [self.bottomView addSubview:animationView];
    
    //SDK初始化
    errorCode = sdkErrorCode =  [[CloudwalkFaceSDK shareInstance] cwInit:self.authCodeString];
    
    //设置delegate
    [CloudwalkFaceSDK shareInstance].delegate = self;
    
    //设置活体难易等级
    [[CloudwalkFaceSDK shareInstance] cwSetLivessLevel:self.liveLevel];
    
    isDetectFace = NO;
    
    //设置提示lable根据宽度适应字体的大小
    self.actionNameLabel.adjustsFontSizeToFitWidth
    = YES;
    
    if(self.flagway==1){
           [self startLivess:nil];
 //        [self performSelector:@selector(startLivess:) withObject:nil afterDelay:1];
    }
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
    
    
    if(self.flagway==0)
    {
        self.navTitileText.text = @"开启刷脸登录";
    }else{
        self.navTitileText.text = @"刷脸登录";

    }
}

#pragma mark
#pragma mark----------- randomActions   //随机生成活体动作
/**
 *  @brief 随机活体动作
 */
-(void)randomActions{
    //确保不随机重复的动作
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    int random = 0;
    random = arc4random() % 2;
    [randomSet addObject:[allDataArray objectAtIndex:random]];
    //随机XX个不重复的动作 可以修改活体动作个数
    while ([randomSet count] < self.livessNumber) {
        //从0-活体动作数组中随机 XX 个动作
        int r = arc4random() % [allDataArray count];
        [randomSet addObject:[allDataArray objectAtIndex:r]];
    }
    actionArray = [NSMutableArray arrayWithArray:[randomSet allObjects]];
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
        
        isALive = NO;
        
        isSamePerson = NO;
        
        faceScore = 0.f;
        
        stepIndex = 0;
        
        //随机活体动作
        [self randomActions];
        dispatch_async(dispatch_get_main_queue(), ^{
        //打开摄像头
        [self startCamera];
        });
        if(self.flagway==0){
            self.navTitileText.text = @"人脸识别";
        //隐藏引导界面 显示活体检测界面
        [UIView animateWithDuration:0.3f animations:^{
            self.guideLeadingConstraint.constant = - CWLIVESSSCREEN_WIDTH;
            self.guideTraillingConstraint.constant = CWLIVESSSCREEN_WIDTH;
            [self.view layoutIfNeeded];
        } completion:^(BOOL isfinished){
            self.guideView.hidden = YES;
            audioFileName = @"main";
            [self playAudioFileName];
        }];
            
        }else{
            self.guideView.hidden = YES;
            audioFileName = @"main";
            [self playAudioFileName];
        }
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

#pragma mark
#pragma mark----------- showAnimationViewAndText   //显示每一步动作的动画提示和文字提示
/**
 *  @brief 示每一步动作的动画提示和文字提示
 */
-(void)showAnimationViewAndText{
    NSString  * stepStr = [actionArray objectAtIndex:stepIndex];
    if ([stepStr isEqualToString:@"向左转头"]) {
        self.actionNameLabel.text = [NSString stringWithFormat:@"向左缓慢转头"];
    }else if([stepStr isEqualToString:@"向右转头"]){
        self.actionNameLabel.text = [NSString stringWithFormat:@"向右缓慢转头"];
    }
    else if([stepStr isEqualToString:@"抬头"]||[stepStr isEqualToString:@"点头"]){
        self.actionNameLabel.text = [NSString stringWithFormat:@"缓慢%@",stepStr];
    }else{
        self.actionNameLabel.text = stepStr;
    }
    //显示底部的动画
    [self showAnimation:stepStr];
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
#pragma mark----------- livessAction   //每一步活体动作
/**
 *  @brief 每一个活体动作
 */
-(void)livessAction{
    //总的动作个数大于0
    if (actionArray != nil && actionArray.count >0) {
        NSString  * stepStr = [actionArray objectAtIndex:stepIndex];
        if ([stepStr isEqualToString:@"向左转头"]) {
            audioFileName = @"left";
            //左转检测
            [[CloudwalkFaceSDK shareInstance] cwStartLivess:CWLiveHeadTurnLeft];
        }
        else if ([stepStr isEqualToString:@"向右转头"]) {
            audioFileName = @"right";
            //右转检测
            [[CloudwalkFaceSDK shareInstance] cwStartLivess:CWLiveHeadTurnRight];
        }
        else if ([stepStr isEqualToString:@"抬头"]) {
            audioFileName = @"top";
            //抬头检测
            [[CloudwalkFaceSDK shareInstance] cwStartLivess:CWLiveHeadRise];
        }else if ([stepStr isEqualToString:@"点头"]) {
            audioFileName = @"down";
            //点头检测
            [[CloudwalkFaceSDK shareInstance] cwStartLivess:CWLiveHeadDown];
        }
        else if ([stepStr isEqualToString:@"张嘴"]) {
            audioFileName = @"openMouth";
            //张嘴检测
            [[CloudwalkFaceSDK shareInstance] cwStartLivess:CWLiveOpenMouth];
        }
        else if ([stepStr isEqualToString:@"眨眼"]) {
            audioFileName = @"eye";
            //眨眼检测
            [[CloudwalkFaceSDK shareInstance] cwStartLivess:CWLiveBlink];
        }
        //播放音频文件
        [self playAudioFileName];
        //显示倒计时
        [self ShowCountProgressView:LivessOverTime];
        //设置每个动作的倒计时
        [self setTimerCountDown];
    }
}

#pragma mark
#pragma mark----------- showAnimation
/**
 *  @brief 根据当前动作显示提示动画
 *
 *  @param actionStr 当前动作名称
 */
-(void)showAnimation:(NSString *)actionStr{
    NSString    * imageName = [imageNameDictionary objectForKey:actionStr];  //动画提示
    UIImage * imageA = [UIImage imageNamed:[NSString stringWithFormat:@"CWResource.bundle/front.tiff"]];
    UIImage * imageB = [UIImage imageNamed:[NSString stringWithFormat:@"CWResource.bundle/%@.tiff",imageName]];
    animationView.hidden = NO;
    //动画图片切换
    [animationView showAnimation:imageA imageB:imageB];
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
        isDetectFace  = YES;
    }
    else if ([audioFileName isEqualToString:@"next2"]){
        [self livessAction];
    }
}
#pragma mark
#pragma mark----------- addCountDownProgressView //添加每一个动作的倒计时
/**
 *  @brief 显示倒计时View
 *
 *  @param time 倒计时
 */
-(void)ShowCountProgressView:(NSInteger)time{
    if (progressView == nil) {
        progressView = [[CWProgressView alloc]initWithFrame:CGRectMake(CWLIVESSSCREEN_WIDTH-70, 10, 60, 60)];
        [_bottomView addSubview:progressView];
        
        progressView.outerBackgroundColor = CWFR_ColorFromRGB(51, 58, 66);
    }
    progressView.hidden = NO;
    
    progressView.progress = 1.0;
    
    progressView.showText = 1;
    
    progressView.progressText = time;
    
    progressView.roundedHead = 1;
    
    progressView.showShadow = 0;
}

#pragma mark
#pragma mark----------- setTimerCountDown   //设置倒计时
/**
 *  @brief 设置倒计时
 */

-(void)setTimerCountDown{
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setProgressViewPorgress) userInfo:nil repeats:YES];
}
#pragma mark
#pragma mark----------- stopTimer   //清空定时器
/**
 *  @brief 清空定时器
 */
-(void)stopTimer{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma mark
#pragma mark----------- setProgressViewPorgress   //倒计时显示
/**
 *  倒计时显示
 */
-(void)setProgressViewPorgress{
    
    CGFloat  progress = 1.0 / LivessOverTime;
    if (progressView.progressText >= 1) {
        progressView.progressText -= 1;
        progressView.progress -= progress;
    }
    if (progressView.progress == 0) {
        //返回检测超时
        errorCode = CW_FACE_LIVENESS_OVERTIME;
        [self stopTimer];
        [self liveDetecteFailed:@"检测超时,请在规定的时间内做出相应的动作!" audioFileName:@"overtime"];
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
                [self livessStart];
            });
        }
    }
}

/**
 *  @brief 检测到人脸在框内开始活体动作检测
 */

-(void)livessStart{
    isDetectFace  = NO;
    self.tipsImageView.hidden = YES;
    //开始活体检测
    [self livessAction];
    //显示动画和文字提示
    [self showAnimationViewAndText];
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
    
    //检测到没人或者是多个人 或者是攻击则提示当前动作检测失败
    switch (contextType) {
        case CW_FACE_LIVENESS_NOPEPOLE:
        case CW_FACE_LIVENESS_MULTIPERSONE:
        case CW_FACE_LIVENESS_PEPOLECHANGED:
        case CW_FACE_LIVENESS_WRONGACTION:
        case CW_FACE_LIVENESS_ATTACK_SHAKE:
        case CW_FACE_LIVENESS_ATTACK_MOUTH:
        case CW_FACE_LIVENESS_ATTACK_RIGHTEYE:
        case CW_FACE_LIVENESS_ATTACK_PICTURE:
        case CW_FACE_LIVENESS_ATTACK_UNSTABLE:
        case CW_FACE_LIVENESS_ATTACK_PAD:
        case CW_FACE_LIVENESS_ATTACK_VIDEO:{
            errorCode = contextType;
            [self liveDetecteFailed:@"检测失败，未按提示做出相应的动作!" audioFileName:@"wrongAction"];
        }
            break;
        case CW_FACE_LIVENESS_OPENMOUTH:
        case CW_FACE_LIVENESS_BLINK:
        case CW_FACE_LIVENESS_HEADPITCH:
        case CW_FACE_LIVENESS_HEADDOWN:
        case CW_FACE_LIVENESS_HEADLEFT:
        case CW_FACE_LIVENESS_HEADRIGHT:
            [self liveDetectSucess];
            break;
        default:
            break;
    }
}

#pragma mark
#pragma mark-----------  当前动作检测成功
/**
 *  @brief 检测成功
 */
-(void)liveDetectSucess{
    //当前检测成功停止倒计时
    [self stopTimer];
    //上一个动作检测成功，播放语音  进行下一个活体动作检测
    if (stepIndex < actionArray.count-1) {
        stepIndex++;
        audioFileName =  @"next2";
        [self playAudioFileName];
        //显示下一个活体动作的动画
        [self showAnimationViewAndText];
    }else{
        
        isALive = YES;
        //活体检测成功 获取最佳人脸图片
        //只能调用一次最佳人脸 ，调用之后就会把之前的缓存给清理
        NSData * data =  [[CloudwalkFaceSDK shareInstance] cwGetBestFaceImage];
        
        if (data != nil) {
            //活体检测成功 获取最佳人脸图片
            bestFaceData = [[NSData alloc]initWithData:data];
        }
        
        [[CloudwalkFaceSDK shareInstance] cwStoptLivess];
   
        dispatch_async(dispatch_get_main_queue(), ^{ //使用GCD防止线程阻塞引起菊花延迟显示
            [MBProgressHUD showHUDAddedTo:nil animated:YES];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self stopDetect];
            //-----捕捉到人脸信息上传服务器
                if(self.flagway==1){//***登录
                   [self getDataRequsetLandIn];
                }else if (self.flagway==0){//***人脸录入
                   [self getDataRequset];
                }
        });
//        //进行人脸比对
//        if (self.isFaceCompare) {
//            [self faceCompare];
//        }else{
//            errorCode = 0;
//            //活体检测成功停止活体动作检测
//            if (self.isShowResultView) {
//                //播放检测成功的语音 显示成功界面
//                audioFileName =  @"detectSucess";
//                [self showFailedView:NO failedMessage:@"检测成功,感谢您的配合!"];
//                [self playAudioFileName];
//                
//            }else{
//                [self backToHomeViewController:nil];
//            }
//        }
    }
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
    isALive = NO;
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

- (void)showFailedView:(BOOL)isFailed failedMessage:(NSString *)failedStr{
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
    animationView.hidden = YES;
    progressView.hidden = YES;
    //停止倒计时
    [self stopTimer];
    
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
        [self startLivess:nil];
    }];
    
//    self.guideView.hidden = NO;
//    
//    self.cameraView.hidden = YES;
//    
//    self.guideLeadingConstraint.constant = 0;
//    self.guideTraillingConstraint.constant = 0;
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
        
        [animationView removeFromSuperview];
        //停止播放语音
        [[CWAudioPlayer sharedInstance] stopPlay];
        [CWAudioPlayer sharedInstance].delegate = nil;
        
//        //执行代理方法
//        if(self.delegate  && [self.delegate respondsToSelector:@selector(cwIntergrationLivess:isTheSamePerson:faceScore:errorCode:BestFaceImage:)]){
//            
//            [self.delegate cwIntergrationLivess:isALive  isTheSamePerson:isSamePerson faceScore:faceScore errorCode:errorCode BestFaceImage:bestFaceData];
//        }
        
        if(self.navigationController != nil){
            if(self.flagway==0){
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:NO];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
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

#pragma mark  网络请求-人脸录入
- (void)getDataRequset{
    dispatch_async(dispatch_get_main_queue(), ^{ //使用GCD防止线程阻塞引起菊花延迟显示
        //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    NSData *imageData= [bestFaceData copy];
    NSString *imagestr=[(NSString*)[imageData base64EncodedString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strParameters = [NSString stringWithFormat:@"loginName=%@&photoStream=%@", [[NSUserDefaults standardUserDefaults] objectForKey:LOGINNAME],imagestr];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFaceInfoCollection owner:self Type:SelectAccoutDefault];
}
#pragma mark 网络请求-人脸登陆
- (void)getDataRequsetLandIn{
//    NSData *imageData= [bestFaceData copy];
    NSString *imagestr=[(NSString*)[bestFaceData base64EncodedString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet whitespaceCharacterSet]];

    NSString *strParameters = [NSString stringWithFormat:@"loginName=%@&photoStream=%@&remotIp=%@", self.ForwardPageuserName,imagestr,@""];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFaceInfoLanding owner:self Type:SelectAccoutDefault];
}
//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag{
    dispatch_async(dispatch_get_main_queue(), ^{ //使用GCD防止线程阻塞引起菊花延迟显示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    NSString *data = (NSString *)result;
    NSDictionary *dic = [data objectFromJSONString];
    
    if (tag.intValue == kSXTagFaceInfoCollection) {//***人脸录入
        
        NSString *rstcode = [dic objectSafeForKey:@"status"];
        NSString *rsttext = [dic objectSafeForKey:@"statusdes"];
        if([rstcode intValue] == 1){
            //***成功页面
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已成功开启刷脸登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            alert.tag =1;
//            [alert show];
//            [self showFailedView:NO failedMessage:rsttext];
            [self showAlertViewforPassEX];
            audioFileName = @"verifySucess";
            //延迟一秒 刷新个人信息中刷脸登录的状态
            [self performSelector:@selector(refreshFaceSwichStatus) withObject:nil afterDelay:1];
        }else{
            //            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [self showFailedView:YES failedMessage:rsttext];
            audioFileName = @"verifyFailed";
        }
        
    }
    if (tag.intValue == kSXTagFaceInfoLanding) {//***人脸登录
        
        NSString *rstcode = [dic objectSafeForKey:@"ret"];
        NSString *rsttext = [dic objectSafeForKey:@"message"];
        if([rstcode intValue] == 1){
            audioFileName = @"verifySucess";
//            [self backToHomeViewController:nil];
            [self.delegate transformCloudWalkReconise:result];//***向登录主页面传递数据
        }else if([rstcode intValue]==4){//***人脸识别开关已关闭，请通过其他方式登录后开启方可使用！
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
            //            [self recongiseFaild];
            audioFileName = @"verifyFailed";
        }else{
            [self showFailedView:YES failedMessage:rsttext];

            audioFileName = @"verifyFailed";
        }
    }
    [self playAudioFileName];
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag{
    dispatch_async(dispatch_get_main_queue(), ^{ //使用GCD防止线程阻塞引起菊花延迟显示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    if (tag.intValue == kSXTagFaceInfoCollection||tag.intValue ==kSXTagFaceInfoLanding) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
        [self showFailedView:YES failedMessage:@"请求失败，请重试"];

    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark 通知-刷新安全中心按钮状态
-(void)refreshFaceSwichStatus{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
}
#pragma mark  alertdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1)
    {
        [self backToHomeViewController:nil];
    }
}
#pragma mark  人脸录入成功alert
-(void)showAlertViewforPassEX{
    //检测成功、失败界面显示时 需要先停止检测
    [self stopDetect];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您已成功开启刷脸登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag =1;
        [alert show];


}
@end
