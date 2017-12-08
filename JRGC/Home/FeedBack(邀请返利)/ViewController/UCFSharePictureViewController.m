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

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
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
    self.scrollView.contentSize = CGSizeMake((ScreenWidth - 50) * 4,0);
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
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
   NSArray *pictureArray =  [[NSUserDefaults standardUserDefaults]  objectForKey:@"SharePictureAdversementLink"];
    pictureArray = [[NSArray alloc] initWithObjects:@"picture_1", @"picture_2", @"picture_3", @"picture_4", nil];
    if (self.imagesArray.count > 0) {
        [self.imagesArray removeAllObjects];
    }
    self.pageControl.numberOfPages = pictureArray.count;
    for (int i = 0; i < pictureArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-50) * i, 0, (ScreenWidth-50), (ScreenWidth-50)/2*3.0 )];
//        NSString *thumbUrl = [pictureArray[i] objectForKey:@"thumb"];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrl]];
        UIImage *backImage = [UIImage imageNamed:pictureArray[i]];
        
        //添加二维码图片
        NSString *facCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"gcmCode"];
        UIImage *imageCode = [Common createImageCode:facCode withWith:155];
        imageView.image = [Common composeImageCodeWithBackgroungImage:backImage withCodeImage:imageCode];
        [self.imagesArray addObject:imageView.image];
        
        [self.scrollView addSubview:imageView];
   }
 [self changeScrollLeftOrRightBtnState:self.scrollView.contentOffset.x];
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
    self.pageControl.currentPage = scrollView.contentOffset.x / (ScreenWidth - 50);
}
-(void)changeScrollLeftOrRightBtnState:(float)offsetX
{
    int  pageNumber = offsetX/(ScreenWidth - 50);
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
    shareObject.thumbImage = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    
    [shareObject setShareImage:[self.imagesArray objectAtIndex:self.currentIndex]];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
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
