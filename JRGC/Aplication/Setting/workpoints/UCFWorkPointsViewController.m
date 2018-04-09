//
//  UCFWorkPointsViewController.m
//  JRGC
//
//  Created by 狂战之巅 on 16/4/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWorkPointsViewController.h"
#import "UCFWorkPointsTableViewCell.h"
// 错误界面
#import "UCFNoDataView.h"
#import "UCF404ErrorView.h"
#import "UCFWebViewJavascriptBridgeLevel.h"
#import "AppDelegate.h"
#import "UCFWebViewJavascriptBridgeMall.h"
#import "UCFToolsMehod.h"
@interface UCFWorkPointsViewController ()<UITableViewDataSource, UITableViewDelegate,NoDataViewDelegate,UIAlertViewDelegate>
{
    NSString* Nstr_beansMallUrl;	//工豆商城首页地址	string	工豆商城首页地址
    NSString* Nstr_iintegralDesUrl;	//工分说明地址	string	工分介绍的Url
    NSString* Nstr_iintegralNum;	//我的积分	number	当前用户可用工分总和
    NSString* Nstr_jurisdiction;	//工分账户是否被禁用	boolean	用户是否有使用工分的权限 0无效 1有效
    
    int totalPage;//总页数
}
@property (nonatomic, assign) NSUInteger currentPage; //当前页码
//@property (nonatomic, strong) NSMutableArray *dataSource; //
@property (nonatomic, strong) NSMutableArray *dataSourceForAll; //
// 无数据视图
@property (nonatomic, strong) UCFNoDataView *noDataViewOne;

@property (weak, nonatomic) IBOutlet UILabel *lable_pointShow;//显示工分
@property (weak, nonatomic) IBOutlet UIView *view_Lock;//锁view 默认hidden ＝ YES；
@property (weak, nonatomic) IBOutlet UILabel *lable_showMyPoint;
@property (weak, nonatomic) IBOutlet UILabel *frozenWorkPoint;  //冻结工分数量
@property (weak, nonatomic) IBOutlet UILabel *overduingWorkPoint;   //即将过期工分
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIView *segLine;

@end

@implementation UCFWorkPointsViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.noDataViewOne||self.noDataViewOne==nil)
    {
    UCFNoDataView *noDataViewOne = [[UCFNoDataView alloc] initWithFrame:self.tableView.bounds errorTitle:@"暂无数据"];
    self.noDataViewOne = noDataViewOne;
    self.noDataViewOne.delegate = self;
    self.tableView.backgroundColor=UIColorWithRGB(0xebebee);
    self.tableView.footer.hidden= YES;
    [self.tableView.header beginRefreshing];
        

    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addRightButtonWithName:@"工分说明"];
    
    self.segLine.backgroundColor = UIColorWithRGB(0x434F73);
    
    baseTitleLabel.text = @"我的工分";
    Nstr_beansMallUrl =@"";
    Nstr_iintegralDesUrl =@"";
    Nstr_iintegralNum =@"";
    Nstr_jurisdiction =@"";
    totalPage = 0;
    self.view_Lock.hidden = YES;
//    self.dataSource = [[NSMutableArray alloc]init];
    self.dataSourceForAll = [[NSMutableArray alloc]init];
    self.currentPage = 1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
   
    
    
    self.noDataViewOne.delegate = self;

    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataRequset)];

    // 上拉刷新
    [self.tableView addLegendFooterWithRefreshingBlock:^{

        [weakSelf getDataRequsetWithPageNo: weakSelf.currentPage];
    }];

    self.tableView.footer.hidden= YES;
    self.tableView.backgroundColor = UIColorWithRGB(0xebebee);
    
//     [self getDataRequset];
    
    // Do any additional setup after loading the view from its nib.
    
    [self.upView setBackgroundColor:UIColorWithRGB(0x5b6993)];
    [self.downView setBackgroundColor:UIColorWithRGB(0x505e87)];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 69;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceForAll count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // 拿到对应cell并根据模型显示
    static NSString *CellIdentifier = @"UCFWorkPointsTableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([UCFWorkPointsTableViewCell class]) bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    UCFWorkPointsTableViewCell *cell = (UCFWorkPointsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell reloadCellData:[self.dataSourceForAll objectAtIndex:indexPath.row]];
    return cell;
}

