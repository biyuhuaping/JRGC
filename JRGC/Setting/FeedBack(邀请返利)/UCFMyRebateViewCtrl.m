//
//  UCFMyRebateViewCtrl.m
//  JRGC
//
//  Created by biyuhuaping on 15/5/11.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFMyRebateViewCtrl.h"
#import "UCFRebateCell.h"//邀请返利明细
#import "UCFFriendRecCell.h"//好友未回款
#import "UCFFriendRecCell1.h"//好友已回款
#import "ReturnedMoneyCell.h"//分期回款列表
#import "NZLabel.h"
#import "UCFRegistrationRecord.h"
#import "YcArray.h"
#import "UIDic+Safe.h"
#import "UCFToolsMehod.h"
#import "UCFNoDataView.h"
#import "UCFDataStatisticsViewController.h"

@interface UCFMyRebateViewCtrl ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *itemChangeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerX;//下划线的
@property (strong, nonatomic) UILabel *totalCountLab;//记录总数

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *tableView1;
@property (strong, nonatomic) UITableView *tableView2;
@property (strong, nonatomic) UITableView *tableView3;

@property (strong, nonatomic) NSMutableArray *dataArr_1;//用来储存未便利前的原始格式数据
@property (strong, nonatomic) NSMutableArray *dataArr_2;//用来储存未便利前的原始格式数据
@property (strong, nonatomic) NSMutableArray *dataArr_3;//用来储存未便利前的原始格式数据
@property (strong, nonatomic) NSMutableArray *dataArr1;
@property (strong, nonatomic) NSMutableArray *dataArr2;
@property (strong, nonatomic) NSMutableArray *dataArr3;
@property (strong, nonatomic) NSMutableArray *monthDataArr1;
@property (strong, nonatomic) NSMutableArray *monthDataArr2;
@property (strong, nonatomic) NSMutableArray *monthDataArr3;

@property (strong, nonatomic) NSMutableArray *monthTitlArr1;//本月收益
@property (strong, nonatomic) NSMutableArray *monthTitlArr3;//本月收益

@property (strong, nonatomic) NSArray *titleArr1;
@property (strong, nonatomic) NSArray *titleArr2;

@property (assign, nonatomic) NSInteger pageNum1;
@property (assign, nonatomic) NSInteger pageNum2;
@property (assign, nonatomic) NSInteger pageNum3;

@property (assign, nonatomic) NSInteger index;//选择了第几个
@property (strong, nonatomic) NSMutableArray *didClickBtns;

@property (strong, nonatomic) IBOutlet UILabel *sumCommLab;//我的返利
@property (strong, nonatomic) IBOutlet NZLabel *friendCountLab;//邀请投资人数
@property (strong, nonatomic) IBOutlet NZLabel *recCountLab;//邀请注册人数

// 无数据界面
@property (nonatomic, strong) UCFNoDataView *noDataView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height;

//回款明细 弹出页面
@property (strong, nonatomic) IBOutlet UIView *alertView;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView4;
@property (strong, nonatomic) NSMutableArray *dataArr4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight1;
@property (strong, nonatomic) IBOutlet UILabel *nperLab;//期数
@property (strong, nonatomic) IBOutlet UILabel *investorsLab;//投资人

@end

@implementation UCFMyRebateViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"我的返利";
    
    _dataArr1 = [NSMutableArray new];
    _dataArr2 = [NSMutableArray new];
    _dataArr3 = [NSMutableArray new];
    _dataArr4 = [NSMutableArray new];
    _monthDataArr1 = [NSMutableArray array];
    _monthDataArr2 = [NSMutableArray array];//_monthDataArr1不需要在此初始化
    _monthDataArr3 = [NSMutableArray array];
    
    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;
    
    _index = 0;
    _didClickBtns = [NSMutableArray arrayWithObject:@(0)];
    
    _titleArr1 = @[@"未审核", @"等待确认", @"招标中", @"流标", @"满标", @"回款中", @"已回款"];
    _titleArr2 = @[@"已认证", @"未认证"];
    
    UIButton *btn = (UIButton *)[self.itemChangeView viewWithTag:100];
    btn.selected = YES;
    _height.constant = 0.5;
    _lineViewHeight1.constant = 0.5;
    
    [self initTableView];
    _noDataView = [[UCFNoDataView alloc] initWithFrame:_tableView1.bounds errorTitle:@"暂无数据"];
    
    
    _alertView.frame = CGRectMake(0, 0, 265, 274);
    _alertView.layer.cornerRadius = 8;

    [_closeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_closeBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [self addRightButton];
    
}

