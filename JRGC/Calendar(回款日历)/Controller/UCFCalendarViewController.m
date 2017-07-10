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

@interface UCFCalendarViewController () <UITableViewDataSource, UITableViewDelegate, UCFCalendarHeaderViewDelegate, UCFCalendarDetailHeaderViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) UCFCalendarHeaderView *calendarHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *selectedDayDatas;
@property (weak, nonatomic) UIPickerView *pickerView;
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

#pragma mark - 初始化界面
- (void)createUI {
    baseTitleLabel.text = @"回款日历";
    
    [self addLeftButton];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 100)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [self.view addSubview:pickerView];
    pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView = pickerView;
    
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
    if (!self.selectedDayDatas.count && self.calendarHeader.currentDayLabel.text.length>0) {
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
    UCFCalendarDetailHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"calendarDetailHeader"];
    if (nil == headerView) {
        headerView = (UCFCalendarDetailHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalendarDetailHeaderView" owner:self options:nil] lastObject];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        headerView.delegate = self;
    }
    if (self.selectedDayDatas.count>0) {
        headerView.group = [self.selectedDayDatas objectAtIndex:section];
    }
    
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
            [self.pickerView reloadAllComponents];
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
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", day, @"day", @"20", @"rows", @"1", @"page",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagCurrentDayInfo owner:self signature:YES Type:self.accoutType];
}

- (void)calendar:(UCFCalendarHeaderView *)calendar didClickedHeader:(UIButton *)headerBtn
{
    if (headerBtn.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.y = self.view.height - 100;
        }];
    }
    else {
        [UIView animateWithDuration:0.25 animations:^{
            self.pickerView.y = self.view.height;
        }];
    }
}

#pragma mark - pickerView的代理方法
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    NSArray * array = [self.calendarHeader.calendarHeaderInfo objectForKey:@"months"];
    return array.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    NSArray * array = [self.calendarHeader.calendarHeaderInfo objectForKey:@"months"];
    NSMutableString *month = [array objectAtIndex:row];
    NSString *temp = [month stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    return [NSString stringWithFormat:@"%@月", temp];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    NSArray * array = [self.calendarHeader.calendarHeaderInfo objectForKey:@"months"];
    NSMutableString *month = [array objectAtIndex:row];
    NSString *temp = [month stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    self.calendarHeader.monthLabel.text = [NSString stringWithFormat:@"%@月", temp];
    [self.calendarHeader.calendar setContentOffset:CGPointMake(ScreenWidth * row, 0)];
    [self.calendarHeader getClendarInfoWithMonth:month];
}
@end
