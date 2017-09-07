//
//  UCFGoldMyRebateViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/9/5.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldMyRebateViewController.h"
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
#import "UCFRebateGoldCell.h"
#import "UCFGoldRebateCell.h"
@interface UCFGoldMyRebateViewController ()<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
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
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight1;
@property (weak, nonatomic) IBOutlet UIButton *feedBackDetailLab; //邀请返利明细
@property (weak, nonatomic) IBOutlet UIButton *friendUnFeedBackLab;//好友未回款
@property (weak, nonatomic) IBOutlet UIButton *friendFeedBackLab;//好友已回款
@property (weak, nonatomic) IBOutlet UIView *moveLineView;

@end

@implementation UCFGoldMyRebateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];

    baseTitleLabel.text = @"黄金邀请返利";
    [_friendUnFeedBackLab setTitle:@"好友未回金" forState:UIControlStateNormal];
    [_friendFeedBackLab setTitle:@"好友已回金" forState:UIControlStateNormal];
    _friendCountLab.text = [NSString stringWithFormat:@"邀请购买人数:%@人",_feedBackDictionary[@"friendCount"]];
    _sumCommLab.text = [NSString stringWithFormat:@"¥%@",_feedBackDictionary[@"sumComm"]];
    _recCountLab.text = [NSString stringWithFormat:@"邀请注册人数：%@人",_feedBackDictionary[@"recCount"]];
    [_feedBackDetailLab setTitleColor:UIColorWithRGB(0xfc8f0e) forState:UIControlStateSelected];
    [_friendUnFeedBackLab setTitleColor:UIColorWithRGB(0xfc8f0e) forState:UIControlStateSelected];
    [_friendFeedBackLab setTitleColor:UIColorWithRGB(0xfc8f0e) forState:UIControlStateSelected];
    [_feedBackDetailLab setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_friendUnFeedBackLab setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_friendFeedBackLab setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    _moveLineView.backgroundColor = UIColorWithRGB(0xfc8f0e);
        

    _dataArr1 = [NSMutableArray new];
    _dataArr2 = [NSMutableArray new];
    _dataArr3 = [NSMutableArray new];
    _monthDataArr1 = [NSMutableArray array];
    _monthDataArr2 = [NSMutableArray array];//_monthDataArr1不需要在此初始化
    _monthDataArr3 = [NSMutableArray array];
    
    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;
    
    _index = 0;
    _didClickBtns = [NSMutableArray arrayWithObject:@(0)];
    
    _titleArr1 = @[@"认购中", @"满标", @"回金中", @"已回金"];

    _titleArr2 = @[@"已认证", @"未认证"];
    
    UIButton *btn = (UIButton *)[self.itemChangeView viewWithTag:100];
    btn.selected = YES;
    _height.constant = 0.5;
    _lineViewHeight1.constant = 0.5;
    
    [self initTableView];
    _noDataView = [[UCFNoDataView alloc] initWithFrame:_tableView1.bounds errorTitle:@"暂无数据"];
    
    

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
    //    // 添加上拉加载更多
    [_tableView1 addLegendFooterWithRefreshingBlock:^{
        [weakSelf getDataList];
    }];
    [_tableView1 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataList)];
    [_tableView2 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataList)];
    [_tableView3 addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataList)];
    
    // 马上进入刷新状态
    [_tableView1.header beginRefreshing];

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
        } else if ([btn respondsToSelector:@selector(setSelected:)]) {
            btn.selected = NO;
        }
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
        if (self.accoutType == SelectAccoutTypeGold) {
            NSString *t = [_monthDataArr1 objectSafeAtIndex:section];
            left.text = [[t stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
            NSString *commission = @"0";//[[_monthTitlArr1 objectSafeAtIndex:section] objectSafeForKey:@"commission"];
            for (NSDictionary *dic in _monthTitlArr1) {
                if ([dic[@"transactionTime"] isEqualToString:t]) {
                    commission = [dic objectSafeForKey:@"commission"];
                }
            }
            right.text = [NSString stringWithFormat:@"本月收益%@",commission];
        }
        
    }else if (tableView == _tableView2) {
        left.text = [[[[_monthDataArr2 objectSafeAtIndex:section]objectSafeForKey:@"repayPerDate"] stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
        NSString *headStr = @"";
        headStr = [NSString stringWithFormat:@"本月共%@笔回金",[_monthDataArr2 objectSafeAtIndex:section][@"counts"]];
        right.text = headStr;
    }else if (tableView == _tableView3) {
        NSString *t = [_monthDataArr3 objectSafeAtIndex:section];
        left.text = [[t stringByReplacingOccurrencesOfString:@"-" withString:@"年"] stringByAppendingString:@"月"];
        NSString *commission = @"0";
        for (NSDictionary *dic in _monthTitlArr3) {
            if ([dic[@"repayPerDate"] isEqualToString:t]) {
                commission = [dic objectSafeForKey:@"counts"];
            }
        }
        NSString *headStr = @"";
        headStr = [NSString stringWithFormat:@"本月共%@笔回金",commission];
        right.text = headStr;
    }
    return headerView;
}

//每组几行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView1) {
        return [_dataArr1[section] count];
    }else if (tableView == _tableView2){
        return [_dataArr2[section] count];
    }else if (tableView == _tableView3){
        return [_dataArr3[section] count];
    }
    return 0;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView1) {
            NSDictionary * dic = _dataArr1[indexPath.section][indexPath.row];
            if ([dic[@"bizType"] isEqualToString:@"02"]) {
                float tableViewRowHeight = 174;
                if (indexPath.row == [_dataArr1[indexPath.section] count] - 1 && indexPath.section != _dataArr1.count - 1) {
                    tableViewRowHeight += 10;
                }
                return tableViewRowHeight;
            } else {
                float tableViewRowHeight = 258;
                
                if (indexPath.row == [_dataArr1[indexPath.section] count] - 1 && indexPath.section != _dataArr1.count - 1) {
                    tableViewRowHeight += 10;
                }
                
                //判断是否有实际回款日期
                if (![dic[@"actualRefundTime"] hasPrefix:@"20"]) {
                    tableViewRowHeight -= 28;
                }
                return tableViewRowHeight;
                
        }
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
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView1) {//邀请返利明细列表
        
        NSDictionary * kindDict = _dataArr1[indexPath.section][indexPath.row];
        if ([kindDict[@"bizType"] isEqualToString:@"01"]) {
            static  NSString *indentifier = @"UCFRebateCell";
            UCFGoldRebateCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"UCFGoldRebateCell" owner:self options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = UIColorWithRGB(0xebebee);
            }
                NSDictionary * dic = _dataArr1[indexPath.section][indexPath.row];
                cell.bidName.text = dic[@"prdClaimsName"];//标名称
                id status = dic[@"status"];
                cell.bidState.text = _titleArr1[[status intValue] - 1];
                cell.investPeopleName.text = dic[@"applyName"];//投资人
                cell.investBeginTime.text = dic[@"tradeTime"];//投资日期
                NSString *qxdate = [dic objectSafeForKey: @"startingDate"];
                cell.investQXTime.text = qxdate.length > 0 ? qxdate :@"--" ;//起息日期
                cell.investNum.text = [NSString stringWithFormat:@"%@克",dic[@"purchaseAmount"]];//投资本金
                float tableViewRowHeight = 258;
                 //判断是否有实际回款日期
                if (![dic[@"actualRefundTime"] hasPrefix:@"20"]) {
                    tableViewRowHeight -= 28;
                    cell.auctualDateHeight.constant = 0;
                }else{
                    cell.auctualDateHeight.constant = 28;
                    cell.investActualTime.text = dic[@"actualRefundTime"];
                }
//                cell.cellUpBigViewHight.constant = tableViewRowHeight;
                cell.myFeedBackMoney.text = [NSString stringWithFormat:@"%@",dic[@"commissionAmt"]]; //我的返利
                cell.investPlanDate.text = [dic[@"refundPerDate"] length] > 0 ? dic[@"refundPerDate"]:@"--";//回款日
                cell.bidInterest.text = [NSString stringWithFormat:@"%@",dic[@"annualRate"]];//15%
                if ([dic[@"holdTime"]length] > 0) {
                    cell.bidTime.text = [NSString stringWithFormat:@"%@~%@",dic[@"holdTime"],dic[@"repayPeriodtext"]];//投资期限
                }else{
                    cell.bidTime.text =[NSString stringWithFormat:@"%@天",dic[@"periodTerm"]];//30天
                }
                cell.bidDealType.text = dic[@"repayModetext"];//一次结清
    
                if ([cell.bidState.text isEqualToString:@"回金中"]) {
                    cell.bidState.textColor = UIColorWithRGB(0xffc027);
                } else if ([cell.bidState.text isEqualToString:@"认购中"]){
                    cell.bidState.textColor = UIColorWithRGB(0x4aa1f9);//那种红0x4aa1f9
                } else if ([cell.bidState.text isEqualToString:@"满标"]){
                    cell.bidState.textColor = UIColorWithRGB(0xffc027);
                } else{
                    cell.bidState.textColor = UIColorWithRGB(0x999999);
                }
            
            return cell;
        } else {
            static  NSString *indentifier = @"UCFRebateGoldCell";
            UCFRebateGoldCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"UCFRebateGoldCell" owner:self options:nil][0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = UIColorWithRGB(0xebebee);
            }
            cell.nameLab.text =  kindDict[@"applyName"];//姓名
            cell.benginDateLab.text = kindDict[@"tradeTime"];
            cell.profitLab.text = [NSString stringWithFormat:@"¥%@",kindDict[@"profitMoney"]];
            cell.myFeedBackLab.text = kindDict[@"commissionAmt"];
            cell.bidNameLab.text = kindDict[@"prdClaimsName"];
            cell.annateLab.text = [NSString stringWithFormat:@"%@%%",kindDict[@"annualRate"]];
            cell.myFeedBackLab.textColor = UIColorWithRGB(0xffc027);
            return cell;
        }
    }else if (tableView == _tableView2){//好友未回款列表
        static  NSString *indentifier = @"FriendRecCell";
        UCFFriendRecCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UCFFriendRecCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.accoutType == SelectAccoutTypeGold) {
                cell.investorLab.text = @"购买人";
                cell.planLabel.text = @"计划回金日";
                cell.payGoldGram.text = @"回金克重";
            }
        }
        cell.lab1.text = _dataArr2[indexPath.section][indexPath.row][@"applyName"];//姓名
        cell.lab2.text = _dataArr2[indexPath.section][indexPath.row][@"phone"];//手机号
        cell.planLabel.text = @"计划回金日";
        cell.lab3.text = _dataArr2[indexPath.section][indexPath.row][@"refundPerDate"] ;//计划回款日
        NSString *refundAmtStr = _dataArr2[indexPath.section][indexPath.row][@"planRefundAmount"];
        cell.lab4.text = [refundAmtStr hasPrefix:@"*"] ? refundAmtStr : [NSString stringWithFormat:@"%@克",refundAmtStr];//回款金额
        return cell;
    }else if (tableView == _tableView3){//好友已回款列表
        static  NSString *indentifier = @"FriendRecCell1";
        UCFFriendRecCell1 *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UCFFriendRecCell1" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.accoutType == SelectAccoutTypeGold) {
                cell.investorLab.text = @"购买人";
                cell.planLabel.text = @"计划回金日";
                cell.payGoldGram.text = @"回金克重";
                cell.actulPayDateLab.text = @"实际回金日";
            }
        }
            cell.lab1.text = _dataArr3[indexPath.section][indexPath.row][@"applyName"];//姓名
            cell.lab2.text = _dataArr3[indexPath.section][indexPath.row][@"phone"];//手机号
            cell.planLabel.text = @"计划回金日";
            cell.lab3.text = _dataArr3[indexPath.section][indexPath.row][@"refundPerDate"] ;//计划回款日
            NSString *refundAmtStr = _dataArr3[indexPath.section][indexPath.row][@"planRefundAmount"];
            cell.lab4.text = [refundAmtStr hasPrefix:@"*"] ? refundAmtStr : [NSString stringWithFormat:@"%@克",refundAmtStr];//回款金额
        
        return cell;
    }
    return nil;
}

