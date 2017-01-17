//
//  UCFDataStatisticsViewController.m
//  JRGC
//
//  Created by njw on 2016/12/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFDataStatisticsViewController.h"
#import "UCFDataStaticsCell.h"
#import "UCFDataStaticsModel.h"

@interface UCFDataStatisticsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *selectList;
@property (nonatomic, strong) NSMutableArray *currentMonths;
@property (nonatomic, weak) UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end


@implementation UCFDataStatisticsViewController

- (NSMutableArray *)currentMonths
{
    if (nil == _currentMonths) {
        _currentMonths = [NSMutableArray array];
    }
    return _currentMonths;
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    baseTitleLabel.text = @"统计数据";
    [self addLeftButton];
    
    [self addRightButton];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 1, 100, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.hidden = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.selectList = tableView;
    
    [self getDataStaticFromNetWithTime:@""];
}

- (void)addRightButton
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 90, 44);
    [rightbutton.titleLabel setFrame:CGRectMake(0, 0, 75, 44)];
    [rightbutton.titleLabel setBackgroundColor:[UIColor greenColor]];
    //    rightbutton.backgroundColor = [UIColor redColor];
    [rightbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.rightButton = rightbutton;
}

- (void)clickRightBtn
{
    CGRect frame = self.selectList.frame;
    if (!self.selectList.hidden) {
        frame.size.height = 0;
    }
    else {
        frame.size.height = 44*self.currentMonths.count;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self.selectList setFrame:frame];
    }];
    self.selectList.hidden = !self.selectList.hidden;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.selectList) {
        return self.currentMonths.count;
    }
    else
        return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectList) {
        static NSString *cellId = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = [self.currentMonths objectAtIndex:indexPath.row];
        return cell;
    }
    else if (tableView == self.dataTableView) {
        static NSString *cellId = @"dataStastics";
        UCFDataStaticsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFDataStaticsCell" owner:self options:nil] lastObject];
        }
        UCFDataStaticsModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.model = model;
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectList) {
        return 44;
    }
    else
        return 215+10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.selectList) {
        [self.rightButton setTitle:[self.currentMonths objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [self clickRightBtn];
        [self getDataStaticFromNetWithTime:[self.currentMonths objectAtIndex:indexPath.row]];
        [self.selectList reloadData];
    }
}

- (void)getDataStaticFromNetWithTime:(NSString *)time
{
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:UUID], @"userId", time, @"monthStr",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:dataDic tag:kSXTagDataStatics owner:self signature:YES];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    
    if (tag.intValue == kSXTagDataStatics) {
        
        NSDictionary *dictotal = [data objectFromJSONString];
        NSString *rstcode = [dictotal objectSafeForKey:@"ret"];
        NSString *rsttext = [dictotal objectSafeForKey:@"message"];
        
        if ([rstcode intValue] == 1) {
            NSArray *result = [[dictotal objectForKey:@"data"] objectForKey:@"resultData"];
            NSArray *monthList = [[dictotal objectForKey:@"data"] objectForKey:@"monthList"];
            if (!self.currentMonths.count) {
                [self.rightButton setTitle:[monthList objectAtIndex:0] forState:UIControlStateNormal];
                [self.currentMonths addObjectsFromArray:monthList];
                [self.selectList reloadData];
            }
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in result) {
                UCFDataStaticsModel *model = [UCFDataStaticsModel dataStaticsModelWithDict:dic];
                [self.dataArray addObject:model];
            }
            [self.dataTableView reloadData];
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagBankInfoNew||tag.intValue == kSXTagChosenBranchBank) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    self.settingBaseBgView.hidden = YES;
}


@end
