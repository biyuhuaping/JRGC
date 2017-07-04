//
//  UCFGoldDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldDetailViewController.h"
#import "UILabel+Misc.h"
#import "UIImage+Misc.h"
#import "HMSegmentedControl.h"
#import "UCFGoldDetailHeaderView.h"

@interface UCFGoldDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    
    UILabel *_topLabel;
    HMSegmentedControl *_topSegmentedControl;
    BOOL _oneScrollPull;
    NSInteger _selectIndex;
    UIImageView *_navigationStyleBar;
}

@property(nonatomic,strong) UIScrollView *oneScroll;
@property(nonatomic ,strong)UITableView *twoTableview;
@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation UCFGoldDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addLeftButton];
     [self addnavigationBar];
    
    [self initOneScrollView];
    [self initTableViews];
    [self addnavigationBar];
    // Do any additional setup after loading the view from its nib.
}
//自定义navigationbar
- (void) addnavigationBar
{
    CGFloat scaleFlot = 1;
    if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        scaleFlot = 1.171875;
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        scaleFlot =  1.29375;
    }
    _navigationStyleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight)];
    _navigationStyleBar.image = [UIImage imageNamed:@"particular_bg_1"];
    [self.view addSubview:_navigationStyleBar];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 16, 44, 44)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(4, 10, 6, 9)];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationStyleBar addSubview:leftButton];
    _navigationStyleBar.userInteractionEnabled = YES;
}
- (void) getBack
{
    if (kIS_IOS7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initOneScrollView
{
    _oneScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight)];
    _oneScroll.backgroundColor = [UIColor redColor];
    if (kIS_Iphone4) {
        [_oneScroll setContentSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    } else {
//        NSString *fixUpdate = [[_dataDic objectForKey:@"prdClaims"]objectForKey:@"fixedDate"];
         NSString *fixUpdate = @"";
        //如果没有固定起息日
        if ([fixUpdate isEqual:[NSNull null]] || [fixUpdate isEqualToString:@""] || !fixUpdate) {
            [_oneScroll setContentSize:CGSizeMake(ScreenWidth, scrollViewHeight4S - 44)];
        } else {
            [_oneScroll setContentSize:CGSizeMake(ScreenWidth, scrollViewHeight4S)];
        }
    }
    _oneScroll.delegate = self;
    _oneScroll.tag = 1001;
    _oneScroll.showsVerticalScrollIndicator = NO;
    [_oneScroll setBackgroundColor:UIColorWithRGB(0xebebee)];
    [self.view addSubview:_oneScroll];
    
    [self drawPullingView];
    
//    detailView = [[UCFBidNewDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight) WithProjectType:PROJECTDETAILTYPENORMAL prdList:_prdLabelsList dataDic:_dataDic isP2P:_isP2P];
//    detailView.delegate = self;
//    [self addSubview:_oneScroll];
//    [_oneScroll addSubview:detailView];
}
//上拉view
- (void)drawPullingView
{
    UIView *pullingBkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_oneScroll.frame)-42, ScreenWidth, 42)];
