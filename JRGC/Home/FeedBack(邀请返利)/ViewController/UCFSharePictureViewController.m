//
//  UCFSharePictureViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/29.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFSharePictureViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>
#import "SDWebImageManager.h"
@interface UCFSharePictureViewController ()<UIScrollViewDelegate>
- (IBAction)ClicksharePictureBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)clickLeftBtn:(UIButton *)sender;
- (IBAction)clickRightBtn:(id)sender;

- (IBAction)closeView:(id)sender;

@end

@implementation UCFSharePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(270 * 4,0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
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
    for (int i = 0; i < pictureArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(270 * i, 0, 270, 405 )];
        NSString *thumbUrl = [pictureArray[i] objectForKey:@"thumb"];
        [imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrl]];
        
        //添加二维码图片
        
        
        [self.scrollView addSubview:imageView];
   }
 [self changeScrollLeftOrRightBtnState:self.scrollView.contentOffset.x];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self changeScrollLeftOrRightBtnState: scrollView.contentOffset.x];
}
-(void)changeScrollLeftOrRightBtnState:(float)offsetX
{
    int  pageNumber = offsetX/270;
    if (pageNumber == 0) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
    }
    else if(pageNumber == 3)
    {
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = YES;
    }else
    {
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
    }
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
    
    [shareObject setShareImage:@"https://mobile.umeng.com/images/pic/home/social/img-1.png"];
    
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
- (IBAction)clickLeftBtn:(UIButton *)sender
{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - (ScreenWidth - 80 * 2), 0) ;
    if (self.scrollView.contentOffset.x <= 0)
    {
      self.scrollView.contentOffset = CGPointZero;
    }
    [self  changeScrollLeftOrRightBtnState:self.scrollView.contentOffset.x];
}

- (IBAction)clickRightBtn:(id)sender
{
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + 270, 0) ;
    if (self.scrollView.contentOffset.x/270 >=3)
    {
        self.scrollView.contentOffset = CGPointMake(270 * 3, 0) ;
    }
    [self  changeScrollLeftOrRightBtnState:self.scrollView.contentOffset.x];
}

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
