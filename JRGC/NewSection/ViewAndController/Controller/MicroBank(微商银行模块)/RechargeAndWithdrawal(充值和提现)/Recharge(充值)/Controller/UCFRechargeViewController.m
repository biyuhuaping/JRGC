//
//  UCFRechargeViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRechargeViewController.h"
#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
#import "UCFTransRechargeViewController.h"
#import "UCFQuickRechargeViewController.h"
#import "RechargeListViewController.h"

@interface UCFRechargeViewController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property(nonatomic, strong) UCFPageControlTool *pageController;

@property(nonatomic, strong) UCFPageHeadView    *pageHeadView;

@property(strong, nonatomic)UCFTransRechargeViewController *transVC;

@property(strong, nonatomic)UCFQuickRechargeViewController *quickVC;



@end

@implementation UCFRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self addLeftButton];
    [self addRightButtonWithName:@"充值记录"];
    baseTitleLabel.text = @"微金充值";
    
    [self.rootLayout addSubview:self.pageController];
}
- (UCFPageHeadView *)pageHeadView
{
    if (nil == _pageHeadView) {
        NSString *title1 = @"快捷充值";
        NSString *title2 = @"转账充值";
        _pageHeadView = [[UCFPageHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) WithTitleArray:@[title1,title2]];
        [_pageHeadView reloaShowView];
    }
    return _pageHeadView;
}
- (UCFPageControlTool *)pageController
{
    if (nil == _pageController) {
        _pageController = [[UCFPageControlTool alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight1 ) WithChildControllers:@[self.quickVC,self.transVC] WithParentViewController:self WithHeadView:self.pageHeadView];
    }
    return _pageController;
}
- (UCFTransRechargeViewController *)transVC
{
    if (!_transVC) {
        _transVC = [[UCFTransRechargeViewController alloc] initWithNibName:@"UCFTransRechargeViewController" bundle:nil];
        _transVC.accoutType = SelectAccoutTypeP2P;
        _transVC.rootVc = self;
    }
    return _transVC;
}
- (UCFQuickRechargeViewController *)quickVC {
    if (!_quickVC) {
        _quickVC = [[UCFQuickRechargeViewController alloc] initWithNibName:@"UCFQuickRechargeViewController" bundle:nil];
        _quickVC.rootVc = self;
        _quickVC.accoutType = SelectAccoutTypeP2P;
        
    }
    return _quickVC;
}
- (void)addRightButtonWithName:(NSString *)rightButtonName;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 65, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)clickRightBtn
{
    RechargeListViewController *viewController = [[RechargeListViewController alloc] init];
    viewController.accoutType = self.accoutType;
    [self.navigationController pushViewController:viewController animated:YES];
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
