//
//  UCFCollectionDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionDetailViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
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
#import "UCFNoDataView.h"
#import "UCFCollctionKeyBidViewController.h"
#define shadeSpacingHeight 18 //遮罩label的上下间距
#define shadeHeight 70 //遮罩高度
static NSString * const DetailCellID = @"UCFCollectionDetailCell";
static NSString * const ListCellID = @"UCFCollectionListCell";
@interface UCFCollectionDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MjAlertViewDelegate,UCFCollectionDetailCellDelegare>
{
    UIImageView *_headerBgView; //上面的视图
    UIView *_tableHeaderView;//tableView上面的视图
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
    NSInteger _lastSelectSortTag;//最后一次选择排序tag
    
    UCFCollectionListViewController *_collectionListVC;//标详情页面
}
@property (weak, nonatomic) IBOutlet UIScrollView *collectionScrollView;
@property (weak, nonatomic) IBOutlet UILabel *navTitleLabel;
@property (assign, nonatomic)float headerViewHeight;
@property (strong,nonatomic) UITableView *listTableView;
@property (strong,nonatomic) UIButton *sortButton;   //排序按钮
@property (assign,nonatomic) int investmentCurrentPage; //可投项目当前页数
@property (assign,nonatomic) int fullCurrentPage; //已满项目当前页数
@property (strong,nonatomic)NSMutableArray *investmentProjectDataArray;//可投项目数组
@property (strong,nonatomic)NSMutableArray *fullProjectDataArray;//已满项目数组
@property (strong,nonatomic) UCFNoDataView *noDataView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *investmentBtnViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *investmentBtn;
@property (weak, nonatomic) IBOutlet UIImageView *shadowImageView;

- (IBAction)goBackVC:(UIButton *)sender;
- (IBAction)ClickBatchInvestment:(UIButton *)sender;


@end

@implementation UCFCollectionDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.navigationController.fd_prefersNavigationBarHidden = YES;
    [self progressAnimiation];
    [self drawTopView];
    if([self.souceVC isEqualToString:@"P2PVC"]){
         [self.collectionScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight +_headerViewHeight - 64 - 57)];
        self.collectionScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_headerViewHeight + 74, 0, 0, 0);

    }else{
         [self.collectionScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight +_headerViewHeight - 64)];
         self.collectionScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_headerViewHeight + 30, 0, 0, 0);
    }
    self.collectionScrollView.delegate = self;
    self.collectionScrollView.tag = 1010;
    self.collectionScrollView.bounces = YES;
