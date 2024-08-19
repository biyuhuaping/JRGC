//
//  UCFAccountDetailWZAndZXViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/9.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAccountDetailWZAndZXViewController.h"
#import "BaseTableView.h"
#import "UCFAccountDetailTurnoverCell.h"
#import "UCFAccountDetailWZAndZXModel.h"
#import <NSObject+YYModel.h>
#import "FundsDetailModel.h"
#import "FundsDetailFrame.h"
#import "FundsDetailGroup.h"
@interface UCFAccountDetailWZAndZXViewController ()<UITableViewDelegate, UITableViewDataSource ,BaseTableViewDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) BaseTableView *tableView;

@property (nonatomic, assign) NSUInteger page;// 当前页数

@property (nonatomic, strong) NSMutableArray *arryData;

@property (nonatomic, strong) NSMutableArray *arryTitle;
@end

@implementation UCFAccountDetailWZAndZXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    baseTitleLabel.text = @"资金流水";
//    [self.tableView beginRefresh];
    self.page = 1;
     self.arryData = [NSMutableArray array];
    [self.rootLayout addSubview:self.tableView];
    [self.tableView beginRefresh];
    [self addLeftButton];
    
    UIView *bottomLineView = [UIView new];
    bottomLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    bottomLineView.myTop = 0;
    bottomLineView.myLeft = 0;
    bottomLineView.myRight = 0;
    bottomLineView.myHeight = 0.5;
    [self.rootLayout addSubview:bottomLineView];
}
- (BaseTableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.tableRefreshDelegate= self;
//        _tableView.enableRefreshFooter = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.topPos.equalTo(@0);
        _tableView.leftPos.equalTo(@0);
        _tableView.rightPos.equalTo(@0);
        _tableView.bottomPos.equalTo(@0);
        
    }
    return _tableView;
}
- (void)getToBack
{
    [self.rt_navigationController popViewControllerAnimated:YES];
}
#pragma mark--tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.arryData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    FundsDetailGroup *group = [self.arryData objectAtIndex:section];
    return group.content.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 219;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth ,33)];//创建一个视图
    headerView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    FundsDetailGroup *group = [self.arryData objectAtIndex:section];
    NSString  *createTime = group.time;

    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 18, 150, 15)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14.0];
    headerLabel.textColor = [Color color:PGColorOptionTitleGray];
    headerLabel.text = createTime;
    [headerView addSubview:headerLabel];
    return headerView;
}
// 设置表头的高度。如果使用自定义表头，该方法必须要实现，否则自定义表头无法执行，也不会报错
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UCFMicroBankDepositoryAccountSeriaCell";
    //自定义cell类
    UCFAccountDetailTurnoverCell *cell = (UCFAccountDetailTurnoverCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UCFAccountDetailTurnoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.lastRowInSection = (self.arryData.count - 1 == indexPath.row);
    FundsDetailGroup *group = [self.arryData objectAtIndex:indexPath.section];
    [cell showInfo:[group.content objectAtIndex:indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/**
 *  下拉刷新的回调
 *
 */
- (void)refreshTableViewHeader
{
    self.page = 1;
    self.arryData = [NSMutableArray arrayWithCapacity:20];
    [self requestPage:self.page];
    
}

/**
 *  上提刷新的回调
 *
 */
- (void)refreshTableViewFooter
{
    [self requestPage:self.page];
}

- (void)requestPage:(NSInteger )page
{
    
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&page=%@&rows=%@", SingleUserInfo.loginData.userInfo.userId, [NSString stringWithFormat:@"%lu", (unsigned long)self.page], @"10"];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFundsDetail owner:self Type:self.accoutType];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    //    if (self.settingBaseBgView.hidden) {
    //        self.settingBaseBgView.hidden = NO;
    //    }
    //    [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    if (tag.integerValue == kSXTagFundsDetail) {
//        YPersonModel *model = [YYPersonModel modelWithDictionary:dic];
        UCFAccountDetailWZAndZXModel *model = [UCFAccountDetailWZAndZXModel yy_modelWithDictionary:[data objectFromJSONString]];
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSArray *datalist = [[dic objectForKey:@"pageData"] objectForKey:@"result"];
        if ([model.status integerValue] == 1) {
            
            if (model.pageData.pagination.pageNo == 1)
            {
                [self.arryData removeAllObjects];
            }
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in datalist) {
                FundsDetailModel *model = [FundsDetailModel fundDetailModelWithDict:dict];
                FundsDetailFrame *frame = [[FundsDetailFrame alloc] init];
                frame.fundsDetailModel = model;
                [temp addObject:frame];
            }
            [self.arryData addObjectsFromArray:temp];
            [self regroupWithArray:self.arryData];
            
            if (model.pageData.pagination.hasNextPage  && model.pageData.result.count == 10)
            {
                self.page = model.pageData.pagination.pageNo + 1;
                self.tableView.enableRefreshFooter = YES;
            }
            else
            {
                //没有下一页数据后,隐藏上拉加载,
                self.tableView.enableRefreshFooter = NO;
                self.page = model.pageData.pagination.pageNo;
            }
        }
        else {
            [AuxiliaryFunc showToastMessage:dic[@"statusdes"] withView:self.view];
        }
        [self endRefreshAndReloadData];
    }
}
// 资金明细分组
- (void)regroupWithArray:(NSArray *)array
{
    NSMutableArray *temp = [NSMutableArray array];
    for (id obj in array) {
        if ([obj isKindOfClass:[FundsDetailGroup class]]) {
            FundsDetailGroup *group = (FundsDetailGroup *)obj;
            [temp addObjectsFromArray:group.content];
        }
        else if ([obj isKindOfClass:[FundsDetailFrame class]]) {
            FundsDetailFrame *detailFrame = (FundsDetailFrame *)obj;
            [temp addObject:detailFrame];
        }
    }
    NSMutableArray *tempSection = [NSMutableArray array];
    for (id obj in temp) {
        FundsDetailFrame *detailFrame = (FundsDetailFrame *)obj;
        if (![tempSection containsObject:detailFrame.fundsDetailModel.yearMonth]) {
            [tempSection addObject:detailFrame.fundsDetailModel.yearMonth];
        }
    }
    NSMutableArray *tempDataSource = [NSMutableArray array];
    for (NSString *time in tempSection) {
        FundsDetailGroup *group = [[FundsDetailGroup alloc] init];
        NSMutableArray *tempRowData = [NSMutableArray array];
        for (id obj in temp) {
            FundsDetailFrame *detailFrame = (FundsDetailFrame *)obj;
            if ([detailFrame.fundsDetailModel.yearMonth isEqualToString:time]) {
                [tempRowData addObject:detailFrame];
            }
        }
        group.time = time;
        group.content = tempRowData;
        [tempDataSource addObject:group];
    }
    self.arryData = tempDataSource;
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [self endRefreshAndReloadData];
}

- (void)endRefreshAndReloadData
{
    [self.tableView endRefresh];
    [self.tableView cyl_reloadData];
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
