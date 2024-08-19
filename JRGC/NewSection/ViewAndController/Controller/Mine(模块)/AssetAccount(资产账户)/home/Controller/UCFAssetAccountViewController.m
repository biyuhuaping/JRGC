//
//  UCFAssetAccountViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAssetAccountViewController.h"
#import "UCFPageHeadView.h"
#import "UCFPageControlTool.h"
#import "UCFAssetAccountViewTotalController.h"
#import "UCFAssetAccountViewEarningsController.h"


@interface UCFAssetAccountViewController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property(nonatomic, strong) UCFPageControlTool *pageController;

@property(nonatomic, strong) UCFPageHeadView    *pageHeadView;

@property(nonatomic, strong) NSMutableArray *accountTitleArray;

@property(nonatomic, strong) NSMutableArray *accountControllerArray;

@end

@implementation UCFAssetAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    [self addLeftButton];
    baseTitleLabel.text = @"资产总览";
    
    self.accountTitleArray = [NSMutableArray new];
    self.accountControllerArray = [NSMutableArray new];
    
    [self.accountTitleArray addObjectsFromArray:[NSArray arrayWithObjects:@"总资产",@"已收收益", nil]];
    
    UCFAssetAccountViewTotalController *vcTotal = [[UCFAssetAccountViewTotalController alloc] init];
    [self.accountControllerArray addObject:vcTotal];
    
    UCFAssetAccountViewEarningsController *vcEarnings = [[UCFAssetAccountViewEarningsController alloc] init];
    vcEarnings.zxAccountIsShow = self.zxAccountIsShow;
    vcEarnings.nmAccountIsShow = self.nmAccountIsShow;
    [self.accountControllerArray addObject:vcEarnings];
    
    [self.rootLayout addSubview:self.pageController];
    
    
    UIView *topLineView = [UIView new];
    topLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    topLineView.myTop = 0;
    topLineView.myHeight = 0.5;
    topLineView.myLeft = 0;
    topLineView.myRight = 0;
    [self.rootLayout addSubview:topLineView];
    
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    bottomLineView.myTop = 44;
    bottomLineView.myHeight = 0.5;
    bottomLineView.myLeft = 0;
    bottomLineView.myRight = 0;
    [self.rootLayout addSubview:bottomLineView];
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
        _pageController.segmentScrollV.scrollEnabled = NO;
    }
    return _pageController;
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