// 选中某cell时。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
            if (self.accoutType == SelectAccoutTypeGold) {
                NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:1];
                [tmpDict setValue:userId forKey:@"userId"];
                [tmpDict setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum1] forKey:@"page"];
                [tmpDict setValue:@"20" forKey:@"rows"];
                [[NetworkModule sharedNetworkModule] newPostReq:tmpDict tag:kSXTagGoldFriendList owner:self signature:YES Type:SelectAccoutDefault];
            }
        }
            break;
            
        case 1://（邀请返利-好友未回款）
        {
            if (_tableView2.header.isRefreshing) {
                _pageNum2 = 1;
            }else if (_tableView2.footer.isRefreshing){
                _pageNum2 ++;
            }
            if (self.accoutType == SelectAccoutTypeGold) {
                
                NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:1];
                [tmpDict setValue:userId forKey:@"userId"];
                [tmpDict setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum2] forKey:@"page"];
                [tmpDict setValue:@"20" forKey:@"rows"];
                [tmpDict setValue:@"00" forKey:@"status"];
                [[NetworkModule sharedNetworkModule] newPostReq:tmpDict tag:kSXTagGoldRecommendRefund owner:self signature:YES Type:SelectAccoutDefault];
                
            }
        }
            break;
        case 2://（邀请返利-好友已回款）
        {
            if (_tableView3.header.isRefreshing) {
                _pageNum3 = 1;
            }else if (_tableView3.footer.isRefreshing){
                _pageNum3 ++;
            }
            if (self.accoutType == SelectAccoutTypeGold) {
                NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:1];
                [tmpDict setValue:userId forKey:@"userId"];
                [tmpDict setValue:[NSString stringWithFormat:@"%ld",(long)_pageNum3] forKey:@"page"];
                [tmpDict setValue:@"20" forKey:@"rows"];
                [tmpDict setValue:@"01" forKey:@"status"];
                [[NetworkModule sharedNetworkModule] newPostReq:tmpDict tag:kSXTagGoldRecommendRefund owner:self signature:YES Type:SelectAccoutDefault];
            }
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
    NSString *rsttext = dic[@"statusdes"];
    DBLOG(@"我的返利页：%@",dic);
    //（邀请返利-邀请投资明细）
     if (tag.intValue == kSXTagGoldFriendList) {
        NSArray *tempArr = dic[@"data"][@"pageData"][@"result"];
        _tableView1.footer.hidden = NO;
        if ([dic[@"ret"] boolValue]) {
            _monthTitlArr1 = [NSMutableArray arrayWithArray:dic[@"data"][@"monthDataList"]];
            if (_pageNum1 == 1) {
                _dataArr_1 = [NSMutableArray arrayWithArray:tempArr];
                [_tableView1.header endRefreshing];
                [_tableView1.footer endRefreshing];
            }else{
                if ([tempArr count] == 0) {
                    [_tableView1.footer noticeNoMoreData];
                }else{
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
    } else if (tag.intValue == kSXTagGoldRecommendRefund) {
        NSArray *tempArr = dic[@"data"][@"pageData"][@"result"];
        if (_index == 1) {
            _tableView2.footer.hidden = NO;
            if ([dic[@"ret"] boolValue]) {
                if (_pageNum2 == 1) {
                    _monthDataArr2 = [NSMutableArray arrayWithArray:dic[@"data"][@"monthlist"]];
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
            if ([dic[@"ret"] boolValue]) {
                _monthTitlArr3 = [NSMutableArray arrayWithArray:dic[@"data"][@"monthlist"]];
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
        if (self.accoutType == SelectAccoutTypeGold) {
            NSString *dateStr = [_dataArr_1[i][@"tradeTime"]substringToIndex:7];
            if (![_monthDataArr1 containsObject:dateStr]) {
                [_monthDataArr1 addObject:dateStr];
            }
        }
    }
    //把同年月的归到一组
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _monthDataArr1.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < _dataArr_1.count; j++) {
            if (self.accoutType == SelectAccoutTypeGold) {
                NSString *dateStr = [_dataArr_1[j][@"tradeTime"]substringToIndex:7];
                if ([_monthDataArr1[i] isEqualToString:dateStr]) {
                    [arr addObject:_dataArr_1[j]];
                }
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
        
        if (self.accoutType == SelectAccoutTypeGold) {
            NSString *str = _monthDataArr2[i][@"repayPerDate"];
            for (int j = 0; j < _dataArr_2.count; j++) {
                NSString *dateStr = [_dataArr_2[j][@"refundPerDate"]substringToIndex:7];
                if ([str isEqualToString:dateStr]) {
                    [arr addObject:_dataArr_2[j]];
                }
            }
            [dataArray addObject:arr];
        }
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
        NSString *dateStr = @"";
        if (self.accoutType == SelectAccoutTypeGold) {
            dateStr = [_dataArr_3[i][@"actualRefundTime"]substringToIndex:7];
        }
        if (![_monthDataArr3 containsObject:dateStr]) {
            [_monthDataArr3 addObject:dateStr];
        }
    }
    //把同年月的归到一组
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _monthDataArr3.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < _dataArr_3.count; j++) {
            NSString *dateStr = @"";
            if (self.accoutType == SelectAccoutTypeGold) {
                dateStr = [_dataArr_3[i][@"actualRefundTime"]substringToIndex:7];
            }
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
@end
