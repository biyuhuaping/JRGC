//
//  UCFCycleImageViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCycleImageViewController.h"
#import "UCFHomeListPresenter.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "UCFCycleModel.h"
#import "UCFWebViewJavascriptBridgeBanner.h"
#import "UCFNoticeView.h"
#import "UCFNoticeModel.h"
#import "UCFHomeIconCollectionCell.h"
#import "UCFHomeIconPresenter.h"
#import "UCFNoticeViewController.h"
#import "UCFZiZHIViewController.h"
@interface UCFCycleImageViewController () <HomeIconListViewPresenterCallBack, SDCycleScrollViewDelegate, UCFNoticeViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate>
@property (strong, nonatomic) UCFHomeListPresenter *presenter;
@property (weak, nonatomic) SDCycleScrollView *cycleImageView;
@property (weak, nonatomic) IBOutlet UIView *homeIconBackView;
@property (weak, nonatomic) IBOutlet UIView *noticeBackView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeBackViewHeight;
@property (weak, nonatomic) IBOutlet UIView *downView;

@end

@implementation UCFCycleImageViewController

static NSString *cellId = @"iconCell";

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
    self.downView.backgroundColor = UIColorWithRGB(0xebebee);
    self.iconBackViewHeight.constant = 0;
    
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
        cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self.view addSubview:cycleScrollView];
    self.cycleImageView = cycleScrollView;
    
    UCFNoticeView *noticeView = (UCFNoticeView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFNoticeView" owner:self options:nil] lastObject];
    noticeView.delegate = self;
    [self.noticeBackView addSubview:noticeView];
    self.noticeView = noticeView;
    
    [self.iconCollectionView registerNib:[UINib nibWithNibName:@"UCFHomeIconCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    
    [self getNormalBannerData];
}

- (void)noticeView:(UCFNoticeView *)noticeView didClickedNotice:(UCFNoticeModel *)notice
{
    if ([notice.noticeUrl isEqualToString:@"xinxipilou"]) {
        UCFZiZHIViewController *vc = [[UCFZiZHIViewController alloc] initWithNibName:@"UCFZiZHIViewController" bundle:nil];
        UCFBaseViewController *baseVc = (UCFBaseViewController *)self.delegate;
        [baseVc.navigationController pushViewController:vc animated:YES];

    } else {
        UCFNoticeViewController *noticeWeb = [[UCFNoticeViewController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
        noticeWeb.url      = notice.noticeUrl;//请求地址;
        noticeWeb.navTitle = @"公告";
        UCFBaseViewController *baseVc = (UCFBaseViewController *)self.delegate;
        if (notice.noticeUrl.length > 0) {
            [baseVc.navigationController pushViewController:noticeWeb animated:YES];
        }
    }

}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [collectionView.collectionViewLayout invalidateLayout];
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.presenter.allHomeIcons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UCFHomeIconCollectionCell *cell = [self.iconCollectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.iconPresenter = [self.presenter.allHomeIcons objectAtIndex:indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(ScreenWidth-20) / 5, 80};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    NSUInteger count = self.presenter.allHomeIcons.count;
    CGFloat w = (ScreenWidth-20)/5.0;
    if (count < 5 && count > 1) {
        CGFloat space = ((ScreenWidth - 20) - w * count)/(count - 1);
        return space;
    }
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleImageVC:didClickedIconWithIconPresenter:)]) {
        [self.delegate cycleImageVC:self didClickedIconWithIconPresenter:[self.presenter.allHomeIcons objectAtIndex:indexPath.row]];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect cycleFrame = self.view.bounds;
    cycleFrame.size.height = ScreenWidth * 0.5;
    self.cycleImageView.frame = cycleFrame;
    self.noticeView.frame = self.noticeBackView.bounds;
}

#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFHomeListPresenter *)presenter {
    return [[UCFCycleImageViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFHomeListPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.iconDelegate = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
    }
    return self;
}

- (void)homeIconListViewPresenter:(UCFHomeListPresenter *)presenter didRefreshDataWithResult:(id)result error:(NSError *)error
{
    if (!error) {
        NSArray *homeIcons = [result objectSafeArrayForKey:@"productMap"];
        if (homeIcons.count > 0) {
//            weakSelf.cycleImageVC.view.frame = CGRectMake(0, 0, ScreenWidth, userInfoViewHeight + 80);
            self.iconBackViewHeight.constant = 80;
        }
        else {
//            weakSelf.cycleImageVC.view.frame = CGRectMake(0, 0, ScreenWidth, userInfoViewHeight);
            self.iconBackViewHeight.constant = 0;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.iconCollectionView reloadData];
        });
        
        //        [self.tableView.footer resetNoMoreData];
    } else if (self.presenter.allHomeIcons.count == 0) {
        //        show error view
    }
}