//    pullingBkView.backgroundColor = [UIColor redColor];
    [_oneScroll addSubview:pullingBkView];
    pullingBkView.backgroundColor = [UIColor clearColor];
    
    UILabel *buyCueDesTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    buyCueDesTipLabel.textColor = UIColorWithRGB(0x999999);
    buyCueDesTipLabel.textAlignment = NSTextAlignmentLeft;
    buyCueDesTipLabel.backgroundColor = [UIColor clearColor];
    buyCueDesTipLabel.font = [UIFont systemFontOfSize:12];
    //    NSString *buyCueDesStr =[_dic objectSafeForKey: @"buyCueDes"];
    //    if (_type == PROJECTDETAILTYPEBONDSRRANSFER && !_isP2P && ![buyCueDesStr isEqualToString:@""] ) {
    //        pullingBkView.frame = CGRectMake(0, CGRectGetMaxY(bottomBkView.frame), ScreenWidth, 42 + 20);
    //        buyCueDesTipLabel.text = buyCueDesStr;
    //        [pullingBkView addSubview:buyCueDesTipLabel];
    //    }else{
    //        buyCueDesTipLabel.frame = CGRectZero;
    //    }
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 15) / 2, CGRectGetMaxY(buyCueDesTipLabel.frame)+10, 15, 15)];
    iconView.image = [UIImage imageNamed:@"particular_icon_up.png"];
    [pullingBkView addSubview:iconView];
    
    UILabel *pullingLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 5, ScreenWidth, 12) text:@"向上滑动，查看详情" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
    [pullingBkView addSubview:pullingLabel];
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.frame = CGRectMake(0, 0, ScreenWidth, 42);
    [pullingBkView addSubview:bottomBtn];
    [pullingBkView setUserInteractionEnabled:YES];
}

