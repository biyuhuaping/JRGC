//
//  UCFNewRechargeViewController.m
//  JRGC
//
//  Created by 金融工场 on 2018/11/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFNewRechargeViewController.h"
#import "UCFNewMineViewController.h"
#import "UCFRechargeAndWithdrawalViewController.h"
#import "RechargeListViewController.h"
@interface UCFNewRechargeViewController ()<UIScrollViewDelegate>
@property(strong, nonatomic)UIScrollView *baseScroView;
@property(strong, nonatomic)UCFTransRechargeViewController *transVC;
@property(strong, nonatomic)UCFQuickRechargeViewController *quickVC;
@property (weak, nonatomic) IBOutlet UIView *topSegementView;
@property (weak, nonatomic) IBOutlet UIView *bottomRedView;
@property (weak, nonatomic) IBOutlet UIButton *quickButton;
@property (weak, nonatomic) IBOutlet UIButton *bankTransButton;
@property (strong, nonatomic) NSMutableArray *dataArr;


@end

@implementation UCFNewRechargeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setSetNavgationPopDisabled:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addQuickVC];
    [self addTransVC];
    [self createUI];
}
- (IBAction)topButtonClick:(UIButton *)sender {
    UIButton *button1 = (UIButton *)[_topSegementView viewWithTag:100];
    button1.selected = NO;
    UIButton *button2 = (UIButton *)[_topSegementView viewWithTag:101];
    button2.selected = NO;
    CGPoint center = sender.center;
    _bottomRedView.frame = CGRectMake(center.x - CGRectGetWidth(_bottomRedView.frame)/2.0f, CGRectGetMinY(_bottomRedView.frame), CGRectGetWidth(_bottomRedView.frame), CGRectGetHeight(_bottomRedView.frame));
    _baseScroView.contentOffset = CGPointMake((sender.tag - 100) * ScreenWidth, 0);
    sender.selected = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    _baseScroView.frame = CGRectMake(0, 40, ScreenWidth, CGRectGetHeight(self.view.frame) - 40);
    _baseScroView.contentSize = CGSizeMake(ScreenWidth * 2, CGRectGetHeight(_baseScroView.frame));
    _quickVC.view.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(_baseScroView.frame));
    _transVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(_baseScroView.frame));
    UIButton *button1 = (UIButton *)[_topSegementView viewWithTag:100];
    CGPoint center = button1.center;
    _bottomRedView.frame = CGRectMake(center.x - CGRectGetWidth(_bottomRedView.frame)/2.0f, CGRectGetMinY(_bottomRedView.frame), CGRectGetWidth(_bottomRedView.frame), CGRectGetHeight(_bottomRedView.frame));
    _baseScroView.contentOffset = CGPointMake((button1.tag - 100) * ScreenWidth, 0);
    button1.selected = YES;
    _quickVC.uperViewController = self;
}
- (void)createUI
{
    baseTitleLabel.text = @"微金充值";
    self.accoutType = SelectAccoutTypeP2P;
    self.view.backgroundColor = [UIColor blueColor];
    [self addRightButtonWithName:@"充值记录"];
    [self addLeftButton];
    [self.view addSubview:self.baseScroView];
    [self.baseScroView addSubview:_quickVC.view];
    [self.baseScroView addSubview:_transVC.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fradeboard:)];
    [self.baseScroView addGestureRecognizer:tap];

}
- (void)getToBack
{
    for (UCFBaseViewController *vc in self.rt_navigationController.rt_viewControllers) {
        if ([vc isKindOfClass:[UCFNewMineViewController class]]) {
            [(UCFNewMineViewController *)vc refreshPageData];
        }
        if ([vc isKindOfClass:[UCFRechargeAndWithdrawalViewController class]]) {
            [vc refreshPageData];
        }
    }
    [self.rt_navigationController popViewControllerAnimated:YES];
}
- (void)fradeboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
- (void)addRightButtonWithName:(NSString *)rightButtonName;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 65, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightbutton setTitleColor:UIColorWithRGB(0x000000) forState:UIControlStateNormal];
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
- (void)addTransVC {
    _transVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, CGRectGetHeight(self.view.frame) - 40);
    [_baseScroView addSubview:self.transVC.view];
}
- (void)addQuickVC {
    _quickVC.view.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame) - 40);
    [_baseScroView addSubview:self.quickVC.view];
}
- (UIScrollView *)baseScroView
{
    if (!_baseScroView) {
        _baseScroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame) - 40)];
        _baseScroView.bounces = NO;
        _baseScroView.pagingEnabled = YES;
        _baseScroView.delegate = self;
        _baseScroView.contentSize = CGSizeMake(ScreenWidth * 2, CGRectGetHeight(self.view.frame) - 40);
        
    }
    return _baseScroView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _baseScroView) {
        CGFloat x = scrollView.contentOffset.x;
        _quickButton.selected = NO;
        _bankTransButton.selected = NO;
        if (x/ScreenWidth < 0.5) {
            CGPoint center = _quickButton.center;
            _bottomRedView.frame = CGRectMake(center.x - CGRectGetWidth(_bottomRedView.frame)/2.0f, CGRectGetMinY(_bottomRedView.frame), CGRectGetWidth(_bottomRedView.frame), CGRectGetHeight(_bottomRedView.frame));
            _quickButton.selected = YES;
        } else {
            CGPoint center = _bankTransButton.center;
            _bottomRedView.frame = CGRectMake(center.x - CGRectGetWidth(_bottomRedView.frame)/2.0f, CGRectGetMinY(_bottomRedView.frame), CGRectGetWidth(_bottomRedView.frame), CGRectGetHeight(_bottomRedView.frame));
            _bankTransButton.selected = YES;
            
            [self.transVC refreshTableView];
            
        }
    }
}
- (UCFTransRechargeViewController *)transVC
{
    if (!_transVC) {
        _transVC = [[UCFTransRechargeViewController alloc] initWithNibName:@"UCFTransRechargeViewController" bundle:nil];
        _transVC.view.frame = CGRectMake(ScreenWidth, 44, ScreenWidth, CGRectGetHeight(self.view.frame) - 44);
        _transVC.accoutType = SelectAccoutTypeP2P;
        _transVC.rootVc = self;
    }
    return _transVC;
}
- (UCFQuickRechargeViewController *)quickVC {
    if (!_quickVC) {
        _quickVC = [[UCFQuickRechargeViewController alloc] initWithNibName:@"UCFQuickRechargeViewController" bundle:nil];
        _quickVC.view.frame = CGRectMake(0, 44, ScreenWidth, CGRectGetHeight(self.view.frame) - 44);
        _quickVC.rootVc = self;
        _quickVC.accoutType = SelectAccoutTypeP2P;
        
    }
    return _quickVC;
}
- (void)setDefaultMoney:(NSString *)defaultMoney
{
    self.quickVC.defaultMoney = defaultMoney;
    _quickVC.rootVc = _uperViewController;
}




- (void)dealloc
{
    
}




















@end
