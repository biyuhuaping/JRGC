//
//  UCFSharePictureViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/29.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFSharePictureViewController.h"
#import "UCFShareAnimationController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "SDWebImageManager.h"
#import "HWWeakTimer.h"

@interface UCFSharePictureViewController ()<UIScrollViewDelegate, UIViewControllerTransitioningDelegate>
- (IBAction)ClicksharePictureBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scorllViewRight;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, assign) float   scrollViewWidth;
@end

@implementation UCFSharePictureViewController

- (NSMutableArray *)imagesArray
{
    if (nil == _imagesArray) {
        _imagesArray = [[NSMutableArray alloc] init];
    }
    return _imagesArray;
}

+ (instancetype)showSharePictureViewController
{
    UCFSharePictureViewController *showSharePicture = [[UCFSharePictureViewController alloc] init];
    showSharePicture.transitioningDelegate = showSharePicture;
    showSharePicture.modalPresentationStyle = UIModalPresentationCustom;
    
    return showSharePicture;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *cmsPictureArray =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"SharePictureAdversementLink"];
  
    if(ScreenWidth == 320 && ScreenHeight == 480)
    {
        self.scrollViewLeft.constant = 40;
        self.scorllViewRight.constant = 40;
        _scrollViewWidth = ScreenWidth  - 80;
    }else{
        self.scrollViewLeft.constant = 25;
        self.scorllViewRight.constant = 25;
        _scrollViewWidth = ScreenWidth - 50;
    }
    self.scrollView.contentSize = CGSizeMake(_scrollViewWidth * cmsPictureArray.count,0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.currentIndex = 0;
   /*
    {
    desc = "";
    "down_time" = "";
    dumps = "";
    "publish_time" = "";
    thumb = "https://fore.9888.cn/cms/uploadfile/2017/1207/20171207022019449.jpg";
    title = "\U56fe\U724704";
    url = "www.9888.cn";
    }
    
    */
    
    lineViewAA.hidden = YES;
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];

   NSArray *pictureArray = [[NSArray alloc] initWithObjects:@"picture_1", @"picture_2", @"picture_3", @"picture_4", nil];
    if (self.imagesArray.count > 0)
    {
        [self.imagesArray removeAllObjects];
    }
    self.pageControl.numberOfPages = cmsPictureArray.count;
    //生成二维码图片
    NSString *facCode = [[NSUserDefaults standardUserDefaults] objectForKey:GCMCODE];
    UIImage *imageCode = [Common createImageCode:facCode withWith:155];
    for (int i = 0; i < cmsPictureArray.count; i++)
    {
        float  imageViewHight = _scrollViewWidth/2*3.0;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollViewWidth * i, 0,_scrollViewWidth, imageViewHight )];
        NSString *thumbUrl = [cmsPictureArray[i] objectForKey:@"thumb"];
        UIImage *cmsImage = [self getCMSImage:thumbUrl];
        if (cmsImage == nil)
        {
            UIImage *backImage = [UIImage imageNamed:pictureArray[i]];
            imageView.image = [Common composeImageCodeWithBackgroungImage:backImage withCodeImage:imageCode];
            [self.imagesArray addObject:imageView.image];
        }
        else
        {
             UIImage *cmsCodeImage = [Common composeImageCodeWithBackgroungImage:cmsImage withCodeImage:imageCode];
             imageView.image = cmsCodeImage;
             [self.imagesArray addObject:imageView.image];
        }
        [self.scrollView addSubview:imageView];
   }
   [self changeScrollLeftOrRightBtnState:self.scrollView.contentOffset.x];
}
-(UIImage *)getCMSImage:(NSString*)url
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"%@", url];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        if (!recervedData) {
            return  nil;
        }
        UIImage* cmsImage = [UIImage imageWithData: recervedData];
        return cmsImage;

//    });
}

- (void)showView
{
    self.view.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.5);
    self.view.frame = [UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
}
//+(UIImage *)createImageCode:(NSString *)gcmStr withWith:(CGFloat)width
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self changeScrollLeftOrRightBtnState: scrollView.contentOffset.x];
    self.pageControl.currentPage = scrollView.contentOffset.x / _scrollViewWidth;
}
-(void)changeScrollLeftOrRightBtnState:(float)offsetX
{
    int  pageNumber = offsetX/_scrollViewWidth;
    self.currentIndex = pageNumber;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//分享网络图片
- (void)shareImageURLToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    
    [shareObject setShareImage:[self.imagesArray objectAtIndex:self.currentIndex]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    [[UserInfoSingle sharedManager] saveIsShare:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 @"2",@"taskType",
                                                 [NSString stringWithFormat:@"%zd",platformType],@"platformType",
                                                 nil] ];
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //            [self alertWithError:error];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ClicksharePictureBtn:(UIButton *)sender

{
    switch (sender.tag) {
        case 101:
        {
            if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]){
                
                [self shareImageURLToPlatformType: UMSocialPlatformType_WechatSession];
            }
            else{
                  [MBProgressHUD displayHudError:@"先安装微信才可分享哦"];
                
            }
        }
    
            break;
        case 102:
        {
            if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]){
                
                [self shareImageURLToPlatformType: UMSocialPlatformType_WechatTimeLine];
            }
            else{
                [MBProgressHUD displayHudError:@"先安装微信才可分享哦"];
            }
        }
            
            break;
        case 103:
        {
            if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ])
            {
                [self shareImageURLToPlatformType: UMSocialPlatformType_QQ];
            }
            else{
                [MBProgressHUD displayHudError:@"先安装QQ才可分享哦"];
            }
        }
            break;
            
        default:
            break;
    }
     [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark -- UIViewControllerTransitioningDelegate --

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[UCFShareAnimationController alloc] init];
//    switch (self.animationType) {
//
//        case KTAlertControllerAnimationTypeCenterShow:
//            return [[UCFShareAnimationController alloc] init];
//            break;
//
//        case KTAlertControllerAnimationTypeUpDown:
//            return [[UCFShareAnimationController alloc] init];
//            break;
//
//        default:
//            break;
//    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[UCFShareAnimationController alloc] init];
//    switch (self.animationType) {
//        case KTAlertControllerAnimationTypeCenterShow:
//            return [[KTCenterAnimationController alloc] init];
//            break;
//
//        case KTAlertControllerAnimationTypeUpDown:
//            return [[KTUpDownAnimationController alloc] init];
//            break;
//
//        default:
//            break;
//    }
}

@end
