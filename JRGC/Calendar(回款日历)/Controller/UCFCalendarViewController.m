//
//  UCFCalendarViewController.m
//  JRGC
//
//  Created by njw on 2017/7/3.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCalendarViewController.h"
#import "UCFCalendarHeaderView.h"
#import "UCFToolsMehod.h"
#import "UCFCalendarGroup.h"
#import "UCFCalendarDetailHeaderView.h"
#import "UCFCalendarDayCell.h"

@interface UCFCalendarViewController () <UITableViewDataSource, UITableViewDelegate, UCFCalendarHeaderViewDelegate, UCFCalendarDetailHeaderViewDelegate>
@property (weak, nonatomic) UCFCalendarHeaderView *calendarHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *selectedDayDatas;
@end

@implementation UCFCalendarViewController

- (NSMutableArray *)selectedDayDatas
{
    if (nil == _selectedDayDatas) {
        _selectedDayDatas = [NSMutableArray array];
    }
    return _selectedDayDatas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//  初始化界面
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentDayInfo:) name:@"currentDay" object:nil];
}

#pragma mark - 初始化界面
- (void)createUI {
    baseTitleLabel.text = @"回款日历";
    
    [self addLeftButton];
    
    UCFCalendarHeaderView *calendarHeaderView = (UCFCalendarHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarHeaderView" owner:self options:nil] lastObject];
    calendarHeaderView.frame = CGRectMake(0, 0, ScreenWidth, [UCFCalendarHeaderView viewHeight]);
    self.tableview.tableHeaderView = calendarHeaderView;
    calendarHeaderView.accoutType = self.accoutType;
    calendarHeaderView.delegate = self;
    self.calendarHeader = calendarHeaderView;
    
    [self getCanlendarHeaderInfoFromNet];
}

#pragma mark - tableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.selectedDayDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFCalendarGroup *group = [self.selectedDayDatas objectAtIndex:section];
    if (group.isOpened) {
        return 3;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"calendarDay";
    UCFCalendarDayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (UCFCalendarDayCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarDayCell" owner:self options:nil] lastObject];
    }
    cell.indexPath = indexPath;
    cell.group = [self.selectedDayDatas objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 73;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UCFCalendarDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"calendarDetailHeader"];
    if (nil == headerView) {
        headerView = (UCFCalendarDetailHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarDetailHeaderView" owner:self options:nil] lastObject];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        headerView.delegate = self;
    }
    headerView.group = [self.selectedDayDatas objectAtIndex:section];
    return headerView;
}

- (void)calendarDetailHeaderView:(UCFCalendarDetailHeaderView *)calendarDetailHeader didClicked:(UIButton *)button
{
    [self.tableview reloadData];
}

#pragma mark - 网络请求
- (void)getCanlendarHeaderInfoFromNet
{
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagCalendarHeader owner:self signature:YES Type:self.accoutType];
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSDictionary *dictotal = [result objectFromJSONString];
    NSString *rstcode = [dictotal objectSafeForKey:@"ret"];
    NSString *rsttext = [dictotal objectSafeForKey:@"message"];
    
    if ([rstcode intValue] == 1) {
        if (tag.intValue == kSXTagCalendarHeader) {
            self.calendarHeader.calendarHeaderInfo = [dictotal objectSafeDictionaryForKey:@"data"];
        }
        else if (tag.intValue == kSXTagCurrentDayInfo) {
            NSArray *dataList = [[[dictotal objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            if (self.selectedDayDatas.count > 0) {
                [self.selectedDayDatas removeAllObjects];
            }
            for (NSDictionary *dic in dataList) {
                UCFCalendarGroup *group = [UCFCalendarGroup groupWithDict:dic];
                if ([dic isEqual:[dataList firstObject]]) {
                    group.opened = YES;
                }
                [self.selectedDayDatas addObject:group];
            }
            [self.tableview reloadData];
        }
    }else{
        [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}

#pragma mark - UCFCalendarHeaderView的代理

- (void)calendar:(UCFCalendarCollectionViewCell *)calendar didClickedDay:(NSString *)day
{
    [self getCurrentDayInfoFromNetWithDay:day];
}

#pragma mark - 当前选中的日的信息请求
- (void)currentDayInfo:(NSNotification *)noty
{
    NSString *currentDay = self.calendarHeader.currentDay;
    [self getCurrentDayInfoFromNetWithDay:currentDay];
}

#pragma mark - 请求当前日的信息
- (void)getCurrentDayInfoFromNetWithDay:(NSString *)day
{
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", day, @"day", @"20", @"rows", @"1", @"page",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagCurrentDayInfo owner:self signature:YES Type:self.accoutType];
}

@end