- (void)addRightButton
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 75, 44);
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightbutton setTitle:@"统计数据" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSString *gcmCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"gcmCode"];
    if ([gcmCode hasPrefix:@"A"]) {
        rightbutton.hidden = NO;
    }
    else {
        rightbutton.hidden = YES;
    }
}

- (void)clickRightBtn
{
    UCFDataStatisticsViewController *dataStatistic = [[UCFDataStatisticsViewController alloc] initWithNibName:@"UCFDataStatisticsViewController" bundle:nil];
    [self.navigationController pushViewController:dataStatistic animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    CGFloat height = ScreenHeight - 210;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*3, height);
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, height) style:UITableViewStylePlain];
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, height) style:UITableViewStylePlain];
    _tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, height) style:UITableViewStylePlain];
    
    [_scrollView addSubview:_tableView1];
    [_scrollView addSubview:_tableView2];
    [_scrollView addSubview:_tableView3];
    
    _tableView1.delegate = self;
    _tableView2.delegate = self;
    _tableView3.delegate = self;
    
    _tableView1.dataSource = self;
    _tableView2.dataSource = self;
    _tableView3.dataSource = self;
    
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView1.backgroundColor = UIColorWithRGB(0xebebee);
    _tableView2.backgroundColor = UIColorWithRGB(0xebebee);
    _tableView3.backgroundColor = UIColorWithRGB(0xebebee);
    
    // 是否支持点击状态栏回到最顶端
    _tableView1.scrollsToTop = YES;
    _tableView2.scrollsToTop = NO;
    _tableView3.scrollsToTop = NO;
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    // 添加传统的下拉刷新
//    [_tableView1 addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [weakSelf getDataList];
//    }];
//    
//    // 添加上拉加载更多
    [_tableView1 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
    [_tableView1 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataList)];
    [_tableView2 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataList)];
    [_tableView3 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataList)];

    // 马上进入刷新状态
    [_tableView1.header beginRefreshing];
    
    //=========
    // 添加传统的下拉刷新
//    [_tableView2 addLegendHeaderWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        [weakSelf getDataList];
//    }];
    
    // 添加上拉加载更多
    [_tableView2 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
    [_tableView3 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
    _tableView1.footer.hidden = YES;
    _tableView2.footer.hidden = YES;
    _tableView3.footer.hidden = YES;
}

// 选项按钮的点击事件
- (IBAction)switchBtn:(UIButton *)sender {
    CGFloat offset = ScreenWidth*(sender.tag-100);
    [self setBtnAndLine:offset];
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        [self setBtnAndLine:offset];
    }
}

//设置按钮颜色和下划线
- (void)setBtnAndLine:(NSInteger)offset{
    _index = (NSInteger)offset/ScreenWidth;
    DBLOG(@"%ld",(long)_index);
    
    switch (_index) {
        case 0:{
            _tableView1.scrollsToTop = YES;
            _tableView2.scrollsToTop = NO;
            _tableView3.scrollsToTop = NO;
        }
            break;
            
        case 1:{
            _tableView1.scrollsToTop = NO;
            _tableView2.scrollsToTop = YES;
            _tableView3.scrollsToTop = NO;
        }
            break;
        case 2:{
            _tableView1.scrollsToTop = NO;
            _tableView2.scrollsToTop = NO;
            _tableView3.scrollsToTop = YES;
        }
            break;
    }
    
    //滑动下划线
    [UIView animateWithDuration:0.25 animations:^{
        _centerX.constant = _index*ScreenWidth/3;
        [self.view layoutIfNeeded];  //没有此句可能没有动画效果
    }];
    
    //设置按钮颜色
    for (UIButton *btn in self.itemChangeView.subviews) {
        if (btn.tag == 100 + _index) {
            btn.selected = YES;
        }else if ([btn respondsToSelector:@selector(setSelected:)])
            btn.selected = NO;
    }
    if (![_didClickBtns containsObject:@(_index)]) {
        [_didClickBtns addObject:@(_index)];
        switch (_index) {
            case 0:{
                [_tableView1.header beginRefreshing];
            }break;
            case 1:{
                [_tableView2.header beginRefreshing];
            }break;
            case 2:{
                [_tableView3.header beginRefreshing];
            }break;
        }
    }else{
        [self setNoDataView];
    }
}