// 网络请求-列表上拉
- (void)getDataRequset{
//    [self.dataSource removeAllObjects];
       self.currentPage = 1;
   
//    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&&page=%lu&rows=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID], (unsigned long)self.currentPage, PAGESIZE];
//    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetWorkPoint owner:self];
    
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%lu", (unsigned long)self.currentPage],@"rows":@"20",@"userId":userId};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagGetWorkPoint owner:self signature:YES Type:SelectAccoutDefault];
    
}

// 网络请求-列表下拉
- (void)getDataRequsetWithPageNo:(NSUInteger)currentPageNo{
    
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%lu", (unsigned long)self.currentPage],@"rows":@"20",@"userId":userId};
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagGetWorkPoint owner:self signature:YES Type:SelectAccoutDefault];
}
//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag{
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }else if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    if(self.currentPage==1)
    {
        [self.dataSourceForAll removeAllObjects];
        [self.tableView reloadData];
        [self.tableView.footer resetNoMoreData];

    }
    
    NSString *data = (NSString *)result;
    NSDictionary *dic = [data objectFromJSONString];
//    NSString *rstcode = [dic objectSafeForKey:@"ret"];
    NSString *rsttext = [dic objectSafeForKey:@"message"];
    NSDictionary *dat = [dic objectSafeDictionaryForKey:@"data"];

    if (tag.intValue == kSXTagGetWorkPoint) {
        if([dic[@"ret"] boolValue] == 1){
        
            if (self.currentPage < [[[[dat objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"totalPage"] integerValue]) {
                self.currentPage++;
            }
        Nstr_beansMallUrl =[dat objectSafeForKey:@"beansMallUrl"];//工豆商城首页地址	string	工豆商城首页地址
       

        Nstr_iintegralDesUrl =[dat objectSafeForKey:@"iintegralDesUrl"]; //工分说明地址	string	工分介绍的Url
       
        Nstr_iintegralNum =[NSString stringWithFormat:@"%@",[dat objectSafeForKey:@"iintegralNum"]]; //我的积分	number	当前用户可用工分总和
        
        self.lable_pointShow.text = Nstr_iintegralNum;
        Nstr_jurisdiction =[NSString stringWithFormat:@"%@",[dat objectSafeForKey:@"jurisdiction"]];//工分账户是否被禁用	boolean	用户是否有使用工分的权限
            
        self.frozenWorkPoint.text = [NSString stringWithFormat:@"%@", [dat objectSafeForKey:@"frozenAmount"]];
        self.overduingWorkPoint.text = [NSString stringWithFormat:@"%@", [dat objectSafeForKey:@"willExpireAmount"]];
        if([Nstr_jurisdiction isEqualToString:@"0"])//工分账户无效
        {
            self.view_Lock.hidden = NO;
            self.lable_pointShow.textColor =UIColorWithRGB(0x94a0c1);
            self.lable_showMyPoint.textColor = UIColorWithRGB(0x94a0c1);
        }else{
             self.view_Lock.hidden = YES;
            self.lable_pointShow.textColor = [UIColor whiteColor];
            self.lable_showMyPoint.textColor = [UIColor whiteColor];

        }
        
        
//        NSString *str_msg = [(NSDictionary*)[dic objectSafeForKey:@"pageData"]objectSafeForKey:@"msg"];//主要是异常状态的描述
            if(dat[@"pageData"]!=nil)
            {
              NSDictionary*dictemp = dat[@"pageData"];
                if(dictemp!=nil)
                {
              NSDictionary *dic_pagination =[dictemp objectForKey:@"pagination"];//
              totalPage = [((NSString*)[dic_pagination objectSafeForKey:@"totalPage"])intValue];
              BOOL hasNextPage = [[dic_pagination objectForKey:@"hasNextPage"] boolValue];
                    if (!hasNextPage) {
                        [self.tableView.footer noticeNoMoreData];
                    }
              NSArray *arry_result= [(NSDictionary*)dat[@"pageData"]objectForKey:@"result"];//每个cell的信息
                   if(![arry_result isEqual:[NSNull null]])
                   {
                       if([arry_result count]>0)
                       {
                           [self.dataSourceForAll addObjectsFromArray:arry_result];
                        }
                    }
             }
                
            
        }
       
    }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];

    }
        [self setNoDataView];
    }
    
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag{
    if (tag.intValue == kSXTagGetWorkPoint) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self setNoDataView];
}
- (void)setNoDataView{
   
    
    
//    if ([self.tableView.header isRefreshing]) {
//        [self.tableView.header endRefreshing];
//    }else if ([self.tableView.footer isRefreshing]) {
//        [self.tableView.footer endRefreshing];
//    }
    if (self.dataSourceForAll.count == 0) {//无数据：显示“暂无数据”、隐藏“已无更多数据”
        
        //        [self.tableView.footer noticeNoMoreData];
        [self.noDataViewOne showInView:self.tableView];
        return;
    } else {//有数据：隐藏“暂无数据”
        [self.noDataViewOne hide];
    }

    
    if(self.currentPage > totalPage)
    {
        [self.tableView.footer noticeNoMoreData];
        //        return;
    }

    self.tableView.footer.hidden= NO;

    [self.tableView reloadData];
 }
