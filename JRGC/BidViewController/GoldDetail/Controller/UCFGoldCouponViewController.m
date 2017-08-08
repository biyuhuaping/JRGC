//
//  UCFGoldCouponViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/8/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCouponViewController.h"
#import "UCFGoldCouponCell.h"
@interface UCFGoldCouponViewController ()
@property (nonatomic,assign) int pageNo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UCFGoldCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"返金券";
    [self addLeftButton];
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    
    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getGoldCouponListHttpRequest)];
    
    // 添加上拉加载更多
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getGoldCouponListHttpRequest];
    }];
    self.tableView.footer.hidden = YES;
    [self.tableView.header beginRefreshing];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr1 = @"UCFGoldCouponCell";
    UCFGoldCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr1];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldCouponCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)getGoldCouponListHttpRequest
{
    /*
     nmPrdClaimId	黄金标ID	string
     pageNo	页号	string
     pageSize	页面大小	string
     userId	用户ID	string
     
     */
    
    NSString *pageNoStr = [NSString stringWithFormat:@"%d",self.pageNo];
    NSDictionary *paramDict = @{@"nmPrdClaimId": _nmPrdClaimIdStr,@"pageNo":pageNoStr,@"pageSize": @"20",@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"workshopCode":@""};
    
    [[NetworkModule sharedNetworkModule] newPostReq:paramDict tag:kSXTagGetGoldCouponList owner:self signature:YES Type:SelectAccoutTypeGold];
}
-(void)beginPost:(kSXTag)tag
{
    if(tag !=kSXTagGetGoldProClaimDetail)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}


- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = [dic objectSafeForKey:@"ret"];
    NSString *message = [dic objectSafeForKey:@"message"];
    if (tag.intValue == kSXTagGetGoldCouponList)
    {        //黄金购买
        
        
        
        
        
     
    }
    
    if (tag.integerValue == kSXTagGetGoldProClaimDetail)
    {
        
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    //    if (self.bidTableView.header.isRefreshing) {
    //        [self.bidTableView.header endRefreshing];
    //    }
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
