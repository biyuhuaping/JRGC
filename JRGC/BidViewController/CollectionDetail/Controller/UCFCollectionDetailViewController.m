//
//  UCFCollectionDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionDetailViewController.h"
#import "UILabel+Misc.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "SDLoopProgressView.h"
#import "NSDateManager.h"
#import "UIDic+Safe.h"
#import "HMSegmentedControl.h"
#import "UCFCollectionDetailCell.h"
#import "UCFCollectionListCell.h"
#import "MjAlertView.h"
#import "NZLabel.h"
#import "UCFCollectionListViewController.h"
#import "UCFNoPermissionViewController.h"
#import "UCFProjectDetailViewController.h"
#define shadeSpacingHeight 18 //遮罩label的上下间距
#define shadeHeight 70 //遮罩高度
static NSString * const DetailCellID = @"UCFCollectionDetailCell";
static NSString * const ListCellID = @"UCFCollectionListCell";
@interface UCFCollectionDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MjAlertViewDelegate,UCFCollectionDetailCellDelegare>
{
    UIImageView *_headerBgView; //上面的视图
    MDRadialProgressView *_circleProgress;
    SDLoopProgressView *proressView;
    UIView *bottomBkView;//下部view
    UILabel *_remainMoneyLabel;//剩多少标
    UILabel *_totalMoneyLabel;//总多少表
    UILabel *_subsidizedInterestLabel;//补贴利息
    NZLabel *_annualEarningsLabel;//年化收益
    NZLabel *_markTimeLabel;//标时长
    UILabel *_activitylabel1;//二级标签
    UILabel *_activitylabel2;//三级标签
    NSDictionary *_dataDic;//数据字典
    
    NSTimer *updateTimer;
    CGFloat Progress;
    CGFloat curProcess;
    
    HMSegmentedControl *_topSegmentedControl;
    NSInteger _selectIndex;//segmentselect
    
    NSInteger _currentSelectSortTag;//当前选择排序tag
}
@property (weak, nonatomic) IBOutlet UIScrollView *collectionScrollView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (assign, nonatomic)float headerViewHeight;
@property (strong,nonatomic) UITableView *listTableView;
@property (strong,nonatomic) UIButton *sortButton;   //排序按钮
@property (assign,nonatomic) int currentPage;
@property (strong,nonatomic)NSMutableArray *investmentProjectDataArray;//可投项目数组
@property (strong,nonatomic)NSMutableArray *fullProjectDataArray;//已满项目数组
@property (strong,nonatomic)NSMutableArray *investmentDetailDataArray;//投资详情数组

- (IBAction)goBackVC:(UIButton *)sender;
- (IBAction)ClickBatchInvestment:(UIButton *)sender;


@end

@implementation UCFCollectionDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self drawTopView];
    [self.collectionScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight +_headerViewHeight - 64 - 57)];
    self.collectionScrollView.delegate = self;
    self.collectionScrollView.tag = 1010;
    self.collectionScrollView.bounces = YES;
    self.collectionScrollView.alwaysBounceVertical = YES;
    [self progressAnimiation];
    
    if([_souceVC isEqualToString:@"P2PVC"]){
        [self drawBottomBgView];
    }else{
        [self drawCollectionListView];
    }
   
}
#pragma mark
#pragma mark 绘制顶部视图
- (void)drawTopView
{
    _headerBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0 + [Common calculateNewSizeBaseMachine:207])];
    _headerViewHeight = _headerBgView.frame.size.height;
    _headerBgView.image = [UIImage imageNamed:@"particular_bg_2"];
    _headerBgView.userInteractionEnabled = YES;
    [self.collectionScrollView addSubview:_headerBgView];
    
    //集合标名称
    self.navTitleLabel.text = [_detailDataDict objectSafeForKey:@"colName"];
    
