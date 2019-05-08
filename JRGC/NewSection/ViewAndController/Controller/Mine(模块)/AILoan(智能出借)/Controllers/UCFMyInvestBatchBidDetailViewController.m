//
//  UCFMyInvestBatchBidDetailViewController.m
//  JRGC
//
//  Created by zrc on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMyInvestBatchBidDetailViewController.h"
#import "UCFBidDetailNavView.h"
#import "UCFMyBatchBidViewModel.h"
#import "UCFNewBidDetaiInfoView.h"
#import "UCFRemindFlowView.h"
#import "UCFNewInvestBtnView.h"
#import "BaseTableView.h"
#import "UCFCollectionListViewController.h"
#import "UCFBatchBidWebViewController.h"
@interface UCFMyInvestBatchBidDetailViewController ()<UCFBidDetailNavViewDelegate>
@property(nonatomic, strong)UCFMyBatchBidViewModel  *VM;
@property(nonatomic, strong)UCFBidDetailNavView *navView;
@property(nonatomic, strong)UCFNewBidDetaiInfoView *bidinfoView;
@property(nonatomic, strong)UCFRemindFlowView *remind;
@property(nonatomic, strong)UCFNewInvestBtnView *investView;
@property(nonatomic, strong)MyRelativeLayout *contentLayout;

@property(nonatomic, strong)UCFCollectionListViewController *collectionListVC;
@end

@implementation UCFMyInvestBatchBidDetailViewController
- (void)loadView
{
    [super loadView];
    
    UCFBidDetailNavView *navView = [[UCFBidDetailNavView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight1)];
    self.navView = navView;
    navView.delegate = self;
    [self.rootLayout addSubview:navView];
    
    MyRelativeLayout *contentLayout = [MyRelativeLayout new];
    contentLayout.topPos.equalTo(self.navView.bottomPos);
    contentLayout.backgroundColor = [UIColor clearColor];
    contentLayout.myHorzMargin = 0; //同时指定左右边距为0表示宽度和父视图一样宽
    self.contentLayout = contentLayout;
    [self.rootLayout addSubview:self.contentLayout];
    
    UCFNewBidDetaiInfoView *bidinfoView = [[UCFNewBidDetaiInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 155)];
    self.bidinfoView = bidinfoView;
    [self.contentLayout addSubview:bidinfoView];
    
    UCFRemindFlowView *remind = [UCFRemindFlowView new];
    remind.topPos.equalTo(bidinfoView.bottomPos);
    remind.myHorzMargin = 0;
    remind.heightSize.equalTo(@40);
    remind.backgroundColor = [UIColor clearColor];
    remind.subviewVSpace = 5;
    remind.subviewHSpace = 5;
    self.remind = remind;
    [self.contentLayout addSubview:remind];
    
    [self.investView blindBaseVM:self.VM];
    
    _collectionListVC = [[UCFCollectionListViewController alloc]initWithNibName:@"UCFCollectionListViewController" bundle:nil];
    _collectionListVC.view.frame = CGRectMake(0, NavigationBarHeight1 + 155 + 40, ScreenWidth, ScreenHeight - ( NavigationBarHeight1 + 155 + 40 + 57));
    _collectionListVC.souceVC = @"BatchProjectVC";
    _collectionListVC.view.useFrame = YES;
    _collectionListVC.colPrdClaimId = _colPrdClaimIdStr;
    _collectionListVC.batchOrderIdStr = _batchOrderIdStr;
    [self.rootLayout addSubview:_collectionListVC.view];
    [self addChildViewController:_collectionListVC];
    [_collectionListVC didMoveToParentViewController:self];
    
    
    UCFNewInvestBtnView *investView = [[UCFNewInvestBtnView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 57)];
    investView.myHorzMargin = 0;
    investView.bottomPos.equalTo(@0);
    [self.rootLayout addSubview:investView];
    self.investView = investView;

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.VM.myBatchModel = self.dataModel;
    
    [self.navView blindCollectionVM:self.VM];
    
    [self.bidinfoView blindCollectionVM:self.VM];
    
    [self.remind blindCollectionVM:self.VM];
    
    [self.investView blindBaseVM:self.VM];

    [self blindCollectionVM:self.VM];
    
}

- (void)topLeftButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UCFMyBatchBidViewModel *)VM
{
    if (!_VM) {
        _VM = [UCFMyBatchBidViewModel new];
    }
    return _VM;
}
- (void)blindCollectionVM:(UCFMyBatchBidViewModel *)vm
{
    
    
    @PGWeakObj(self);
    [self.KVOController observe:vm keyPaths:@[@"checkBidDetail"] options:NSKeyValueObservingOptionNew  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"checkBidDetail"]) {
            BOOL checkBidDetail = [[change objectSafeForKey:NSKeyValueChangeNewKey] boolValue];
            if (checkBidDetail) {
                [selfWeak checkReward];
            }
        }
    }];
    
    
    

}
//查看奖励
- (void)checkReward
{
    NSDictionary *reqDict =  @{@"userId":SingleUserInfo.loginData.userInfo.userId,@"colOrderId":_batchOrderIdStr};
    NSString *urlStr =[NSString stringWithFormat:@"%@%@",SERVER_IP,GETBACHINVESTAWARD];
    UCFBatchBidWebViewController *webView = [[UCFBatchBidWebViewController alloc]initWithNibName:@"UCFBatchBidWebViewController" bundle:nil];
    webView.url =  urlStr;
    webView.webDataDic = reqDict;
    webView.navTitle = @"出借成功";
    webView.rootVc = self;
    [self.rt_navigationController pushViewController:webView animated:YES];
}
@end
