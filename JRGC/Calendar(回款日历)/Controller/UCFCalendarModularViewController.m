//
//  UCFCalendarModularViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/10/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCalendarModularViewController.h"
#import "UCFCalendarModularHeaderView.h"
#import "UCFToolsMehod.h"
#import "UCFCalendarGroup.h"
#import "UCFCalendarModularDetailHeaderView.h"
#import "UCFCalendarModularDayCell.h"
#import "UCFPickView.h"
@interface UCFCalendarModularViewController ()<UITableViewDataSource, UITableViewDelegate, UCFCalendarModularHeaderViewDelegate, UCFCalendarModularDetailHeaderView, UIPickerViewDelegate, UIPickerViewDataSource, UCFPickViewDelegate>
@property (weak, nonatomic) UCFCalendarModularHeaderView *calendarHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *selectedDayDatas;
@property (weak, nonatomic) UCFPickView *pickerView;
@end

@implementation UCFCalendarModularViewController

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
    self.tableview.tableHeaderView.frame =  CGRectMake(0, 0, ScreenWidth, [UCFCalendarModularHeaderView viewHeight]);
}
#pragma mark - 初始化界面
- (void)createUI {
//    baseTitleLabel.text = @"回款日历";
    
    [self addLeftButton];
    
    UCFCalendarModularHeaderView *calendarHeaderView = (UCFCalendarModularHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarModularHeaderView" owner:self options:nil] lastObject];
    calendarHeaderView.frame = CGRectMake(0, 0, ScreenWidth, [UCFCalendarModularHeaderView viewHeight]);
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
    if (self.selectedDayDatas.count == 0 && self.calendarHeader.currentDayLabel.text.length != 0) {
        return 1;
    }
    else
        return self.selectedDayDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.selectedDayDatas.count) {
        return 0;
    }
    UCFCalendarGroup *group = [self.selectedDayDatas objectAtIndex:section];
    if (group.isOpened) {
        if ([group.status intValue] == 0) {
            return 2;
        }
        else
            return 3;
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"calendarDay";
    UCFCalendarModularDayCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (UCFCalendarModularDayCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarModularDayCell" owner:self options:nil] lastObject];
        cell.tableview = tableView;
    }
    cell.indexPath = indexPath;
    cell.group = [self.selectedDayDatas objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.selectedDayDatas.count) {
        return 200;
    }
    return 73;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UCFCalendarModularDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"calendarDetailHeader"];
    if (nil == headerView) {
        headerView = (UCFCalendarModularDetailHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarModularDetailHeaderView" owner:self options:nil] lastObject];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        headerView.delegate = self;
    }
    if (self.selectedDayDatas.count>0) {
        headerView.group = [self.selectedDayDatas objectAtIndex:section];
    }
    
    return headerView;
}

- (void)calendarDetailHeaderView:(UCFCalendarModularDetailHeaderView *)calendarDetailHeader didClicked:(UIButton *)button
{
    [self.tableview reloadData];
}

#pragma mark - 网络请求
- (void)getCanlendarHeaderInfoFromNet
{
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:SingleUserInfo.loginData.userInfo.userId];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagOldCalendarHeader owner:self signature:YES Type:self.accoutType];
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
        if (tag.intValue == kSXTagOldCalendarHeader) {
            self.calendarHeader.calendarHeaderInfo = [dictotal objectSafeDictionaryForKey:@"data"];
            self.pickerView.dataArray = [[dictotal objectSafeDictionaryForKey:@"data"] objectSafeArrayForKey:@"months"];
            NSArray *monthArr = [[dictotal objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"months"];
            NSString *currentDay = [[dictotal objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"today"];
            NSString *currentMonth = [currentDay substringToIndex:7];
            if ([monthArr containsObject:currentMonth]) {
                [self getCurrentDayInfoFromNetWithDay:currentDay];
            } else {
                
            }
            //            [self.pickerView reloadAllComponents];
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
            [self.tableview performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
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
    [self.calendarHeader setCurrentLabText:day];
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:SingleUserInfo.loginData.userInfo.userId];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", day, @"day", @"20", @"rows", @"1", @"page",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagCurrentDayInfo owner:self signature:YES Type:self.accoutType];
}

- (void)calendar:(UCFCalendarModularHeaderView *)calendar didClickedHeader:(UIButton *)headerBtn
{
    //    self.pickerView.hidden = !self.pickerView.hidden;
    if (headerBtn.selected) {
        [self.pickerView show];
        NSArray *arr = self.calendarHeader.calendar.indexPathsForVisibleItems;
        NSIndexPath *indexPath = arr[0];
        [self.pickerView scrollToThisMonth:indexPath.row];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
