//
//  UCFCouponExchangeToFriends.m
//  JRGC
//
//  Created by 狂战之巅 on 16/11/7.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFCouponExchangeToFriends.h"
#import "UCFCouponExchangeToFriendTableViewCell.h"
#import "BlockUIAlertView.h"
#import "UCFNoDataView.h"
#import "UCFCouponUseCell.h"
#import "UCFCouponViewController.h"

@interface UCFCouponExchangeToFriends ()

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UCFNoDataView *noDataView;
@property (nonatomic, strong) NSString *targetUserId;//目标id
@property int page;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *searchBut;

@end

@implementation UCFCouponExchangeToFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"赠送好友";
    self.page = 1;
    self.noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64 -102) errorTitle:@"暂无数据"];
    
    UCFCouponUseCell *cell = [UCFCouponUseCell cellWithTableView:self.myTableView];
    cell.frame = CGRectMake(0, 0, ScreenWidth, 92);
    cell.couponModel = self.quanData;
//    cell.signForOverDue.hidden = NO;
    cell.donateButton.hidden = YES;
    [self.headView addSubview:cell];
    
//    =========  下拉刷新、上拉加载更多  =========
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = UIColorWithRGB(0xebebee);
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    __weak typeof(self) weakSelf = self;
    
    // 添加上拉加载更多
    [self.myTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf requestFriendListMore];
    }];
    [self.myTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestFriendListRefresh)];
    self.myTableView.footer.hidden = YES;
    [self.myTableView.header beginRefreshing];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _textField.leftView = view;
    _textField.leftViewMode = UITextFieldViewModeAlways; //此处用来设置leftview现实时机
}

//搜索
- (IBAction)searchAction:(id)sender {
    //请求接口
    
    //返回数据，刷新table
    if(1){//有数据
        //显示列表
    } else{
        //显示 无数据
    }
}

