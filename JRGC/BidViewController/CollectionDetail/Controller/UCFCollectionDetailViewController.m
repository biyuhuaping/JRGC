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
#define shadeSpacingHeight 18 //遮罩label的上下间距
#define shadeHeight 70 //遮罩高度
static NSString * const DetailCellID = @"UCFCollectionDetailCell";
static NSString * const ListCellID = @"UCFCollectionListCell";
@interface UCFCollectionDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MjAlertViewDelegate>
{
    UIImageView *_headerBgView; //上面的视图
    MDRadialProgressView *_circleProgress;
    SDLoopProgressView *proressView;
    UIView *bottomBkView;//下部view
    UILabel *_remainMoneyLabel;//剩多少标
    UILabel *_totalMoneyLabel;//总多少表
    UILabel *_subsidizedInterestLabel;//补贴利息
    UILabel *_annualEarningsLabel;//年化收益
    UILabel *_markTimeLabel;//标时长
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
    [self.collectionScrollView setContentSize:CGSizeMake(ScreenWidth, ScreenHeight + _headerViewHeight - 64 - 57 )];
    self.collectionScrollView.delegate = self;
    self.collectionScrollView.tag = 1010;
    
   
  
   
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
    [self.collectionScrollView addSubview:_headerBgView];
    
    
    CGFloat stringWidth = [@"年化收益" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}].width;
    
    //顶部年化收益 投资期限
    UILabel *annualLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],0 + [Common calculateNewSizeBaseMachine:20],0,11) text:@"年化收益" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headerBgView addSubview:annualLabel];
    
    CGRect annualLabelFrame = annualLabel.frame;
    annualLabelFrame.size.width = stringWidth;
    annualLabel.frame = annualLabelFrame;
    
    _annualEarningsLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(annualLabel.frame) + 10,CGRectGetMaxY(annualLabel.frame) - 23,10,35) text:@"10" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:25]];
    _annualEarningsLabel.textAlignment = NSTextAlignmentLeft;
    [_headerBgView addSubview:_annualEarningsLabel];
    
    _subsidizedInterestLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(_annualEarningsLabel.frame),annualLabel.frame.origin.y,10,15) text:@"%" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    _subsidizedInterestLabel.textAlignment = NSTextAlignmentLeft;
    [_headerBgView addSubview:_subsidizedInterestLabel];
    
    
    
    UILabel *markLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],0 + CGRectGetMaxY(annualLabel.frame)+30,0,11) text:@"投资期限" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headerBgView addSubview:markLabel];
    
    CGRect markLabelFrame = markLabel.frame;
    markLabelFrame.size.width = stringWidth;
    markLabel.frame = markLabelFrame;
    
    _markTimeLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(markLabel.frame) + 10,0 + CGRectGetMaxY(annualLabel.frame)+ 30,170,15) text:@"60天" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
    _markTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_headerBgView addSubview:_markTimeLabel];
    
    
    CGFloat activitylabelTitleWidth1 = [@"100元" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}].width;
    //最多2个标签
    _activitylabel1 = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15], CGRectGetMaxY(markLabel.frame)+25, activitylabelTitleWidth1+10, 15) text:@"100元" textColor:UIColorWithRGB(0x28335c) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel1.backgroundColor = [UIColor whiteColor];
//    _activitylabel1.layer.borderWidth = 0.5;
    _activitylabel1.layer.cornerRadius = 2.0;
    _activitylabel1.layer.masksToBounds = YES;
//    _activitylabel1.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [_headerBgView addSubview:_activitylabel1];
    
    CGFloat activitylabelTitleWidth2 = [@"一次结清" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}].width;
    _activitylabel2 = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(_activitylabel1.frame)+15, CGRectGetMaxY(markLabel.frame)+25, activitylabelTitleWidth2+10, 15) text:@"一次结清" textColor:UIColorWithRGB(0x28335c) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel2.backgroundColor = [UIColor whiteColor];
//    _activitylabel2.layer.borderWidth = 0.5;
    _activitylabel2.layer.cornerRadius = 2.0;
    _activitylabel2.layer.masksToBounds = YES;