- (void)initTableViews
{

    _titleArray = [[NSArray alloc] initWithObjects:@"基础详情",@"认购记录", nil];

    _twoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _twoTableview.backgroundColor = [UIColor clearColor];
    //_tableView.separatorColor = UIColorWithRGB(0xeff0f3);
    _twoTableview.delegate = self;
    _twoTableview.dataSource = self;
    //_tableView.bounces = NO;
    _twoTableview.showsVerticalScrollIndicator = NO;
    _twoTableview.tag = 1002;
    if (kIS_IOS7) {
        [_twoTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _twoTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        _twoTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.view addSubview:_twoTableview];
    _twoTableview.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    //    _twoTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    [self addTopSegment];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    _twoTableview.tableFooterView = lineView;
    
    //下拉view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, - 40, ScreenWidth, 40)];
    topView.backgroundColor = [UIColor clearColor];
    [_twoTableview addSubview:topView];
    
    UIView *topBkView = [[UIView alloc] initWithFrame:CGRectZero];
    topBkView.center = topView.center;
    [topView addSubview:topBkView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    UIImage *iconImg = [UIImage imageNamed:@"particular_icon_up.png"];
    iconView.image = [UIImage image:iconImg rotation:UIImageOrientationDown] ;
    [topBkView addSubview:iconView];
    
    _topLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5,0,ScreenWidth, 15) text:@"下拉，回到顶部" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
    [topBkView addSubview:_topLabel];
    CGFloat stringWidth = [@"下拉，回到顶部" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].width;
    CGRect labelFrame = _topLabel.frame;
    labelFrame.size.width = stringWidth;
    _topLabel.frame = labelFrame;
    
    CGRect bkFrame = topBkView.frame;
    bkFrame.size.width = 15 + 5 + stringWidth;
    bkFrame.size.height = 15;
    bkFrame.origin.x = (ScreenWidth - bkFrame.size.width) / 2;
    bkFrame.origin.y = 12;
    topBkView.frame = bkFrame;
    
}
- (void)addTopSegment
{
    _topSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
    [_topSegmentedControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _topSegmentedControl.selectionIndicatorHeight = 2.0f;
    _topSegmentedControl.backgroundColor = [UIColor whiteColor];
    _topSegmentedControl.font = [UIFont systemFontOfSize:14];
    _topSegmentedControl.textColor = UIColorWithRGB(0x3c3c3c);
    _topSegmentedControl.selectedTextColor = UIColorWithRGB(0xfd4d4c);
    _topSegmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfd4d4c);
    _topSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _topSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _topSegmentedControl.shouldAnimateUserSelection = YES;
    _topSegmentedControl.tag = 10001;
    [_topSegmentedControl addTarget:self action:@selector(topSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_topSegmentedControl];
//    [self.view viewAddLine:_topSegmentedControl Up:YES];
    //[self viewAddLine:_topSegmentedControl Up:NO];
    for (int i = 0 ; i < _titleArray.count - 1 ; i++) {
        UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
        linebk.frame = CGRectMake(ScreenWidth/_titleArray.count * (i + 1), 16, 1, 12);
        [_topSegmentedControl addSubview:linebk];
    }
    [_topSegmentedControl setHidden:YES];
    if (_selectIndex != 0) {
        _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}
- (void)topSegmentedControlChangedValue:(HMSegmentedControl *)segmentCtrl
{
    _topSegmentedControl.selectedSegmentIndex = segmentCtrl.selectedSegmentIndex;
    _selectIndex = segmentCtrl.selectedSegmentIndex;
    [_twoTableview  setContentInset:UIEdgeInsetsZero];
    [_twoTableview reloadData];
}

#pragma mark -scrollViewScroll

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetFloat;
    if (kIS_Iphone4) {
        offsetFloat = 64;
    } else {
        offsetFloat = 80;
    }
    NSInteger tag = scrollView.tag;
    if (tag == 1002) {
        if (scrollView.contentOffset.y < -50) {
            [_oneScroll setContentOffset:CGPointMake(0, 0) animated:YES];
//            [_delegate toUpView];
            [self removeTopSegment];
            //_investmentView.frame = CGRectMake(0, ScreenHeight - 67, ScreenWidth, 67);
            [UIView animateWithDuration:0.3 animations:^{
                _oneScroll.frame = CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight);
                _twoTableview.frame = CGRectMake(0, ScreenHeight, ScreenWidth, BidDetailScrollViewHeight);
            } completion:^(BOOL finished) {
                _oneScrollPull = NO;
//                [bottomView setHidden:NO];x
                if (_oneScroll.frame.origin.y == 0) {
                    [self removeTopSegment];
                }
            }];
        }
    }  else if (tag == 1001) {
        if (scrollView.contentOffset.y > offsetFloat) {
            if (!_oneScrollPull) {
                [self addTopSegment];
//                [_delegate toDownView];
                [UIView animateWithDuration:0.3 animations:^{
                    _oneScroll.frame = CGRectMake(0, -ScreenHeight - 64, ScreenWidth, BidDetailScrollViewHeight);
                    _twoTableview.frame = CGRectMake(0,0, ScreenWidth, BidDetailScrollViewHeight);
                } completion:^(BOOL finished) {
//                    [bottomView setHidden:YES];
                    [self hideAllTopSegment:NO];
                    _oneScrollPull = YES;
                }];
            }
        }
    }
    
    _topLabel.text = @"下拉，回到顶部";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger tag = scrollView.tag;
    if (tag == 1002) {
        if (scrollView.contentOffset.y <= 0) {
            [self hideAllTopSegment:NO];
            CGFloat sectionHeaderHeight = 44;
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        } else {
            [self hideAllTopSegment:YES];
        }
        if (scrollView.contentOffset.y < -50) {
            _topLabel.text = @"释放，回到顶部";
        }
    } else if (tag == 1001) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        } else {
            
        }
    }
}

- (void)removeTopSegment
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg removeFromSuperview];
            seg = nil;
        }
    }
}

- (void)hideAllTopSegment:(BOOL)isHide
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg setHidden:isHide];
        }
    }
}
- (void)showAllTopSegment:(BOOL)isShow
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg setHidden:isShow];
        }
    }
}



- (void)bottomBtnClicked:(id)sender
{
       [self addTopSegment];
//    [_delegate toDownView];
    //_investmentView.frame = CGRectMake(0, ScreenHeight - 67 - 64, ScreenWidth, 67);
    _oneScroll.frame = CGRectMake(0, -ScreenHeight - 64, ScreenWidth, ScreenHeight - 64 - 57);
    [UIView animateWithDuration:0.2 animations:^{
        _twoTableview.frame = CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight);
    } completion:^(BOOL finished) {
//        [bottomView setHidden:YES];
        [self hideAllTopSegment:NO];
    }];}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
