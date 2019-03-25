//
//  UCFRechargeAndWithdrawalViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRechargeAndWithdrawalViewController.h"
#import "UCFRechargeAndWithdrawalAccountBalancePageModel.h"
#import "UCFRechargeAndWithdrawalAccountBalancePageApi.h"

#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
#import "UCFRechargeAndWithdrawalDetailsViewController.h"

#import "UCFUserAllStatueRequest.h"
@interface UCFRechargeAndWithdrawalViewController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property(nonatomic, strong) UCFPageControlTool *pageController;

@property(nonatomic, strong) UCFPageHeadView    *pageHeadView;

@property(nonatomic, strong) UCFRechargeAndWithdrawalAccountBalancePageModel *model;

@property(nonatomic, strong) NSMutableArray *accountTitleArray;

@property(nonatomic, strong) NSMutableArray *accountControllerArray;

@end

@implementation UCFRechargeAndWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self addLeftButton];
    baseTitleLabel.text = @"我的余额";

    [self requetAccount];
}

- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
//        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) WithTitleArray:[self.accountTitleArray copy] WithType:1];
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44) WithTitleArray:[self.accountTitleArray copy]];
        _pageHeadView.isHiddenHeadView = YES;
        [_pageHeadView reloaShowView];
    }
    return _pageHeadView;
}
- (UCFPageControlTool *)pageController
{
    if (nil == _pageController) {
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1) WithChildControllers:self.accountControllerArray WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}

- (void)requetAccount
{
    UCFRechargeAndWithdrawalAccountBalancePageApi * request = [[UCFRechargeAndWithdrawalAccountBalancePageApi alloc] init];
    
    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        self.model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",self.model);
        if (self.model.ret == YES) {
            self.accountTitleArray = [NSMutableArray new];
            self.accountControllerArray = [NSMutableArray new];
            UCFRechargeAndWithdrawalDetailsViewController *vc;
            if (self.model.data.wjIsShow) {
                [self.accountTitleArray addObject:@"微金账户"];
                vc = [[UCFRechargeAndWithdrawalDetailsViewController alloc] init];
                vc.accoutType = SelectAccoutTypeP2P;
                vc.accoutBalance = self.model.data.p2pBalance;
                [self.accountControllerArray addObject:vc];
            }
            if (self.model.data.zxIsShow) {
                [self.accountTitleArray addObject:@"尊享账户"];
                vc = [[UCFRechargeAndWithdrawalDetailsViewController alloc] init];
                vc.accoutType = SelectAccoutTypeHoner;
                vc.accoutBalance = self.model.data.zxBalance;
                [self.accountControllerArray addObject:vc];
            }
            if (self.model.data.nmIsShow) {
                [self.accountTitleArray addObject:@"黄金账户"];
                vc = [[UCFRechargeAndWithdrawalDetailsViewController alloc] init];
                vc.accoutType = SelectAccoutTypeGold;
                vc.accoutBalance = self.model.data.goldBalance;
                [self.accountControllerArray addObject:vc];
            }
            [self.rootLayout addSubview:self.pageController];
        }
        else{
            ShowMessage(self.model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
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

@end