#pragma mark - 计算轮播图模块的高度
+ (CGFloat)viewHeight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width * 0.5 + 8;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    id model = [cycleScrollView.imagesGroup objectAtIndex:index];
    if ([model isKindOfClass:[UCFCycleModel class]]) {
        UCFCycleModel *modell = model;
        UCFWebViewJavascriptBridgeBanner *webView = [[UCFWebViewJavascriptBridgeBanner alloc]initWithNibName:@"UCFWebViewJavascriptBridgeBanner" bundle:nil];
        webView.rootVc = self.parentViewController;
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
    if ([UserInfoSingle sharedManager].isSubmitTime) {
        UCFCycleModel *model = [[UCFCycleModel alloc] init];
        model.thumb = @"https://fore.9888.cn/cms/uploadfile/2017/0524/20170524051010287.jpg";
        model.title = @"大事记";
        model.url = @"https://m.9888.cn/static/wap/invest/index.html#/features/big-deal";
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObject:model];
        self.cycleImageView.imagesGroup = temp;
        [self.cycleImageView refreshImage];
        
        
        UCFNoticeModel *noticeModel = [[UCFNoticeModel alloc] init];
        noticeModel.noticeUrl = @"xinxipilou";
        noticeModel.siteNotice =@"金融工场信息披露";
    
        self.noticeView.noticeModel = noticeModel;
        self.noticeView.noticeLabell.text = noticeModel.siteNotice;
        if (noticeModel.siteNotice.length > 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowNotice"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate refreshNoticeWithShow:YES];
            });
        }
    } else {
        [[NetworkModule sharedNetworkModule] newPostReq:nil tag:kSXTagGetBannerAndGift owner:self signature:NO Type:SelectAccoutDefault];
    }
}

- (void)beginPost:(kSXTag)tag
{
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == kSXTagGetBannerAndGift) {
        NSDictionary *modelDic = dic[@"data"];
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *dict in modelDic[@"banner"]) {
            UCFCycleModel *model = [UCFCycleModel getCycleModelByDataDict:dict];
            [temp addObject:model];
        }
        self.cycleImageView.imagesGroup = temp;
        [self.cycleImageView refreshImage];
        
        UCFNoticeModel *model = [[UCFNoticeModel alloc] init];
        model.noticeUrl = [Common isNullValue:modelDic[@"siteNoticeMap"][@"noticeUrl"]] ? @"" : modelDic[@"siteNoticeMap"][@"noticeUrl"];
        model.siteNotice = [Common isNullValue:modelDic[@"siteNoticeMap"][@"siteNotice"]] ? @"" : modelDic[@"siteNoticeMap"][@"siteNotice"];

        
        self.noticeView.noticeModel = model;
        self.noticeView.noticeLabell.text = model.siteNotice;
        if (model.siteNotice.length > 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowNotice"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate refreshNoticeWithShow:YES];
            });

        } else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowNotice"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.delegate refreshNoticeWithShow:NO];
        }
        
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}

- (void)setNoticeStr:(NSString *)noticeStr
{
    _noticeStr = noticeStr;
    _noticeView.noticeLabell.text = noticeStr;
}

#pragma mark - 刷新公告
- (void)refreshNotice
{
    BOOL isShowNotice = [[NSUserDefaults standardUserDefaults] boolForKey:@"isShowNotice"];
    if (isShowNotice) {
        self.noticeBackViewHeight.constant = 45;
        for (UIView *view in self.noticeView.subviews) {
            view.hidden = NO;
        }
    }
    else {
        self.noticeBackViewHeight.constant = 0;
        for (UIView *view in self.noticeView.subviews) {
            view.hidden = YES;
        }
    }
}

- (void)homeIconListPresenter:(UCFHomeListPresenter *)presenter didReturnPrdClaimsDealBidWithResult:(id)result error:(NSError *)error
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.parentViewController;
    [MBProgressHUD hideAllHUDsForView:baseVC.view animated:YES];
    NSString *rstCode = [result objectForKey:@"status"];
    NSString *rsttext = [result objectForKey:@"statusdes"];
    if ([rstCode integerValue] == 21 || [rstCode integerValue] == 22){
        [self checkUserCanInvestIsDetail:NO];
    } else {
        if ([rstCode integerValue] == 15) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } else if ([rstCode integerValue] == 19) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag =7000;
            [alert show];
        }else if ([rstCode integerValue] == 30) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
            alert.tag = 9000;
            [alert show];
        }else if ([rstCode integerValue] == 40) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服",nil];
            alert.tag = 9001;
            [alert show];
        } else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
}

- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail
{
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.parentViewController;
    NSString *tipStr1 = baseVC.accoutType == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = baseVC.accoutType == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;
    
    NSInteger openStatus = baseVC.accoutType == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].openStatus :[UserInfoSingle sharedManager].enjoyOpenStatus;
    
    switch (openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:tipStr1];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:tipStr2];
                return NO;
            }
        }
            break;
        default:
            return YES;
            break;
    }
}

- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    UCFBaseViewController *baseVC = (UCFBaseViewController *)self.parentViewController;
    alert.tag = baseVC.accoutType == SelectAccoutTypeP2P ?  8000 :8010 ;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.delegate respondsToSelector:@selector(proInvestAlert:didClickedWithTag:withIndex:)]) {
        [self.delegate proInvestAlert:alertView didClickedWithTag:alertView.tag withIndex:buttonIndex];
    }
}
@end