- (void)setNoDataView{
    switch (_index) {
        case 0:{
            if (_dataArr1.count == 0) {
                [_noDataView showInView:_tableView1];
                [_tableView1.footer noticeNoMoreData];
            }
            else {
                [self.noDataView hide];
            }
        }
            break;
        case 1:{
            if (_dataArr2.count == 0) {
                [_noDataView showInView:_tableView2];
                [_tableView2.footer noticeNoMoreData];
            }
            else {
                [self.noDataView hide];
            }
        }
            break;
        case 2:{
            if (_dataArr3.count == 0) {
                [_noDataView showInView:_tableView3];
                [_tableView3.footer noticeNoMoreData];
            }
            else {
                [self.noDataView hide];
            }
        }
    }
}

- (IBAction)toUCFRegistrationRecordView:(id)sender {
    //邀请记录
    UCFRegistrationRecord *vc = [[UCFRegistrationRecord alloc]initWithNibName:@"UCFRegistrationRecord" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
// tableview的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView1) {
        return _dataArr1.count;
    }else if (tableView == _tableView2){
        return _dataArr2.count;
    }else if (tableView == _tableView3){
        return _dataArr3.count;
    }else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView4) {
        return 0;
    }
    return 30;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // 1.创建头部控件
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    UILabel *left = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 30)];
    left.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:left];
    
    UILabel *right = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 15 - 150, 0, 150, 30)];
    right.font = [UIFont systemFontOfSize:12];
    right.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:right];
    
    if (tableView == _tableView1) {
        NSString *t = [_monthDataArr1 objectSafeAtIndex:section];
        left.text = [[t stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
        NSString *commission = @"0";//[[_monthTitlArr1 objectSafeAtIndex:section] objectSafeForKey:@"commission"];
        for (NSDictionary *dic in _monthTitlArr1) {
            if ([dic[@"transactionTime"] isEqualToString:t]) {
                commission = [dic objectSafeForKey:@"commission"];
            }
        }
        right.text = [NSString stringWithFormat:@"本月收益¥%@",commission];
    }else if (tableView == _tableView2) {
        left.text = [[[[_monthDataArr2 objectSafeAtIndex:section]objectSafeForKey:@"repayPerDate"] stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
        right.text = [NSString stringWithFormat:@"本月共%@笔回款",[_monthDataArr2 objectSafeAtIndex:section][@"counts"]];
    }else if (tableView == _tableView3) {
        NSString *t = [_monthDataArr3 objectSafeAtIndex:section];
        left.text = [[t stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
        NSString *commission = @"0";
        for (NSDictionary *dic in _monthTitlArr3) {
            if ([dic[@"repayPerDate"] isEqualToString:t]) {
                commission = [dic objectSafeForKey:@"counts"];
            }
        }
        right.text = [NSString stringWithFormat:@"本月共%@笔回款",commission];
    }
    return headerView;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section == _dataArr1.count-1) {
//        return nil;
//    }
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
//    footerView.backgroundColor = UIColorWithRGB(0xE6E6EA);
//    return footerView;
//}

//每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return [_dataArr1[section] count];
    }else if (tableView == _tableView2){
        return [_dataArr2[section] count];
    }else if (tableView == _tableView3){
        return [_dataArr3[section] count];
    } else if (tableView == _tableView4){
        return _dataArr4.count;
    }
    return 0;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
        NSDictionary * dic = _dataArr1[indexPath.section][indexPath.row];
        float tableViewRowHeight = 0;
        if (indexPath.row == [_dataArr1[indexPath.section] count] - 1 && indexPath.section != _dataArr1.count - 1) {
            tableViewRowHeight = 299;
        }else{
            tableViewRowHeight = 289;
        }
        
        //判断好友返利是否为0.0
        if ([dic[@"lenderCommission"] floatValue] <= 0) {
            tableViewRowHeight -= 28;
        }
        //判断是否有实际回款日期
        if (![dic[@"paidTime"] hasPrefix:@"20"]) {
            tableViewRowHeight -= 28;
        }
        return tableViewRowHeight;
    }else if (tableView == _tableView2){
        if (indexPath.row == [_dataArr2[indexPath.section] count]- 1) {
            return 145;
        }
        return 135;
    }else if (tableView == _tableView3){
        if (indexPath.row == [_dataArr3[indexPath.section] count]- 1) {
            return 175;
        }
        return 165;
    }else if (tableView == _tableView4){
        return 33;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView1) {//邀请返利明细列表
        static  NSString *indentifier = @"UCFRebateCell";
        UCFRebateCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UCFRebateCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSDictionary * dic = _dataArr1[indexPath.section][indexPath.row];
        id status = dic[@"status"];
        cell.title1.text = dic[@"prdClaimsName"];//标名称
        
        int count = [dic[@"count"]intValue];//总几期
        if (count > 1) {
            NSString *repayperno = dic[@"repayperno"];//第几期
            NSString *string = [NSString stringWithFormat:@"(第%@期/共%d期)",repayperno,count];
            cell.title2.text = [NSString stringWithFormat:@"计划回款日%@",string];//回款日
            [cell.title2 setFontColor:UIColorWithRGB(0x999999) string:string];
            cell.imag.hidden = NO;
        }else{
            cell.title2.text = @"计划回款日";
            cell.imag.hidden = YES;
        }
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectReply:)];
        [cell.imag addGestureRecognizer:tap];
        
        cell.title_1.text = _titleArr1[[status intValue]];
        cell.title_2.text = dic[@"applyName"];//投资人
        cell.title_3.text = dic[@"applyDateStr"];//投资日期
        cell.title_4.text = [NSString stringWithFormat:@"%@",dic[@"investAmt"]];//投资本金
        
        
        float tableViewRowHeight = 278;
        //判断好友返利是否为0.0
        if([dic[@"lenderCommission"] floatValue] > 0 ){
            cell.friendRebateViewHeight.constant = 28;
            cell.title_5.text = [NSString stringWithFormat:@"¥%@",dic[@"lenderCommission"]];//好友返利
        }else{
            tableViewRowHeight -= 28;
            cell.friendRebateViewHeight.constant = 0;
        }
        
        //判断是否有实际回款日期
        if (![dic[@"paidTime"] hasPrefix:@"20"]) {
            tableViewRowHeight -= 28;
            cell.paidTimeViewHeight.constant = 0;
        }else{
            cell.paidTimeViewHeight.constant = 28;
            cell.paidTimeLab.text = dic[@"paidTime"];
        }
        cell.cellUpBigViewHight.constant = tableViewRowHeight;
        
        
        cell.title_6.text = [NSString stringWithFormat:@"¥%@",dic[@"totalCommission"]]; //我的返利
        NSString *qxdate = [dic objectSafeForKey: @"qxdate"];
        cell.title_7.text = qxdate.length > 0 ? qxdate :@"--" ;//起息日期
        cell.title_8.text = [dic[@"repaydate"] length] > 0 ? dic[@"repaydate"]:@"--";//回款日

        cell.lab1.text = [NSString stringWithFormat:@"%@",dic[@"arate"]];//15%
        if ([dic[@"holdTime"]length] > 0) {
            cell.lab2.text = [NSString stringWithFormat:@"%@~%@",dic[@"holdTime"],dic[@"repayPeriodtext"]];//投资期限
        }else{
            cell.lab2.text = dic[@"repayPeriodtext"];//30天
        }
        cell.lab3.text = dic[@"repayModetext"];//一次结清
        
        if ([[dic objectSafeForKey:@"arate"] isEqualToString:@""]) {
            cell.title1TopConstraint.constant = 28;
        }else{
            cell.title1TopConstraint.constant = 21;
        }
        if ([cell.title_1.text isEqualToString:@"回款中"]) {
            cell.title_1.textColor = UIColorWithRGB(0x4aa1f9);
        } else if ([cell.title_1.text isEqualToString:@"招标中"]){
            cell.title_1.textColor = UIColorWithRGB(0xF9333C);//那种红
        } else if ([cell.title_1.text isEqualToString:@"满标"]){
            cell.title_1.textColor = UIColorWithRGB(0xfa4d4c);
        } else{
            cell.title_1.textColor = UIColorWithRGB(0x999999);
        }
        return cell;
    }else if (tableView == _tableView2){//好友未回款列表
        static  NSString *indentifier = @"FriendRecCell";
        UCFFriendRecCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UCFFriendRecCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lab1.text = _dataArr2[indexPath.section][indexPath.row][@"realName"];//姓名
        cell.lab2.text = _dataArr2[indexPath.section][indexPath.row][@"mobile"];//手机号
        cell.lab3.text = _dataArr2[indexPath.section][indexPath.row][@"repayPerDate"];//计划回款日
        cell.lab4.text = [NSString stringWithFormat:@"¥%@",_dataArr2[indexPath.section][indexPath.row][@"refundAmt"]];//回款金额
        return cell;
    }else if (tableView == _tableView3){//好友已回款列表
        static  NSString *indentifier = @"FriendRecCell1";
        UCFFriendRecCell1 *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UCFFriendRecCell1" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lab1.text = _dataArr3[indexPath.section][indexPath.row][@"realName"];//姓名
        cell.lab2.text = _dataArr3[indexPath.section][indexPath.row][@"mobile"];//手机号
        cell.lab3.text = _dataArr3[indexPath.section][indexPath.row][@"repayPerDate"];//计划回款日
        cell.lab4.text = _dataArr3[indexPath.section][indexPath.row][@"paidTime"];//实际回款日
        cell.lab5.text = [NSString stringWithFormat:@"¥%@",_dataArr3[indexPath.section][indexPath.row][@"refundAmt"]];//回款金额
        return cell;
    }else if (tableView == _tableView4){//分期回款列表
        static  NSString *indentifier = @"ReturnedMoneyCell";
        ReturnedMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"ReturnedMoneyCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lab1.text = _dataArr4[indexPath.row][@"repaydate"];//回款日
        cell.lab2.text = [NSString stringWithFormat:@"第%@期",_dataArr4[indexPath.row][@"repayperno"]];//第几期
        
        NSString *status = _dataArr4[indexPath.row][@"status"];//回款状态
        if ([status isEqualToString:@"0"]) {//0未还 1已还
            cell.lab3.text = @"未还";
            [cell.lab3 setTextColor:UIColorWithRGB(0xfd4d4c)];
        }else{
            cell.lab3.text = @"已还";
            [cell.lab3 setTextColor:UIColorWithRGB(0x4aa1f9)];
        }
        
        return cell;
    }
    return nil;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//点击回款日明细方法
- (void)didSelectReply:(UITapGestureRecognizer *)sender{
    [self showAlertView];
    NSIndexPath *indexPath = [_tableView1 indexPathForRowAtPoint:[sender locationInView:_tableView1]];
    DBLOG(@"响应手势:%@",_dataArr1[indexPath.section][indexPath.row]);
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&odrclaimsid=%@",userId,_dataArr1[indexPath.section][indexPath.row][@"id"]];//5644
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kAppQueryByManyList owner:self];
}

#pragma mark - 请求网络及回调
//获取我的投资列表
- (void)getDataList
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    switch (_index) {
        case 0://（邀请返利-邀请投资明细）
        {
            if (_tableView1.header.isRefreshing) {
                _pageNum1 = 1;
            }else if (_tableView1.footer.isRefreshing){
                _pageNum1 ++;
            }
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%ld&rows=20",userId, (long)_pageNum1];//@"1674"(long)pageNum
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFriendsList owner:self];
        }
            break;
            
        case 1://（邀请返利-好友未回款）
        {
            if (_tableView2.header.isRefreshing) {
                _pageNum2 = 1;
            }else if (_tableView2.footer.isRefreshing){
                _pageNum2 ++;
            }
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%ld&rows=20&status=0",userId, (long)_pageNum2];//5644
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSRecommendRefund owner:self];
        }
            break;
        case 2://（邀请返利-好友已回款）
        {
            if (_tableView3.header.isRefreshing) {
                _pageNum3 = 1;
            }else if (_tableView3.footer.isRefreshing){
                _pageNum3 ++;
            }
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%ld&rows=20&status=1",userId, (long)_pageNum3];//5644
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSRecommendRefund owner:self];
        }
            break;
    }
}

