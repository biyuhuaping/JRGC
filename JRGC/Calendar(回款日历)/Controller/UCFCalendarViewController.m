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
#import "UCFPickView.h"
#import "UCFNoDataView.h"
@interface UCFCalendarViewController () <UITableViewDataSource, UITableViewDelegate, UCFCalendarHeaderViewDelegate, UCFCalendarDetailHeaderViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UCFPickViewDelegate>
@property (weak, nonatomic) UCFCalendarHeaderView *calendarHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *selectedDayDatas;
@property (weak, nonatomic) UCFPickView *pickerView;
@property (copy, nonatomic) NSString *currentDay;
@property (strong, nonatomic)UCFCalendarDetailHeaderView * headerView;
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
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableview.tableHeaderView.frame =  CGRectMake(0, 0, ScreenWidth, [UCFCalendarHeaderView viewHeight]);
}
#pragma mark - 初始化界面
- (void)createUI {
    baseTitleLabel.text = @"回款日历";
    
    [self addLeftButton];
    
    UCFCalendarHeaderView *calendarHeaderView = (UCFCalendarHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarHeaderView" owner:self options:nil] lastObject];
    calendarHeaderView.frame = CGRectMake(0, 0, ScreenWidth, [UCFCalendarHeaderView viewHeight]);
    self.tableview.tableHeaderView = calendarHeaderView;
    calendarHeaderView.backgroundColor = UIColorWithRGB(0xebebee);
    calendarHeaderView.accoutType = self.accoutType;
    calendarHeaderView.delegate = self;
    self.calendarHeader = calendarHeaderView;

    
    UCFPickView *pickerView = (UCFPickView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFPickView" owner:self options:nil] lastObject];
    pickerView.frame = self.view.bounds;
    [self.view addSubview:pickerView];
    pickerView.delegate = self;
    self.pickerView = pickerView;
    
    [self getCanlendarHeaderInfoFromNet];
}

#pragma mark - tableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (!self.selectedDayDatas.count && self.calendarHeader.currentDayLabel.text.length>0) {
//        return 1;
//    }
//    else
//        return self.selectedDayDatas.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (!self.selectedDayDatas.count) {
//        return 0;
//    }
//    UCFCalendarGroup *group = [self.selectedDayDatas objectAtIndex:section];
//    if (group.isOpened) {
//        if ([group.status intValue] == 0) {
//            return 2;
//        }
//        else
//            return 3;
//    }
//    else
//        return 0;
    return self.selectedDayDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"calendarDay";
    UCFCalendarDayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (UCFCalendarDayCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarDayCell" owner:self options:nil] lastObject];
        cell.tableview = tableView;
    }
//    cell.indexPath = indexPath;
    cell.group = [self.selectedDayDatas objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFCalendarGroup *group = [self.selectedDayDatas objectAtIndex:indexPath.row];
    if (group.isOpen) {
        if ([group.status intValue] == 0) {
            return 154 - 27;
        }
        else {
            return 154;
        }
    }
    else {
        return 154 - 27 * 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (!self.selectedDayDatas.count) {
//        return 200;
//    }
//    return 73;
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UCFCalendarDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"calendarDetailHeader"];
    if (!_headerView) {
        self.headerView = (UCFCalendarDetailHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarDetailHeaderView" owner:self options:nil] lastObject];
        _headerView.delegate = self;
        self.accoutType = SelectAccoutTypeP2P;
        [_headerView setSelectButtonIndex:0];
    }
    return _headerView;
}

- (void)calendarDetailHeaderView:(UCFCalendarDetailHeaderView *)calendarDetailHeader didClicked:(UIButton *)button
{
    NSString *title = [button titleForState:UIControlStateNormal];
    self.accoutType = ([title isEqualToString:@"微金回款"] ? SelectAccoutTypeP2P :SelectAccoutTypeHoner);
    [self getCurrentDayInfoFromNetWithDay:self.currentDay];
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
            self.pickerView.dataArray = [[dictotal objectSafeDictionaryForKey:@"data"] objectSafeArrayForKey:@"months"];
        }
        else if (tag.intValue == kSXTagCurrentDayInfo) {
            NSArray *dataList = [[[dictotal objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            if (self.selectedDayDatas.count > 0) {
                [self.selectedDayDatas removeAllObjects];
            }
            for (NSDictionary *dic in dataList) {
                UCFCalendarGroup *group = [UCFCalendarGroup groupWithDict:dic];
                [self.selectedDayDatas addObject:group];
            }
            if (self.selectedDayDatas.count == 0) {
                UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
                UCFNoDataView *noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200) errorTitle:@"本日无回款项目"];
                self.tableview.tableFooterView = footView;
            } else {
                
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
//    if (self.pickerView.y < self.view.height) {
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            self.pickerView.y = self.view.height;
//        }];
//    }
    
    if (nil == day) {
        [self.selectedDayDatas removeAllObjects];
        [self.tableview reloadData];
    }
    else {
        [self getCurrentDayInfoFromNetWithDay:day];
    }
}


#pragma mark - 请求当前日的信息
- (void)getCurrentDayInfoFromNetWithDay:(NSString *)day
{
    self.currentDay = day;
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", day, @"day", @"40", @"rows", @"1", @"page",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagCurrentDayInfo owner:self signature:YES Type:self.accoutType];
}

- (void)calendar:(UCFCalendarHeaderView *)calendar didClickedHeader:(UIButton *)headerBtn
{
//    self.pickerView.hidden = !self.pickerView.hidden;
    if (headerBtn.selected) {
        [self.pickerView show];
//        [UIView animateWithDuration:0.25 animations:^{
//            self.pickerView.y = self.view.height - 100;
//        }];
    }
    else {
        [self.pickerView hidden];
//        [UIView animateWithDuration:0.25 animations:^{
//            self.pickerView.y = self.view.height;
//        }];
    }
}

//#pragma mark - pickerView的代理方法
////UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
//{
//    return 1; // 返回1表明该控件只包含1列
//}
//
////UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    // 由于该控件只包含一列，因此无须理会列序号参数component
//    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
//    NSArray * array = [self.calendarHeader.calendarHeaderInfo objectForKey:@"months"];
//    return array.count;
//}
//
//
//// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
//// 中指定列和列表项的标题文本
//- (NSString *)pickerView:(UIPickerView *)pickerView
//             titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    // 由于该控件只包含一列，因此无须理会列序号参数component
//    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
//    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
//    NSArray * array = [self.calendarHeader.calendarHeaderInfo objectForKey:@"months"];
//    NSMutableString *month = [array objectAtIndex:row];
//    NSString *temp = [month stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
//    return [NSString stringWithFormat:@"%@月", temp];
//}

//// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
//(NSInteger)row inComponent:(NSInteger)component
//{
//    NSArray * array = [self.calendarHeader.calendarHeaderInfo objectForKey:@"months"];
//    NSMutableString *month = [array objectAtIndex:row];
//    NSString *temp = [month stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
//    self.calendarHeader.monthLabel.text = [NSString stringWithFormat:@"%@月", temp];
//    [self.calendarHeader.calendar setContentOffset:CGPointMake(ScreenWidth * row, 0)];
//    [self.calendarHeader getClendarInfoWithMonth:month];
//}

//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//}

- (void)pickerView:(UCFPickView *)pickerView selectedMonth:(NSString *)month withIndex:(NSInteger)index
{
    NSMutableString *temp1 = [NSMutableString stringWithFormat:@"%@", month];
    NSString *temp = [temp1 stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    self.calendarHeader.monthLabel.text = [NSString stringWithFormat:@"%@月", temp];
    [self.calendarHeader.calendar setContentOffset:CGPointMake(ScreenWidth * index, 0)];
    [self.calendarHeader getClendarInfoWithMonth:month];
}
@end