//刷新-当数据为空时候点击图标调用请求
- (void)refreshBtnClicked:(id)sender
{
    [self.dataSourceForAll removeAllObjects];
    [self getDataRequset];
}
//按钮动作-跳转工豆商城WHL
- (IBAction)buttonGoToMarket:(id)sender {
//    if (_superView) {
//        [_superView changeBackActionMark];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    } else {
        [self goBackbeansMall];
//    }
}
- (void)goBackbeansMall
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    AppDelegate *del = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    [del.tabBarController setSelectedIndex:3];
    
    UCFWebViewJavascriptBridgeMall *mallWeb = [[UCFWebViewJavascriptBridgeMall alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
    mallWeb.url = MALLURL;
    mallWeb.rootVc = self;
    mallWeb.isHideNavigationBar = YES;
//    [self useragent:mallWeb.webView];
    mallWeb.navTitle = @"豆哥商城";
//    mallWeb.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    UINavigationController *mallWebNaviController = [[UINavigationController alloc] initWithRootViewController:mallWeb];
    //        SecondViewController *vc1 = [[SecondViewController alloc]init];
    //        UITableViewController *settingVC = [[UITableViewController alloc]init];
//    self.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:mallWebNaviController animated:YES completion:nil];
    [self.navigationController pushViewController:mallWeb animated:YES];

    
}
// 按钮动作-跳转到工分说明WHL
- (void)rightClicked:(UIButton *)button
{
    UCFWebViewJavascriptBridgeLevel *subVC = [[UCFWebViewJavascriptBridgeLevel alloc]initWithNibName:@"UCFWebViewJavascriptBridgeLevel" bundle:nil];
    subVC.navTitle = @"玩转工分";
    subVC.url      = LEVELURLXIANGQING;
    [self.navigationController pushViewController:subVC animated:YES];
}
// 按钮动作-点击锁按钮后弹出提示框
- (IBAction)buttonLockShowMessgae:(id)sender {
    
    UIAlertView * aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前工分账户涉嫌违规操作已被禁用,如有问题请联系客服。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"联系客服", nil];
    
    [aler show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006766988"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addRightButtonWithName:(NSString *)rightButtonName
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 70, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [rightbutton addTarget:self action:@selector(rightClicked:) forControlEvents:UIControlEventTouchUpInside];
//    rightbutton.titleLabel.textColor = [UIColor whiteColor];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    
    
        [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)dealloc{
    
}

@end