//    年化收益
    CGFloat stringWidth = [@"年化收益" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}].width;
    
    //顶部年化收益 投资期限
    UILabel *annualLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],0 + [Common calculateNewSizeBaseMachine:20],0,11) text:@"年化收益" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headerBgView addSubview:annualLabel];
    
    CGRect annualLabelFrame = annualLabel.frame;
    annualLabelFrame.size.width = stringWidth;
    annualLabel.frame = annualLabelFrame;
    
    NSString *annualStr = [NSString stringWithFormat:@"%@%%",[_detailDataDict objectSafeForKey:@"colRate"]];
    CGSize size = [annualStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:25]}];
    _annualEarningsLabel = [[NZLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(annualLabel.frame) + 10,CGRectGetMaxY(annualLabel.frame) - 25,size.width,size.height)];
    _annualEarningsLabel.text = annualStr;
    _annualEarningsLabel.font = [UIFont systemFontOfSize:25];
    _annualEarningsLabel.textColor = [UIColor whiteColor];
    _annualEarningsLabel.textAlignment = NSTextAlignmentLeft;
    [_annualEarningsLabel setFont: [UIFont systemFontOfSize:15] string:@"%"];
    [_headerBgView addSubview:_annualEarningsLabel];
    
    
//    投资期限
    UILabel *markLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],0 + CGRectGetMaxY(annualLabel.frame)+30,0,11) text:@"投资期限" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headerBgView addSubview:markLabel];
    
    CGRect markLabelFrame = markLabel.frame;
    markLabelFrame.size.width = stringWidth;
    markLabel.frame = markLabelFrame;
    
    NSString *colPeriodStr = [_detailDataDict objectSafeForKey:@"colPeriod"];
    CGSize colPeriodsize = [colPeriodStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:25]}];
    _markTimeLabel = [[NZLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markLabel.frame) + 10,CGRectGetMaxY(markLabel.frame) - 25,colPeriodsize.width,colPeriodsize.height)];
    _markTimeLabel.text = colPeriodStr;
    _markTimeLabel.font = [UIFont systemFontOfSize:25];
    _markTimeLabel.textColor = [UIColor whiteColor];
    _markTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_markTimeLabel setFont: [UIFont systemFontOfSize:15] string:@"天"];
    [_markTimeLabel setFont: [UIFont systemFontOfSize:15] string:@"个月"];
    [_headerBgView addSubview:_markTimeLabel];
    
    NSString *colMinInvestStr = [NSString stringWithFormat:@"%@元",[_detailDataDict objectSafeForKey:@"colMinInvest"] ];
    CGSize activitylabel1Size =[Common getStrWitdth:colMinInvestStr TextFont:[UIFont systemFontOfSize:11]];
    //最多2个标签
    _activitylabel1 = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], CGRectGetMaxY(markLabel.frame)+25, activitylabel1Size.width+10, 15) text:colMinInvestStr textColor:UIColorWithRGB(0x28335c) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel1.backgroundColor = [UIColor whiteColor];
    _activitylabel1.layer.cornerRadius = 2.0;
    _activitylabel1.layer.masksToBounds = YES;
    [_headerBgView addSubview:_activitylabel1];
    NSString *colRepayModeStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"colRepayMode"] ];
    CGSize activitylabel2Size =[Common getStrWitdth:colRepayModeStr TextFont:[UIFont systemFontOfSize:11]];
    _activitylabel2 = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(_activitylabel1.frame)+15, CGRectGetMaxY(markLabel.frame)+25, activitylabel2Size.width+10, 15) text:colRepayModeStr textColor:UIColorWithRGB(0x28335c) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel2.backgroundColor = [UIColor whiteColor];
    _activitylabel2.layer.cornerRadius = 2.0;
    _activitylabel2.layer.masksToBounds = YES;
    [_headerBgView addSubview:_activitylabel2];
    //底部遮罩部分
    UIView *bottomBk = [[UIView alloc] initWithFrame:CGRectMake(0, _headerBgView.frame.size.height - [Common calculateNewSizeBaseMachine:shadeHeight], ScreenWidth, [Common calculateNewSizeBaseMachine:shadeHeight])];
    bottomBk.backgroundColor = UIColorWithRGB(0x152139);
    bottomBk.alpha = 0.6;
    [_headerBgView addSubview:bottomBk];
    
    
    UILabel *remainLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],bottomBk.frame.origin.y + [Common calculateNewSizeBaseMachine:shadeSpacingHeight],0,12) text:@"可投金额" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headerBgView addSubview:remainLabel];
    CGRect remainLabelFrame = remainLabel.frame;
    remainLabelFrame.size.width = stringWidth;
    remainLabel.frame = remainLabelFrame;
    
   
    NSString *canBuyAmtStr =[NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"canBuyAmt"] ];
    canBuyAmtStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod dealmoneyFormartForDetailView:[NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:canBuyAmtStr]]]];//可投额度
    _remainMoneyLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(remainLabel.frame) + 10,remainLabel.frame.origin.y - 1,150,14) text:canBuyAmtStr textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
    _remainMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [_headerBgView addSubview:_remainMoneyLabel];
    
    UILabel *totalLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],[Common calculateNewSizeBaseMachine:207] - [Common calculateNewSizeBaseMachine:shadeSpacingHeight] - 12,0,12) text:@"可投项目" textColor:UIColorWithRGB(0x7e96c4) font:[UIFont systemFontOfSize:11]];
    [_headerBgView addSubview:totalLabel];
    CGRect totalLabelFrame = totalLabel.frame;
    totalLabelFrame.size.width = stringWidth;
    totalLabel.frame = totalLabelFrame;
    
     NSString *canBuyCountStr = [NSString stringWithFormat:@"%@个",[_detailDataDict objectSafeForKey:@"canBuyCount"] ];
    
    _totalMoneyLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame) + 10,totalLabel.frame.origin.y - 1,150,14) text:canBuyCountStr textColor:UIColorWithRGB(0x7e96c4) font:[UIFont systemFontOfSize:14]];
    [_headerBgView addSubview:_totalMoneyLabel];
    _totalMoneyLabel.textAlignment = NSTextAlignmentLeft;
    //进度条部分
    CGRect frame = CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:130],_headerBgView.frame.size.height - [Common calculateNewSizeBaseMachine:130], [Common calculateNewSizeBaseMachine:115], [Common calculateNewSizeBaseMachine:115]);
    _circleProgress = [[MDRadialProgressView alloc] initWithFrame:frame];
    _circleProgress.progressTotal = 100;
    _circleProgress.progressCounter = 10;
    _circleProgress.theme.sliceDividerHidden = YES;
    _circleProgress.theme.thickness = 14;
    _circleProgress.theme.centerColor = UIColorWithRGB(0x28335c);
    _circleProgress.theme.incompletedColor = UIColorWithRGB(0x162138);
    _circleProgress.theme.completedColor = UIColorWithRGB(0xfff100);
    _circleProgress.label.hidden = YES;
    [_headerBgView addSubview:_circleProgress];
    
    proressView = [[SDLoopProgressView alloc] initWithFrame:frame];
    proressView.center = _circleProgress.center;
    proressView.progress = 0;
    [_headerBgView addSubview:proressView];
    //进度条中间的百分比label
    NSString* percentageStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"percentage"]];
    Progress = [percentageStr floatValue] / 100.0;
    if (Progress > 0 && Progress < 0.01) {
        percentageStr = @"1";
    }
    percentageStr =[NSString stringWithFormat:@"%@%%",percentageStr];
    CGSize percentageStrSize = [percentageStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:25]}];
    NZLabel* rateLabel = [[NZLabel alloc]initWithFrame:CGRectMake(0,0,percentageStrSize.width ,percentageStrSize.height)];
    rateLabel.text = percentageStr;
    rateLabel.center = _circleProgress.center;
    rateLabel.font = [UIFont systemFontOfSize:25];
    rateLabel.textColor = [UIColor whiteColor];
    rateLabel.textAlignment = NSTextAlignmentLeft;
    [rateLabel setFont: [UIFont systemFontOfSize:15] string:@"%"];
    [_headerBgView addSubview:rateLabel];
}
- (void)setProcessViewProcess:(CGFloat)process
{
    proressView.progress = process;
}
#pragma mark 设置进度条的动画
- (void)progressAnimiation
{
    NSString* percentageStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"percentage"]];
    Progress = [percentageStr floatValue] / 100.0;
    if (Progress > 0.98 && Progress < 1.0) {
        Progress = 0.98;
    } else if (Progress > 0.97 && Progress < 0.99) {
        Progress = 0.97;
    }
    [self performSelector:@selector(beginUpdatingProgressView) withObject:nil afterDelay:0.1];
}
- (void)beginUpdatingProgressView
{
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}
- (void)updateProgress:(NSTimer *)timer
{
    if (fabs(curProcess - Progress) < 0.01) {
        [self setProcessViewProcess:Progress];
        [timer invalidate];
    } else {
        [self setProcessViewProcess:curProcess + 0.01];
        curProcess = curProcess + 0.01;
    }
}
-(void)drawBottomBgView2{
    UCFCollectionListViewController *collectionListVC = [[UCFCollectionListViewController alloc]initWithNibName:@"UCFCollectionListViewController" bundle:nil];
    collectionListVC.view.frame = CGRectMake(0, _headerViewHeight, ScreenWidth, ScreenHeight - 64 - 57-_headerViewHeight);
    collectionListVC.souceVC = @"P2PVC";
    collectionListVC.colPrdClaimId = _colPrdClaimId;
    [self.collectionScrollView addSubview:collectionListVC.view];
    [self addChildViewController:collectionListVC];
    [collectionListVC didMoveToParentViewController:self];
}
#pragma mark
#pragma mark 初始化底部--即项目列表
-(void)drawBottomBgView{
    //初始化数组
    self.investmentProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    self.fullProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    [self addTableHeaderView];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headerViewHeight+74, ScreenWidth, ScreenHeight - 64 - 57 - 74 ) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _listTableView.tag = 1020;
    _listTableView.backgroundColor = UIColorWithRGB(0xebebee);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerNib:[UINib nibWithNibName:@"UCFCollectionDetailCell" bundle:nil] forCellReuseIdentifier:DetailCellID];
    [self.collectionScrollView addSubview:_listTableView];
    
    
    
    __weak typeof(self)  weakSelf = self;
    [self.listTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getCollectionDetailHttpRequest)];
    
    // 添加上拉加载更多
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCollectionDetailHttpRequest];
    }];
    [self.listTableView.header beginRefreshing];
}
- (void)addTableHeaderView
{
    UIView *tableHeaderView = [[UIView  alloc] initWithFrame:CGRectMake(0, _headerViewHeight, ScreenWidth, 74)];
    tableHeaderView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], 5, 60, 20)];
    headerTitleLabel.text = @"项目列表";
    headerTitleLabel.textColor = UIColorWithRGB(0x333333);
    headerTitleLabel.font = [UIFont systemFontOfSize:13];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
 
    [tableHeaderView  addSubview:headerTitleLabel];
    
    self.sortButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sortButton.frame = CGRectMake(ScreenWidth - 15 - 30 , 5, 30, 20);
    _sortButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _sortButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _sortButton.titleLabel.textColor = UIColorWithRGB(0x4aa1f9);
    [_sortButton setTitle:@"排序" forState:UIControlStateNormal];
    [_sortButton addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:_sortButton];
    NSArray *titleArray = @[@"可投项目",@"已满项目"];
    _topSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titleArray];
    [_topSegmentedControl setFrame:CGRectMake(0, 30, ScreenWidth, 44)];
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
    [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:_topSegmentedControl isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_topSegmentedControl isTop:NO];
    [tableHeaderView addSubview:_topSegmentedControl];
    for (int i = 0 ; i < titleArray.count - 1 ; i++) {
        UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
        linebk.frame = CGRectMake(ScreenWidth/titleArray.count * (i + 1), 16, 1, 12);
        [_topSegmentedControl addSubview:linebk];
    }
    if (_selectIndex != 0) {
        _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    }
  [self.collectionScrollView addSubview:tableHeaderView];

}
-(void)topSegmentedControlChangedValue:(HMSegmentedControl *)control{
    _topSegmentedControl.selectedSegmentIndex = control.selectedSegmentIndex;
    _selectIndex = control.selectedSegmentIndex;
    if (_selectIndex == 0) {
        [_sortButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
        _sortButton.userInteractionEnabled = YES;
    }else{
        [_sortButton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
        _sortButton.userInteractionEnabled = NO;
    }
    [_listTableView setContentInset:UIEdgeInsetsZero];
    [_listTableView setContentOffset:CGPointZero];
    [_listTableView reloadData];
}
#pragma mark 
#pragma mark 项目详情
-(void)drawCollectionListView{
    
    self.investmentDetailDataArray  = [NSMutableArray arrayWithCapacity:0];
    UIView *listHeaderView = [[UIView  alloc] initWithFrame:CGRectMake(0, _headerViewHeight, ScreenWidth, 30)];
    listHeaderView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    [self.collectionScrollView addSubview:listHeaderView];
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 20)];
    headerTitleLabel.text = @"投资详情";
    headerTitleLabel.textColor = UIColorWithRGB(0x333333);
    headerTitleLabel.font = [UIFont systemFontOfSize:13];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
    [listHeaderView  addSubview:headerTitleLabel];
    
    UILabel *listCountLabel= [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 15 - 100 , 5, 100, 20)];
    listCountLabel.text = @"10个标";
    listCountLabel.textColor = UIColorWithRGB(0x555555);
    listCountLabel.font = [UIFont systemFontOfSize:13];
    listCountLabel.textAlignment = NSTextAlignmentRight;
    [listHeaderView  addSubview:listCountLabel];
                                                                         
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headerViewHeight + 30, ScreenWidth, ScreenHeight - 64 - 57 - 30 ) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _listTableView.tag = 1020;
    _listTableView.backgroundColor = UIColorWithRGB(0xebebee);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerNib:[UINib nibWithNibName:@"UCFCollectionListCell" bundle:nil] forCellReuseIdentifier:ListCellID];

    [self.collectionScrollView addSubview:_listTableView];
    
    
    __weak typeof(self)  weakSelf = self;
    [self.listTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getCollectionListHttpRequest)];
    
    // 添加上拉加载更多
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCollectionListHttpRequest];
    }];
    [self.listTableView.header beginRefreshing];
    
    
    
}
#pragma mark 点击排序button响应事件
-(void)clickSortButton:(UIButton *)button{
    
    DLog(@"点击了排序button事件");
    
    MjAlertView *sortAlertView = [[MjAlertView alloc]initCollectionViewWithTitle:@"项目排序" sortArray:@[@"综合排序",@"金额递增",@"金额递减"]  selectedSortButtonTag:_currentSelectSortTag delegate:self cancelButtonTitle:@"" withOtherButtonTitle:@"确定"];
    [sortAlertView show];
}
-(void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    if (clickedButton.tag != 0) {
       _currentSelectSortTag = index;
        [self.listTableView.header isRefreshing];
        [self getCollectionDetailHttpRequest];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -scrollViewScroll代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
      DLog(@"DidEndDragging .y---->>>>>%f ----tag--->>>%ld",scrollView.contentOffset.y,scrollView.tag);
    if (scrollView.tag == 1010) {
        if (scrollView.contentOffset.y <0){
            [_collectionScrollView setContentOffset:CGPointZero];
        }
        if (scrollView.contentOffset.y >_headerViewHeight) {
            [_collectionScrollView setContentOffset:CGPointMake(0, _headerViewHeight)];
        }
    }else{
        if (scrollView.contentOffset.y <= -50) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.collectionScrollView setContentOffset:CGPointZero];
            } completion:^(BOOL finished) {
               
            }];
        }
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"DidScroll .y---->>>>>%f ----tag--->>>%ld",scrollView.contentOffset.y,scrollView.tag);

    
    if (scrollView.tag == 1010) {
        if (scrollView.contentOffset.y < 0){
            [_collectionScrollView setContentOffset:CGPointZero];
        }
        if (scrollView.contentOffset.y >_headerViewHeight) {
            [_collectionScrollView setContentOffset:CGPointMake(0, _headerViewHeight)];
        }
    }else{
//        if (scrollView.contentOffset.y <= -40){
//            __weak typeof(self) weakSelf = self;
//            [UIView animateWithDuration:0.25 animations:^{
//                [weakSelf.collectionScrollView setContentOffset:CGPointZero];
//            } completion:^(BOOL finished) {
//                
//            }];
//        }
    }
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    return [self addTableHeaderView];
//    
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return 74.f;
//}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    if([_souceVC isEqualToString:@"P2PVC"]){
        if (_selectIndex == 0) {
            return _investmentProjectDataArray.count;
        }else{
            return _fullProjectDataArray.count ;
        }
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_souceVC isEqualToString:@"P2PVC"]){
        return 95;
    }else{
        return 202;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_souceVC isEqualToString:@"P2PVC"]){
        UCFCollectionDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellID];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (_selectIndex == 0) {
            NSDictionary *dataDict = [_investmentProjectDataArray objectAtIndex:indexPath.row];
            if (indexPath.row <_investmentProjectDataArray.count) {
               cell.dataDict = dataDict;
            }
        }else{
            NSDictionary *dataDict = [_fullProjectDataArray objectAtIndex:indexPath.row];
            if (indexPath.row <_fullProjectDataArray.count) {
                cell.dataDict = dataDict;
            }
        }
        return cell;
    }else{
        UCFCollectionListCell *cell = [tableView dequeueReusableCellWithIdentifier:ListCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"投资详情";
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_selectIndex == 0){
//        NSDictionary *dataDict = [self.investmentProjectDataArray objectAtIndex:indexPath.row];
//        dataDict  = @{@"userId":uuid,@"colPrdClaimId":_colPrdClaimId,@"page":currentPageStr,@"pageSize":@"20",@"prdClaimsOrder":prdClaimsOrderStr,@"status":statusStr};
//        [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagChildPrdclaimsList owner:self signature:YES];
        
    }
}
-(void)cell:(UCFCollectionDetailCell *)cell clickInvestBtn:(UIButton *)button withModel:(NSDictionary *)dataDict{
    NSString *status = [dataDict objectSafeForKey:@"status"];
    if ([status intValue] == 2) {
        NSString *idStr =[dataDict objectSafeForKey:@"id"];
        NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@", idStr,[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"目前标的详情只对投资人开放" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
//    UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对投资人开放"];
//    [self.navigationController pushViewController:controller animated:YES];
}



}