//开始请求
- (void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    DBLOG(@"我的返利页：%@",dic);
    NSArray *tempArr = dic[@"pageData"][@"result"];

    if (tag.intValue == kAppQueryByManyList){
        _nperLab.text = [NSString stringWithFormat:@"第%@期/共%@期",dic[@"datasizepre"],dic[@"datasize"]];//期数
        _investorsLab.text = [NSString stringWithFormat:@"投资人：%@",dic[@"realname"]];//投资人
        _dataArr4 = [[NSMutableArray alloc]initWithArray:dic[@"reslist"]];
        [_tableView4 reloadData];
        if (_dataArr4.count <= 3) {
            _alertView.frame = CGRectMake(0, 0, 265, 274);
        }else
            _alertView.frame = CGRectMake(0, 0, 265, 373);
        _alertView.center = self.view.center;
    }
    //（邀请返利-邀请投资明细）
    else if (tag.intValue == kSXTagFriendsList) {
        NSString *sumComm = dic[@"sumComm"];
        NSString *friendCount = dic[@"friendCount"];
        NSString *recCount = dic[@"recCount"];
        if (!sumComm || [sumComm isKindOfClass:[NSNull class]]) {
            sumComm = @"";
        }else if(!friendCount || [friendCount isKindOfClass:[NSNull class]]){
            friendCount = @"";
        }else if (!recCount || [recCount isKindOfClass:[NSNull class]]){
            recCount = @"";
        }
        sumComm = [UCFToolsMehod AddComma:dic[@"sumComm"]];
        _totalCountLab.text = [NSString stringWithFormat:@"共%@笔回款记录",[[[dic objectSafeForKey:@"pageData"] objectSafeForKey:@"pagination"]objectSafeForKey:@"totalCount"]];
        _sumCommLab.text = [NSString stringWithFormat:@"¥%@",sumComm];//我的返利
        _friendCountLab.text = [NSString stringWithFormat:@"邀请投资人数:%@人",friendCount];//邀请投资人数
        _recCountLab.text = [NSString stringWithFormat:@"邀请注册人数:%@人",recCount];//邀请注册人数
        
        if (_headerInfoBlock) {
            _headerInfoBlock(@{@"sumComm":sumComm,@"friendCount":friendCount,@"recCount":recCount});
        }
        
        _tableView1.footer.hidden = NO;
        if ([rstcode intValue] == 1) {
            _monthTitlArr1 = [NSMutableArray arrayWithArray:dic[@"monthDataList"]];
            if (_pageNum1 == 1) {
//                _monthDataArr1 = [NSMutableArray arrayWithArray:dic[@"monthDataList"]];
                _dataArr_1 = [NSMutableArray arrayWithArray:tempArr];
                [_tableView1.header endRefreshing];
                [_tableView1.footer endRefreshing];
            }else{
                if ([tempArr count] == 0) {
                    [_tableView1.footer noticeNoMoreData];
                }else{
//                    [_monthDataArr1 addObjectsFromArray:dic[@"monthDataList"]];
                    [_dataArr_1 addObjectsFromArray:tempArr];
                    [_tableView1.footer endRefreshing];
                }
            }
            [self getFormatData1];
            [_tableView1 reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [self endRefreshing];
        }
    }
    
    //（邀请返利-好友未回款）
    else if (_index == 1) {
        _tableView2.footer.hidden = NO;
        if ([rstcode intValue] == 1) {
            if (_pageNum2 == 1) {
                _monthDataArr2 = [NSMutableArray arrayWithArray:dic[@"monthlist"]];
                _dataArr_2 = [NSMutableArray arrayWithArray:tempArr];
                [_tableView2.header endRefreshing];
                [_tableView2.footer endRefreshing];
            }else{
                if (tempArr.count == 0) {
                    [_tableView2.footer noticeNoMoreData];
                }else{
                    [_dataArr_2 addObjectsFromArray:tempArr];
                    [_tableView2.footer endRefreshing];
                }
            }
            [self getFormatData2];
            [_tableView2 reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [self endRefreshing];
        }
    }
    
    //（邀请返利-好友已回款）
    else if (_index == 2) {
        _tableView3.footer.hidden = NO;
        if ([rstcode intValue] == 1) {
            _monthTitlArr3 = [NSMutableArray arrayWithArray:dic[@"monthlist"]];
            if (_pageNum3 == 1) {
                _dataArr_3 = [NSMutableArray arrayWithArray:tempArr];
                [_tableView3.header endRefreshing];
                [_tableView3.footer endRefreshing];
            }else{
                if (tempArr.count == 0) {
                    [_tableView3.footer noticeNoMoreData];
                }else{
                    [_dataArr_3 addObjectsFromArray:tempArr];
                    [_tableView3.footer endRefreshing];
                }
            }
            [self getFormatData3];
            [_tableView3 reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            [self endRefreshing];
        }
    }

    [self setNoDataView];
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self endRefreshing];
    [self setNoDataView];
}

- (void)endRefreshing{
    [_tableView1.header endRefreshing];
    [_tableView1.footer endRefreshing];
    
    [_tableView2.header endRefreshing];
    [_tableView2.footer endRefreshing];
    
    [_tableView3.header endRefreshing];
    [_tableView3.footer endRefreshing];
}

#pragma mark - 其他
- (void)getFormatData1{
    if (_dataArr_1.count == 0) {
        return;
    }
    if (_pageNum1 == 1) {
        [_monthDataArr1 removeAllObjects];
    }
    //取出分组个数/分组关键字
    for (int i = 0; i < _dataArr_1.count; i++) {
        NSString *dateStr = [_dataArr_1[i][@"applyDate"]substringToIndex:7];
        if (![_monthDataArr1 containsObject:dateStr]) {
            [_monthDataArr1 addObject:dateStr];
        }
    }
    
    //把同年月的归到一组
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _monthDataArr1.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < _dataArr_1.count; j++) {
            NSString *dateStr = [_dataArr_1[j][@"applyDate"]substringToIndex:7];
            if ([_monthDataArr1[i] isEqualToString:dateStr]) {
                [arr addObject:_dataArr_1[j]];
            }
        }
        if (arr.count > 0) {
            [dataArray addObject:arr];
        }
    }
    _dataArr1 = [NSMutableArray arrayWithArray:dataArray];
}

