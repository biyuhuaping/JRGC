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
#import "UCFHomeIconCollectionCell.h"
#import "UCFHomeIconPresenter.h"

@interface UCFCycleImageViewController () <HomeIconListViewPresenterCallBack, SDCycleScrollViewDelegate, UCFNoticeViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UCFHomeListPresenter *presenter;
@property (weak, nonatomic) SDCycleScrollView *cycleImageView;
@property (weak, nonatomic) IBOutlet UIView *homeIconBackView;
@property (weak, nonatomic) IBOutlet UIView *noticeBackView;
@property (weak, nonatomic) UCFNoticeView *noticeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeBackviewH;
@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;

@end

@implementation UCFCycleImageViewController

static NSString *cellId = @"iconCell";

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
    
    UCFNoticeView *noticeView = (UCFNoticeView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFNoticeView" owner:self options:nil] lastObject];
    noticeView.delegate = self;
    [self.noticeBackView addSubview:noticeView];
    self.noticeView = noticeView;
    
    
    
    
    [self.iconCollectionView registerNib:[UINib nibWithNibName:@"UCFHomeIconCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellId];
    
    [self getNormalBannerData];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
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
    return (CGSize){ScreenWidth / 5, 80};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
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
        [self.iconCollectionView reloadData];
        //        [self.tableView.footer resetNoMoreData];
    } else if (self.presenter.allHomeIcons.count == 0) {
        //        show error view
    }
}

#pragma mark - 计算轮播图模块的高度
+ (CGFloat)viewHeight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width * 0.5 + 80;
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
        if (EnvironmentConfiguration == 2 || (app.isSubmitAppStoreTestTime)) {
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