//    self.collectionScrollView.alwaysBounceVertical = YES;
  
    
    if([_souceVC isEqualToString:@"P2PVC"]){
        [self drawBottomBgView];
    }else{
        [self drawCollectionDelitailListView];//我的投资页面的项目详情
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
    
    NSString *annualStr = [NSString stringWithFormat:@"%.1f%%",[[_detailDataDict objectSafeForKey:@"colRate"] floatValue]];
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
    if (![self.souceVC isEqualToString:@"P2PVC"]) {
        colPeriodStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"colPeriodTxt"] ];
    }
    CGSize colPeriodsize = [colPeriodStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:25]}];
    _markTimeLabel = [[NZLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(markLabel.frame) + 10,CGRectGetMaxY(markLabel.frame) - 25,colPeriodsize.width,colPeriodsize.height)];
    _markTimeLabel.text = colPeriodStr;
    _markTimeLabel.font = [UIFont systemFontOfSize:25];
    _markTimeLabel.textColor = [UIColor whiteColor];
    _markTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_markTimeLabel setFont: [UIFont systemFontOfSize:15] string:@"天"];
    [_markTimeLabel setFont: [UIFont systemFontOfSize:15] string:@"个月"];
    [_headerBgView addSubview:_markTimeLabel];
    
    NSString *colMinInvestStr = [NSString stringWithFormat:@"%@元起",[_detailDataDict objectSafeForKey:@"colMinInvest"] ];
    CGSize activitylabel1Size =[Common getStrWitdth:colMinInvestStr TextFont:[UIFont systemFontOfSize:11]];
    //最多2个标签
    _activitylabel1 = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], CGRectGetMaxY(markLabel.frame)+25, activitylabel1Size.width+10, 15) text:colMinInvestStr textColor:UIColorWithRGB(0x28335c) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel1.backgroundColor = [UIColor whiteColor];
    _activitylabel1.layer.cornerRadius = 2.0;
    _activitylabel1.layer.masksToBounds = YES;
    [_headerBgView addSubview:_activitylabel1];
    NSString *colRepayModeStr = @"";
    if ([self.souceVC isEqualToString:@"P2PVC"]) {
         colRepayModeStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"colRepayMode"] ];
    }else{
         colRepayModeStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"colRepayModeTxt"] ];
    }
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
    
    canBuyAmtStr = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod AddComma:[NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:canBuyAmtStr]]]];//可投额度
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
    
    int progressInt = (int)(Progress *100);
    if (progressInt == 0) {
        progressInt = 1;
    }
    NSString* percentageStr =[NSString stringWithFormat:@"%d%%",progressInt];

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
    
    NSString *canBuyAmtStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"canBuyAmt"]];
    NSString *totalAmtStr = [NSString stringWithFormat:@"%@",[_detailDataDict objectSafeForKey:@"totalAmt"]];
    
    Progress = ([totalAmtStr floatValue] - [canBuyAmtStr floatValue]) / [totalAmtStr floatValue];
    if (Progress > 0.98 && Progress < 1.0) {
        Progress = 0.98;
    } else if (Progress > 0.97 && Progress < 0.99) {
        Progress = 0.97;
    }
    if (Progress > 0 && Progress < 0.01) {
        Progress = 0.01;
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
#pragma mark
#pragma mark 初始化底部--即项目列表
-(void)drawCollectionDelitailListView{
    
    self.investmentBtnViewHeight.constant = 0;
    self.investmentBtn.hidden = YES;
    self.shadowImageView.hidden = YES;
    _collectionListVC = [[UCFCollectionListViewController alloc]initWithNibName:@"UCFCollectionListViewController" bundle:nil];
    _collectionListVC.view.frame = CGRectMake(0, _headerViewHeight, ScreenWidth, ScreenHeight - 64);
    _collectionListVC.souceVC = _souceVC;
    _collectionListVC.colPrdClaimId = _colPrdClaimId;
    _collectionListVC.batchOrderIdStr = _batchOrderIdStr;
    [self.collectionScrollView addSubview:_collectionListVC.view];
    [self addChildViewController:_collectionListVC];
    [_collectionListVC didMoveToParentViewController:self];
}
#pragma mark
#pragma mark 初始化底部-- 批量投标专区
-(void)drawBottomBgView{
    //初始化数组
    self.investmentBtnViewHeight.constant = 57;
    self.investmentBtn.hidden = NO;
    self.investmentProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    self.fullProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    [self addTableHeaderView];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headerViewHeight+74, ScreenWidth, ScreenHeight- 64 - 57 - 74 ) style:UITableViewStylePlain];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _listTableView.tag = 1020;
    _listTableView.backgroundColor = UIColorWithRGB(0xebebee);
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_listTableView registerNib:[UINib nibWithNibName:@"UCFCollectionDetailCell" bundle:nil] forCellReuseIdentifier:DetailCellID];
    [self.collectionScrollView addSubview:_listTableView];
    
    //添加阴影图片
    UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
    self.shadowImageView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
    self.shadowImageView.hidden = NO;
    
    __weak typeof(self)  weakSelf = self;
    [self.listTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getCollectionDetailHttpRequest)];
    
    // 添加上拉加载更多
    
    [self.listTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getCollectionDetailHttpRequest];
    }];
    [self.listTableView.header beginRefreshing];
    [self addNoDataView];
}
#pragma mark - 添加无数据页面
- (void)addNoDataView {
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64 - 57 - _headerViewHeight) errorTitle:@"暂无数据"];
}
- (void)addTableHeaderView
{
    _tableHeaderView= [[UIView  alloc] initWithFrame:CGRectMake(0, _headerViewHeight, ScreenWidth, 74)];
    _tableHeaderView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    UILabel *headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], 5, 60, 20)];
    headerTitleLabel.text = @"项目列表";
    headerTitleLabel.textColor = UIColorWithRGB(0x333333);
    headerTitleLabel.font = [UIFont systemFontOfSize:13];
    headerTitleLabel.textAlignment = NSTextAlignmentLeft;
 
    [_tableHeaderView  addSubview:headerTitleLabel];
    
    self.sortButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sortButton.frame = CGRectMake(ScreenWidth - 15 - 30 , 5, 30, 20);
    _sortButton.titleLabel.textAlignment = NSTextAlignmentRight;
    _sortButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _sortButton.titleLabel.textColor = UIColorWithRGB(0x4aa1f9);
    [_sortButton setTitle:@"排序" forState:UIControlStateNormal];
    [_sortButton addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
    [_tableHeaderView addSubview:_sortButton];
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
    [_tableHeaderView addSubview:_topSegmentedControl];
    for (int i = 0 ; i < titleArray.count - 1 ; i++) {
        UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
        linebk.frame = CGRectMake(ScreenWidth/titleArray.count * (i + 1), 16, 1, 12);
        [_topSegmentedControl addSubview:linebk];
    }
    if (_selectIndex != 0) {
        _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    }
  [self.collectionScrollView addSubview:_tableHeaderView];

}
-(void)topSegmentedControlChangedValue:(HMSegmentedControl *)control{
    _topSegmentedControl.selectedSegmentIndex = control.selectedSegmentIndex;
    _selectIndex = control.selectedSegmentIndex;
    if (_selectIndex == 0) {
        [self.fullProjectDataArray removeAllObjects];
        [_sortButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
        _sortButton.userInteractionEnabled = YES;
    }else{
        [self.investmentProjectDataArray removeAllObjects];
        [_sortButton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
        _sortButton.userInteractionEnabled = NO;
    }
    [_listTableView reloadData];
    [_listTableView.header beginRefreshing];
  
}
#pragma mark 点击排序button响应事件
-(void)clickSortButton:(UIButton *)button{
    
    DLog(@"点击了排序button事件");
    
    MjAlertView *sortAlertView = [[MjAlertView alloc]initCollectionViewWithTitle:@"项目排序" sortArray:@[@"综合排序",@"金额递增",@"金额递减"]  selectedSortButtonTag:_currentSelectSortTag delegate:self cancelButtonTitle:@"" withOtherButtonTitle:@"确定"];
    [sortAlertView show];
}
-(void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    if (clickedButton.tag != 0) {
        if(_lastSelectSortTag != index){
            _investmentCurrentPage = 1;
            _lastSelectSortTag = _currentSelectSortTag;
            _currentSelectSortTag = index;
            [self.listTableView.header beginRefreshing];
        }else{
            [self.listTableView reloadData];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -scrollViewScroll代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat y = scrollView.contentOffset.y;
    if (y < - 54) {
        if ([_souceVC isEqualToString:@"P2PVC"]) {
            [self.listTableView.header beginRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.listTableView.header endRefreshing];
            });
        }else{
            [_collectionListVC.listTableView.header beginRefreshing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionListVC.listTableView.header endRefreshing];
            });
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGFloat off_y = scrollView.contentOffset.y;
    
    if (scrollView.tag == 1010) {
        if (off_y < 0){
            
            CGRect rect =   _headerBgView.frame;
            rect.origin.y = off_y;
            _headerBgView.frame = rect;
            
            
            
            
            if ([_souceVC isEqualToString:@"P2PVC"]) {
                rect = _tableHeaderView.frame;
                rect.origin.y = off_y +_headerViewHeight;
                _tableHeaderView.frame = rect;
                
                rect = _listTableView.frame;
                rect.origin.y = off_y + _headerViewHeight+74;
                _listTableView.frame = rect;
                //偏移量给到tableview，tableview自己来滑动
                //self.listTableView.contentOffset = CGPointMake(0, off_y);
            }else{
                rect = _collectionListVC.view.frame;
                rect.origin.y = off_y + _headerViewHeight;
                _collectionListVC.view.frame = rect;
            }
            
        }else{
            
        }
    }else{
        
        
        
        
    }
}
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
    if (_selectIndex == 0) {
        NSDictionary *dataDict = [_investmentProjectDataArray objectAtIndex:indexPath.row];
        [self gotoProjectDetailVC:dataDict];
    }else{
        NSDictionary *dataDict = [_fullProjectDataArray objectAtIndex:indexPath.row];
         [self gotoProjectDetailVC:dataDict];
    }
}
-(void)cell:(UCFCollectionDetailCell *)cell clickInvestBtn:(UIButton *)button withModel:(NSDictionary *)dataDict{
    
    [self gotoProjectDetailVC:dataDict];
}
-(void)gotoProjectDetailVC:(NSDictionary *)dataDict{
    
        NSInteger isOrder = [[dataDict objectSafeForKey:@"isOrder"] integerValue];
        NSInteger status = [[dataDict objectSafeForKey:@"status"] integerValue];
        NSString *idStr =[dataDict objectSafeForKey:@"childPrdClaimId"];
        NSString *strParameters = [NSString stringWithFormat:@"id=%@&userId=%@", idStr,[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
        
        if (status != 2) {
            if (isOrder == 0) {//0可看,1不可看
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self];
            } else {
                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对投资人开放"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagPrdClaimsDetail owner:self];
        }
}

#pragma mark
#pragma mark 网络请求
-(void)getCollectionDetailHttpRequest{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSString *prdClaimsOrderStr = @"00";
    if (_selectIndex == 0) {
        if ([self.listTableView.header isRefreshing]) {
            self.investmentCurrentPage = 1;
            [self.listTableView.footer resetNoMoreData];
        }
        else if ([self.listTableView.footer isRefreshing]) {
            self.investmentCurrentPage ++;
        }
        switch (_currentSelectSortTag) {
            case 1:
                prdClaimsOrderStr = @"32";//@"金额递增"
                break;
            case 2:
                prdClaimsOrderStr = @"31";//@"金额递减"
                break;
            default:
                prdClaimsOrderStr = @"00";//@"综合排序"
                break;
        }
    }else{
        if ([self.listTableView.header isRefreshing]) {
            self.fullCurrentPage = 1;
            [self.listTableView.footer resetNoMoreData];
        }
        else if ([self.listTableView.footer isRefreshing]) {
            self.fullCurrentPage ++;
        }
    }
    NSString *currentPageStr = [NSString stringWithFormat:@"%d",_investmentCurrentPage];
    if (_selectIndex == 1) {
        currentPageStr =[NSString stringWithFormat:@"%d",_fullCurrentPage];
    }
    NSString *statusStr = [NSString stringWithFormat:@"%ld",(long)_selectIndex];
    NSDictionary *dataDict  = @{@"userId":uuid,@"colPrdClaimId":_colPrdClaimId,@"page":currentPageStr,@"pageSize":@"20",@"prdClaimsOrder":prdClaimsOrderStr,@"status":statusStr};
    [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagChildPrdclaimsList owner:self signature:YES];
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
            
    
            if (_selectIndex == 0 && self.investmentCurrentPage == 1) {
                      [self.investmentProjectDataArray removeAllObjects];
                }else if (_selectIndex == 1 && self.fullCurrentPage == 1) {
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
                   [self.noDataView hide];
                    if (!hasNext) {
                        [self.listTableView.footer noticeNoMoreData];
                    }
                } else {
                    [self.noDataView showInView:self.listTableView];
                }

            }else{
                if (self.fullProjectDataArray.count > 0) {
                    [self.noDataView hide];
                    if (!hasNext) {
                        [self.listTableView.footer noticeNoMoreData];
                    }
                }
                else {
                    [self.noDataView showInView:self.listTableView];
                }
            }
        }else {
            
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }else if (tag.intValue == kSXTagPrdClaimsDetail){
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        if ([rstcode intValue] == 1) {
            NSArray *prdLabelsListTemp = [dic objectSafeArrayForKey:@"prdLabelsList"];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dic isTransfer:NO withLabelList:prdLabelsListTemp];
//            CGFloat platformSubsidyExpense = [_projectListModel.platformSubsidyExpense floatValue];
//            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
    else if(tag.intValue == kSXTagColIntoDealBatch)
    {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSString *messageStr = [dic objectSafeForKey:@"message"];
        if([[dic objectForKey:@"ret"] boolValue])
        {
            UCFCollctionKeyBidViewController *purchaseViewController = [[UCFCollctionKeyBidViewController alloc] init];
            purchaseViewController.dataDict = [dic objectSafeDictionaryForKey:@"data"];
            purchaseViewController.bidType = 0;
            [self.navigationController pushViewController:purchaseViewController animated:YES];
        }else
        {
            [AuxiliaryFunc showAlertViewWithMessage:messageStr];
        }
    }
    if ([self.listTableView.header isRefreshing]) {
        [self.listTableView.header endRefreshing];
    }
    if ([self.listTableView.footer isRefreshing]) {
        [self.listTableView.footer endRefreshing];
    }
}
-(void)errorPost:(NSError *)err tag:(NSNumber *)tag{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([self.listTableView.header isRefreshing]) {
        [self.listTableView.header endRefreshing];
    }
    if ([self.listTableView.footer isRefreshing]) {
        [self.listTableView.footer endRefreshing];
    }
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
    NSDictionary *dataDict = @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"tenderId":_colPrdClaimId};
        [[NetworkModule sharedNetworkModule] newPostReq:dataDict tag:kSXTagColIntoDealBatch owner:self signature:YES];
}
@end
