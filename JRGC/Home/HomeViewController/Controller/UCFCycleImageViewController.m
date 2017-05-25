//
//  UCFCycleImageViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCycleImageViewController.h"
#import "UCFUserPresenter.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "UCFCycleModel.h"
#import "UCFWebViewJavascriptBridgeBanner.h"

@interface UCFCycleImageViewController () <UCFUserPresenterCyceleImageCallBack, SDCycleScrollViewDelegate>
@property (strong, nonatomic) UCFUserPresenter *presenter;
@property (weak, nonatomic) SDCycleScrollView *cycleImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomSegView;
@end

@implementation UCFCycleImageViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
        cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self.view addSubview:cycleScrollView];
    self.cycleImageView = cycleScrollView;
    
    self.bottomSegView.backgroundColor = UIColorWithRGB(0xebebee);
    
    [self getNormalBannerData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect cycleFrame = self.view.bounds;
    cycleFrame.size.height -= 10;
    self.cycleImageView.frame = cycleFrame;
}

#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFUserPresenter *)presenter {
    return [[UCFCycleImageViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFUserPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.cycleImageViewDelegate = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
    }
    return self;
}

#pragma mark - 计算轮播图模块的高度
+ (CGFloat)viewHeight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width * 0.5 + 10;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    id model = [cycleScrollView.imagesGroup objectAtIndex:index];
    if ([model isKindOfClass:[UCFCycleModel class]]) {
        UCFCycleModel *modell = model;
        UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        webView.baseTitleType = @"lunbotuhtml";
        webView.url = modell.url;
        webView.navTitle = modell.title;
        webView.dicForShare = modell;
        [self.parentViewController.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:CMS_BANNER_UNLOGIN]];
        [request setHTTPMethod:@"GET"];
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (EnvironmentConfiguration == 2 || (app.isSubmitAppStoreTestTime && [[[NSUserDefaults standardUserDefaults] valueForKey:UUID] isEqualToString:@"108027"])) {
            [request setValue:@"1" forHTTPHeaderField:@"jrgc-umark"];
        }
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!recervedData) {
                return ;
            }
            NSDictionary *modelDic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *temp = [NSMutableArray new];
            for (NSDictionary *dict in modelDic[@"banner"]) {
                UCFCycleModel *model = [UCFCycleModel getCycleModelByDataDict:dict];
                [temp addObject:model];
            }
            weakSelf.cycleImageView.imagesGroup = temp;
            [weakSelf.cycleImageView refreshImage];
        });
    });
}

@end