#pragma mark
#pragma mark 网络请求
-(void)getCollectionDetailHttpRequest{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *dataDict;
    if ([self.listTableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.listTableView.footer resetNoMoreData];
    }
    else if ([self.listTableView.footer isRefreshing]) {
        self.currentPage ++;
    }
    NSString *prdClaimsOrderStr = @"";
    switch (_currentSelectSortTag) {
        case 1:
            self.currentPage = 1;
            prdClaimsOrderStr = @"32";//
            break;
        case 2:
            self.currentPage = 1;
            prdClaimsOrderStr = @"31";
            break;
          
        default:
            self.currentPage = 1;
            prdClaimsOrderStr = @"00";
            break;
    }
    NSString *currentPageStr = [NSString stringWithFormat:@"%d",_currentPage];
    NSString *statusStr = [NSString stringWithFormat:@"%ld",_selectIndex];
    dataDict  = @{@"userId":uuid,@"colPrdClaimId":_colPrdClaimId,@"page":currentPageStr,@"pageSize":@"20",@"prdClaimsOrder":prdClaimsOrderStr,@"status":statusStr};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagChildPrdclaimsList owner:self signature:YES];
}
-(void)getCollectionListHttpRequest{
    
}
-(void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)endPost:(id)result tag:(NSNumber *)tag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagChildPrdclaimsList){
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
             BOOL hasNext = [[[[dic objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"hasNextPage"] boolValue];
            
    
            if (_selectIndex == 0 && self.currentPage == 1) {
                      [self.investmentProjectDataArray removeAllObjects];
                }else if (_selectIndex == 1 && self.currentPage == 1) {
                     [self.fullProjectDataArray removeAllObjects];
                }
            
            for (NSDictionary *dict in list_result)
            {
                if (_selectIndex == 0) {
                    [self.investmentProjectDataArray addObject:dict];
                }else{
                   [self.fullProjectDataArray addObject:dict];
                }
                
            }
            [self.listTableView reloadData];
            if (_selectIndex == 0) {
                if (self.investmentProjectDataArray.count > 0) {
                    //                [self.noDataView hide];
                    if (!hasNext) {
                        self.listTableView.footer.state = MJRefreshFooterStateNoMoreData;
                        [self.listTableView.footer noticeNoMoreData];
                    }else{
                        self.listTableView.footer.hidden = NO;
                    }
                }

            }else{
                if (self.fullProjectDataArray.count > 0) {
                    //                [self.noDataView hide];
                    if (!hasNext) {
                        self.listTableView.footer.state = MJRefreshFooterStateNoMoreData;
                        [self.listTableView.footer noticeNoMoreData];
                    }else{
                        self.listTableView.footer.hidden = NO;
                    }
                }

            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }else if (tag.intValue == kSXTagPrdClaimsDetail){
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        if ([rstcode intValue] == 1) {
//            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)_projectListModel.prdLabelsList];
//            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
//            CGFloat platformSubsidyExpense = [_projectListModel.platformSubsidyExpense floatValue];
//            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
//            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
    else if(tag.intValue == kSXTagPrdClaimsDealBid)
    {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
//            UCFPurchaseBidViewController *purchaseViewController = [[UCFPurchaseBidViewController alloc] initWithNibName:@"UCFPurchaseBidViewController" bundle:nil];
//            purchaseViewController.dataDict = dic;
//            purchaseViewController.bidType = 0;
//            [self.navigationController pushViewController:purchaseViewController animated:YES];
            
        }else if ([[dic objectForKey:@"status"] integerValue] == 21 || [dic[@"status"] integerValue] == 22){
//            [self checkUserCanInvest];
            
        } else {
            if ([[dic objectForKey:@"status"] integerValue] == 15) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"statusdes"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            } else if ([[dic objectForKey:@"status"] integerValue] == 19) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"statusdes"] delegate:self cancelButtonTitle:@"返回列表" otherButtonTitles: nil];
                alert.tag =7000;
                [alert show];
            } else if ([[dic objectForKey:@"status"] integerValue] == 30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"statusdes"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"测试",nil];
                alert.tag = 9000;
                [alert show];
            }
            else {
                [AuxiliaryFunc showAlertViewWithMessage:[dic objectForKey:@"statusdes"]];
            }
            
        }
    }
    
    [self.listTableView.header endRefreshing];
    [self.listTableView.footer endRefreshing];

}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag{
    
}
- (IBAction)goBackVC:(UIButton *)sender {
    if (kIS_IOS7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)ClickBatchInvestment:(UIButton *)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *strParameters = strParameters = [NSString stringWithFormat:@"userId=%@&id=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],_colPrdClaimId];//101943
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDealBid owner:self];
}
@end