- (void)getFormatData2{
    if (_dataArr_2.count == 0) {
        return;
    }
    
    //把同年月的归到一组
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _monthDataArr2.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        NSString *str = _monthDataArr2[i][@"repayPerDate"];
        for (int j = 0; j < _dataArr_2.count; j++) {
            NSString *dateStr = [_dataArr_2[j][@"repayPerDate"]substringToIndex:7];
            if ([str isEqualToString:dateStr]) {
                [arr addObject:_dataArr_2[j]];
            }
        }
        [dataArray addObject:arr];
    }
    _dataArr2 = [NSMutableArray arrayWithArray:dataArray];
}

- (void)getFormatData3{
    if (_dataArr_3.count == 0) {
        return;
    }
    if (_pageNum3 == 1) {
        [_monthDataArr3 removeAllObjects];
    }
    //取出分组个数/分组关键字
    for (int i = 0; i < _dataArr_3.count; i++) {
        NSString *dateStr = [_dataArr_3[i][@"paidTime"]substringToIndex:7];
        if (![_monthDataArr3 containsObject:dateStr]) {
            [_monthDataArr3 addObject:dateStr];
        }
    }
    //把同年月的归到一组
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _monthDataArr3.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < _dataArr_3.count; j++) {
            NSString *dateStr = [_dataArr_3[j][@"paidTime"]substringToIndex:7];
            if ([_monthDataArr3[i] isEqualToString:dateStr]) {
                [arr addObject:_dataArr_3[j]];
            }
        }
        if (arr.count > 0) {
            [dataArray addObject:arr];
        }
    }
    _dataArr3 = [NSMutableArray arrayWithArray:dataArray];
}

#pragma mark - 弹出视图
//展示视图
- (void)showAlertView{
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view.window addSubview:backgroundView];
    [self.view.window addSubview:_alertView];
    _alertView.center = self.view.center;
//    self.view.window.windowLevel = 1;
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:popAnimation forKey:nil];
}

//隐藏视图
- (IBAction)hideAlertAction:(id)sender {
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_alertView.layer addAnimation:hideAnimation forKey:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_alertView removeFromSuperview];
        NSArray *array = self.view.window.subviews;
        [[array lastObject] removeFromSuperview];
    });
}


@end