//    _activitylabel2.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
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
    _remainMoneyLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(remainLabel.frame) + 10,remainLabel.frame.origin.y - 1,150,14) text:@"10000" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
    _remainMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [_headerBgView addSubview:_remainMoneyLabel];
    
    UILabel *totalLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],[Common calculateNewSizeBaseMachine:207] - [Common calculateNewSizeBaseMachine:shadeSpacingHeight] - 12,0,12) text:@"可投项目" textColor:UIColorWithRGB(0x7e96c4) font:[UIFont systemFontOfSize:11]];
    [_headerBgView addSubview:totalLabel];
    CGRect totalLabelFrame = totalLabel.frame;
    totalLabelFrame.size.width = stringWidth;
    totalLabel.frame = totalLabelFrame;
    
    _totalMoneyLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame) + 10,totalLabel.frame.origin.y - 1,150,14) text:@"23个" textColor:UIColorWithRGB(0x7e96c4) font:[UIFont systemFontOfSize:14]];
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
    
}
- (void)setProcessViewProcess:(CGFloat)process
{
    proressView.progress = process;
}
#pragma mark 设置进度条的动画
- (void)progressAnimiation
{
    double borrowAmount = 100;
    double completeLoan = 70 ;
 
//    borrowAmount = [[[_dataDic objectForKey:@"prdClaims"] objectForKey:@"borrowAmount"] doubleValue];
//    completeLoan = [[[_dataDic objectForKey:@"prdClaims"] objectForKey:@"completeLoan"] doubleValue];
    Progress = completeLoan / borrowAmount;
  
    if (Progress > 0.98 && Progress < 1.0) {
        Progress = 0.98;
    } else if (Progress > 0.97 && Progress < 0.98) {
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
#pragma mark
#pragma mark 初始化底部--即项目列表
-(void)drawBottomBgView{
    //初始化数组
    self.investmentProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    self.fullProjectDataArray = [NSMutableArray arrayWithCapacity:0];
    [self addTableHeaderView];
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _headerViewHeight+74, ScreenWidth, ScreenHeight - 64 - 57 - 74) style:UITableViewStylePlain];
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
    self.listTableView.footer.hidden = YES;
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
    self.listTableView.footer.hidden = YES;
    [self.listTableView.header beginRefreshing];
    
    
    
}
#pragma mark 点击排序button响应事件
-(void)clickSortButton:(UIButton *)button{
    
    DLog(@"点击了排序button事件");
    
    MjAlertView *sortAlertView = [[MjAlertView alloc]initCollectionViewWithTitle:@"项目排序" sortArray:@[@"综合排序",@"金额递增",@"金额递减"]  selectedSortButtonTag:_currentSelectSortTag delegate:self cancelButtonTitle:@"" withOtherButtonTitle:@"确定"];
    [sortAlertView show];
}
-(void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index{
    
    _currentSelectSortTag = index;
    
    
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
        if (scrollView.contentOffset.y <= -50) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf.collectionScrollView setContentOffset:CGPointZero];
            } completion:^(BOOL finished) {
                
            }];
        }
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_selectIndex == 0) {
            cell.textLabel.text = @"我要投资了";
        }else{
            cell.textLabel.text = @"投资已满了明天再来吧";
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
}

#pragma mark
#pragma mark 网络请求
-(void)getCollectionDetailHttpRequest{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]valueForKey:UUID];
    NSDictionary *strParameters;
    if ([self.listTableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.listTableView.footer resetNoMoreData];
    }
    else if ([self.listTableView.footer isRefreshing]) {
        self.currentPage ++;
    }
    if (uuid) {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:uuid,@"userId", [NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"11", @"type", nil];
    }
    else {
        strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld", (long)self.currentPage], @"page", @"20", @"pageSize", @"11", @"type", nil];
    }
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagProjectList owner:self signature:YES];
}
-(void)getCollectionListHttpRequest{
    
}
-(void)beginPost:(kSXTag)tag{
    
}
-(void)endPost:(id)result tag:(NSNumber *)tag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagProjectList) {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode intValue] == 1) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            
            if ([self.listTableView.header isRefreshing]) {
                [self.investmentProjectDataArray removeAllObjects];
            }
            for (NSDictionary *dict in list_result) {
                //                DBLOG(@"%@", dict);
//                UCFProjectListModel *model = [UCFProjectListModel projectListWithDict:dict];
//                model.isAnim = YES;
                [self.investmentProjectDataArray addObject:dict];
            }
            
            [self.listTableView reloadData];
            
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
            
            if (self.investmentProjectDataArray.count > 0) {
//                [self.noDataView hide];
                if (!hasNext) {
                    [self.listTableView.footer noticeNoMoreData];
                }else{
                    self.listTableView.footer.hidden = NO;
                }
            }
            else {
//                [self.noDataView showInView:self.tableview];
            }
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
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
}
@end
