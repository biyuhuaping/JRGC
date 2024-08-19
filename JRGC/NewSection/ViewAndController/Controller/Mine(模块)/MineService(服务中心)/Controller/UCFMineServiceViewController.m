//
//  UCFMineServiceViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineServiceViewController.h"
#import "UCFMineServiceHeadView.h"
#import "UCFMineServiceCellView.h"
#import "BaseScrollview.h"

#import "FullWebViewController.h"
#import "UCFFAQViewController.h"

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
static NSString * const kAppKey = @"23511571";
static NSString * const kAppSecret = @"10dddec2bf7d3be794eda13b0df0a7d9";

@interface UCFMineServiceViewController ()

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UCFMineServiceHeadView *headView;

@property (nonatomic, strong) UCFMineServiceCellView *aboutUsView; //关于我们

@property (nonatomic, strong) UCFMineServiceCellView *serviceView; //帮助中心

@property (nonatomic, strong) UCFMineServiceCellView *servicePhoneView; //客服电话

@property (nonatomic, strong) UCFMineServiceCellView *weChatView; //微信公众号

@property (nonatomic, strong) UCFMineServiceCellView *officialWebsiteView; //官方网站

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
@end

@implementation UCFMineServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = UIColorWithRGB(0xebebee);
    self.view = rootLayout;
    rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    rootLayout.insetsPaddingFromSafeArea = UIRectEdgeBottom;  //您可以在这里将值改变为UIRectEdge的其他类型然后试试运行的效果。并且在运行时切换横竖屏看看效果
    BaseScrollview *scrollView = [BaseScrollview new];
    scrollView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];;
    scrollView.myHorzMargin = 0;
    scrollView.topPos.equalTo(@0);
    scrollView.bottomPos.equalTo(@0);
    scrollView.myHorzMargin = 0;
    [rootLayout addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.scrollLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.scrollLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    self.scrollLayout.heightSize.lBound(scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
    self.scrollLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    [scrollView addSubview:self.scrollLayout];
    baseTitleLabel.text = @"更多";
    
    
    [self.scrollLayout addSubview:self.headView];
    [self.scrollLayout addSubview:self.aboutUsView];
    [self.scrollLayout addSubview:self.serviceView];
    [self.scrollLayout addSubview:self.servicePhoneView];
    [self.scrollLayout addSubview:self.weChatView];
    [self.scrollLayout addSubview:self.officialWebsiteView];
    
    [self addLeftButton];
}

- (UCFMineServiceHeadView *)headView
{
    if (nil == _headView) {
        _headView = [[UCFMineServiceHeadView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 279)];
        _headView.myTop = 0;
        _headView.myLeft = 0;
        [_headView.praiseBtn addTarget:self action:@selector(gotoAppStore:) forControlEvents:UIControlEventTouchUpInside];
        [_headView.proposalBtn addTarget:self action:@selector(openFeedbackViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

- (UCFMineServiceCellView *)aboutUsView
{
    if (nil == _aboutUsView) {
        _aboutUsView = [[UCFMineServiceCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _aboutUsView.serviceTitleLabel.text = @"关于我们";
        [_aboutUsView.serviceTitleLabel sizeToFit];
        _aboutUsView.tag = 10001;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_aboutUsView addGestureRecognizer:tapGesturRecognizer];
        _aboutUsView.myLeft = 0;
        _aboutUsView.topPos.equalTo(self.headView.bottomPos).offset(15);
    }
    return _aboutUsView;
}

- (UCFMineServiceCellView *)serviceView
{
    if (nil == _serviceView){
        _serviceView = [[UCFMineServiceCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _serviceView.serviceTitleLabel.text = @"帮助中心";
        [_serviceView.serviceTitleLabel sizeToFit];
        _serviceView.tag = 10002;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_serviceView addGestureRecognizer:tapGesturRecognizer];
        _serviceView.myLeft = 0;
        _serviceView.horizontalLineView.myVisibility = MyVisibility_Gone;
        _serviceView.topPos.equalTo(self.aboutUsView.bottomPos);
    }
    return _serviceView;
}

- (UCFMineServiceCellView *)servicePhoneView
{
    if (nil == _servicePhoneView) {
        _servicePhoneView = [[UCFMineServiceCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _servicePhoneView.serviceTitleLabel.text = @"客服电话";
        [_servicePhoneView.serviceTitleLabel sizeToFit];
        _servicePhoneView.serviceContentLabel.text = @"400-0322-988";
        [_servicePhoneView.serviceContentLabel sizeToFit];
        _servicePhoneView.tag = 10003;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_servicePhoneView addGestureRecognizer:tapGesturRecognizer];
        _servicePhoneView.myLeft = 0;
        _servicePhoneView.topPos.equalTo(self.serviceView.bottomPos).offset(10);
    }
    return _servicePhoneView;
}

- (UCFMineServiceCellView *)weChatView
{
    if (nil == _weChatView) {
        _weChatView = [[UCFMineServiceCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _weChatView.serviceTitleLabel.text = @"微信公众号";
        [_weChatView.serviceTitleLabel sizeToFit];
        _weChatView.serviceContentLabel.text = @"工场服务中心";
        [_weChatView.serviceContentLabel sizeToFit];
        _weChatView.tag = 10004;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_weChatView addGestureRecognizer:tapGesturRecognizer];
        _weChatView.myLeft = 0;
        _weChatView.topPos.equalTo(self.servicePhoneView.bottomPos);
    }
    return _weChatView;
}

- (UCFMineServiceCellView *)officialWebsiteView
{
    if (nil == _officialWebsiteView){
        _officialWebsiteView = [[UCFMineServiceCellView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _officialWebsiteView.serviceTitleLabel.text = @"帮助中心";
        [_officialWebsiteView.serviceTitleLabel sizeToFit];
        _officialWebsiteView.serviceContentLabel.text = @"www.9888keji.com";
        [_officialWebsiteView.serviceContentLabel sizeToFit];
        _officialWebsiteView.tag = 10005;
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(layoutClick:)];
        [_officialWebsiteView addGestureRecognizer:tapGesturRecognizer];
        _officialWebsiteView.myLeft = 0;
        _officialWebsiteView.horizontalLineView.myVisibility = MyVisibility_Gone;
        _officialWebsiteView.topPos.equalTo(self.weChatView.bottomPos);
    }
    return _officialWebsiteView;
}

-(void)layoutClick:(UIGestureRecognizer *)sender
{
    switch (sender.view.tag) {
        case 10001:
        {
            FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:ABOUTUSURL title:@"关于我们"];
            webView.sourceVc = @"UCFMoreVC";
            webView.baseTitleType = @"specialUser";
            [self.navigationController pushViewController:webView animated:YES];
        }
            break;
        case 10002:
        {
            UCFFAQViewController *faq = [[UCFFAQViewController alloc] init];
            faq.title = @"帮助中心";
            [self.rt_navigationController pushViewController:faq animated:YES];
        }
            break;
        case 10003:
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 10004:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:@"工场服务中心"];
            [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
        }
            break;
        case 10005:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:@"www.9888keji.com"];
            [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
        }
            break;
        default:
            break;
    }
}
/** 打开用户反馈页面 */
- (void)openFeedbackViewController {
    //  初始化方式,或者参考下方的`- (YWFeedbackKit *)feedbackKit`方法。
    //    self.feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    NSString *userId = SingleUserInfo.loginData.userInfo.userId;
    userId = userId?userId:@"";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"userid":userId,
                                 @"客户端版本":currentVersion};
    
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            //            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            //            [[TWMessageBarManager sharedInstance] showMessageWithTitle:title description:nil type:TWMessageBarMessageTypeError];
        }
    }];
}
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    }
    return _feedbackKit;
}

- (void)gotoAppStore:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDImageCache sharedImageCache] clearDisk];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:APP_RATING_URL];
            [[UIApplication sharedApplication] openURL:url];
        });
    });
}

@end