#pragma mark - 请求处理
//好友列表
//重新请求
- (void)requestFriendListRefresh
{
    self.page = 1;
    [self requestFriendList];
}
- (void)requestFriendListMore
{
    [self requestFriendList];
}
- (void)requestFriendList {
    [[NetworkModule sharedNetworkModule] newPostReq:[NSDictionary dictionaryWithObjectsAndKeys:self.quanData.couponId ,@"couponId",self.couponType,@"couponType",[NSString stringWithFormat:@"%d", self.page],@"page",@"20",@"pageSize",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userId",nil] tag:kSXTagPresentFriend owner:self signature:YES];
}
//赠送接口
- (void)requestComplimentary {
    [self beginRefresh];
    [[NetworkModule sharedNetworkModule] newPostReq:[NSDictionary dictionaryWithObjectsAndKeys:self.quanData.couponId ,@"couponId",self.couponType,@"couponType",self.targetUserId,@"targetUserId",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"userId", nil] tag:kSXTagPresentCoupon owner:self signature:YES];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [self.myTableView.header endRefreshing];
    [self.myTableView.footer endRefreshing];
    [self endRefresh];
    if ([tag intValue] == kSXTagPresentFriend) {
        //好友列表
        NSMutableDictionary *dic = [result objectFromJSONString];
        BOOL ret = [dic[@"ret"] boolValue];
        BOOL hasNextPage = [dic[@"data"][@"pageData"][@"pagination"][@"hasNextPage"] boolValue];
        if (ret) {
            
            if(self.page == 1)
            {
                //第一页数据
                self.dataList = [NSMutableArray arrayWithArray:dic[@"data"][@"pageData"][@"result"]];
                if (self.dataList.count == 0)
                {
                    self.myTableView.footer.hidden = YES;
                    [self.noDataView showInView:self.myTableView];
                }
                else
                {
                    [self.noDataView hide];
                    self.myTableView.footer.hidden = NO;
                    if (!hasNextPage)
                    {
                        [self.myTableView.footer noticeNoMoreData];
                    }
                    else
                    {
                        
                        [self.myTableView.footer resetNoMoreData];
                        self.page ++;
                    }
                }
            }
            else
            {
                 //加载更多页数据
                [self.dataList addObjectsFromArray:dic[@"data"][@"pageData"][@"result"]];
                if (!hasNextPage)
                {
                    [self.myTableView.footer noticeNoMoreData];
                    self.page = 1;
                }
                else
                {
                    self.page ++;
                    [self.myTableView.footer resetNoMoreData];
                }
            }
            [self.myTableView reloadData];
        }
        else
        {
            BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:@"提示" message:dic[@"message"] cancelButtonTitle:nil clickButton:^(NSInteger index) {
                //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
                UIViewController *setPrizeVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                
                if ([setPrizeVC isKindOfClass:[UCFCouponViewController class]])
                {
                    if ([((UCFCouponViewController *)setPrizeVC).currentViewController respondsToSelector:@selector(refreshingData)]) {
                        [((UCFCouponViewController *)setPrizeVC).currentViewController performSelector:@selector(refreshingData)];
                    }
                }
                [self.navigationController popViewControllerAnimated:YES];
            } otherButtonTitles:@"确定"];
            [alert_bankbrach show];

        }
    }
    else {
        //赠送券
        NSMutableDictionary *dic = [result objectFromJSONString];
        BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:@"提示" message:dic[@"message"] cancelButtonTitle:nil clickButton:^(NSInteger index) {
            //此页面已经存在于self.navigationController.viewControllers中,并且是当前页面的前一页面
            UIViewController *setPrizeVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            
            if ([setPrizeVC isKindOfClass:[UCFCouponViewController class]])
            {
                if ([((UCFCouponViewController *)setPrizeVC).currentViewController respondsToSelector:@selector(refreshingData)]) {
                    [((UCFCouponViewController *)setPrizeVC).currentViewController performSelector:@selector(refreshingData)];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        } otherButtonTitles:@"确定"];
        [alert_bankbrach show];
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [self.myTableView.header endRefreshing];
    [self endRefresh];
    [AuxiliaryFunc showToastMessage:err.userInfo[@"NSLocalizedDescription"] withView:self.view];
}

- (void)beginRefresh
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endRefresh
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - tableView的delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataList objectAtIndex:indexPath.row];
    NSString *moneyStr;
    if ([self.couponType intValue] == 1)
    {
        moneyStr = [NSString stringWithFormat:@"确认将￥%@元返现券,赠送给%@吗？",self.quanData.useInvest,[dic[@"userName"] isEqualToString:@"未认证"] ? [NSString stringWithFormat:@"用户%@",dic[@"mobile"]]:dic[@"userName"]];
    }
    else
    {
        moneyStr = [NSString stringWithFormat:@"确认将+%@返息券,赠送给%@吗？",self.quanData.backIntrestRate,[dic[@"userName"] isEqualToString:@"未认证"] ? [NSString stringWithFormat:@"用户%@",dic[@"mobile"]]:dic[@"userName"]];
    }
    
    BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:@"提示" message:moneyStr cancelButtonTitle:@"取消" clickButton:^(NSInteger index) {
        if (index == 1)
        {
            self.targetUserId = [[self.dataList objectAtIndex:indexPath.row] objectForKey:@"userId"];
            [self requestComplimentary];
        }
     
    } otherButtonTitles:@"确定"];
    [alert_bankbrach show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView setSeparatorColor:UIColorWithRGB(0xe3e5ea)];
//    static  NSString  *CellIdentiferId = @"UCFCouponExchangeToFriendTableViewCell";
//    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
//    if (cell == nil) {
//        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"UCFCouponExchangeToFriendTableViewCell" owner:nil options:nil];
//        cell = [nibs lastObject];
//        cell.backgroundColor = [UIColor clearColor];
//        UILabel* ac = [[UILabel alloc] initWithFrame:cell.accessoryView.frame];
//        cell.accessoryView = ac;
//        ac.text = @"赠送";
//    };
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSMutableString *str = [[NSMutableString alloc] initWithString:[[self.dataList objectAtIndex:indexPath.row] objectSafeForKey:@"userName"]];
//    if (str.length < 3 && str)
//    {
//        [str insertString:@"    "atIndex:1];
//    }
//    cell.textLabel.text = str;
//    NSString *mobile = [[self.dataList objectAtIndex:indexPath.row] objectSafeForKey:@"mobile"];
//    cell.detailTextLabel.text = mobile;
//    return cell;

    [tableView setSeparatorColor:UIColorWithRGB(0xe3e5ea)];
    static  NSString  *CellIdentiferId = @"UCFCouponExchangeToFriendTableViewCell";
    UCFCouponExchangeToFriendTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"UCFCouponExchangeToFriendTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor clearColor];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableString *str = [[NSMutableString alloc] initWithString:[[self.dataList objectAtIndex:indexPath.row] objectSafeForKey:@"userName"]];
    if (str.length < 3 && str)
    {
        [str insertString:@"    "atIndex:1];
    }
    cell.nameLabel.text = str;
    NSString *mobile = [[self.dataList objectAtIndex:indexPath.row] objectSafeForKey:@"mobile"];
    cell.phoneNumber.text = mobile;
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
