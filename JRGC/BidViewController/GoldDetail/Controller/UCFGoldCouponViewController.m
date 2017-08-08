//
//  UCFGoldCouponViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/8/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCouponViewController.h"
#import "UCFGoldCouponCell.h"
#import "UCFGoldCouponModel.h"
#import "UILabel+Misc.h"
@interface UCFGoldCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (strong, nonatomic) IBOutlet UILabel *remainGoldAccountLab;
@property (strong, nonatomic) IBOutlet UILabel *needGoldAccountLab;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (strong, nonatomic) IBOutlet UILabel *selectTipStr;
@property (nonatomic,strong)NSMutableArray *selectCellDataArray;
@property (nonatomic,assign) int pageNo;
@property (nonatomic,assign) int totalPage;//返金劵的总数
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickAllSelectBtn:(UIButton *)sender;
- (IBAction)ClickConfirmUseGoldCoupon:(id)sender;
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
    
    
    self.dataArray  = [NSMutableArray arrayWithCapacity:0];
    self.selectCellDataArray = [NSMutableArray arrayWithCapacity:0];
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
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr1 = @"UCFGoldCouponCell";
    UCFGoldCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr1];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldCouponCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    cell.cellBtn.tag = 100+indexPath.row;
    [cell.cellBtn addTarget:self action:@selector(clickGoldCouponCellBtn:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFGoldCouponModel * model =   [self.dataArray objectAtIndex:indexPath.row];
    model.isSelectedStatus = !model.isSelectedStatus;
    [self.tableView reloadData];
    [self changeGoldCellSelectStatus];
}
-(void)clickGoldCouponCellBtn:(UIButton *)btn
{
  btn.selected = !btn.selected;
  UCFGoldCouponModel * model =   [self.dataArray objectAtIndex:btn.tag -100];
  model.isSelectedStatus = btn.selected;
  [self.tableView reloadData];
  [self changeGoldCellSelectStatus];
}
-(void)changeGoldCellSelectStatus
{
    int cellSelectCount = 0 ;//已选张数
    double tatolGetGoldAccout = 0;//可返金克重
    for (UCFGoldCouponModel *model in self.dataArray) {
        if (model.isSelectedStatus) {
            cellSelectCount++;
            tatolGetGoldAccout += [model.goldAccount doubleValue];
        }
    }
    self.allSelectBtn.selected = cellSelectCount == self.totalPage;
    NSString *cellSelectCountStr = [NSString stringWithFormat:@"%d",cellSelectCount];
    NSString *tatolGetGoldAccoutStr = [NSString stringWithFormat:@"%.3lf",tatolGetGoldAccout];
    self.selectTipStr.text = [NSString stringWithFormat:@"已选用%@张，可返金%@克",cellSelectCountStr,tatolGetGoldAccoutStr];
    [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:cellSelectCountStr];
    [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:tatolGetGoldAccoutStr];
}

- (IBAction)clickAllSelectBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        for (UCFGoldCouponModel *model in self.dataArray) {
           model.isSelectedStatus = YES;
        }
        [self.tableView reloadData];
    }
    
    
    
    
}
-(void)getGoldCouponListHttpRequest
{
    /*
     nmPrdClaimId	黄金标ID	string
     pageNo	页号	string
     pageSize	页面大小	string
     userId	用户ID	string
     
     */
    
    if ([self.tableView.header isRefreshing]) {
        self.pageNo = 1;
    }else if([self.tableView.footer isRefreshing]){
        self.pageNo ++;
    }

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
    {//黄金购买
        if ([rstcode boolValue]) {
            
            NSDictionary *pageData = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"];
            self.totalPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectForKey:@"totalPage"] intValue];
             NSArray *resultDataArray  = [pageData objectSafeArrayForKey:@"result"] ;
            if(_pageNo == 1)
            {
                [self.dataArray removeAllObjects];
                if (resultDataArray.count < 10) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            if(_pageNo <= _totalPage)
            {
                _pageNo++;
            }
            else
            {
                [self.tableView.footer noticeNoMoreData];
            }
            for (NSDictionary *dataDict in resultDataArray) {
                UCFGoldCouponModel *model = [[UCFGoldCouponModel alloc]initWithDictionary:dataDict];
                [self.dataArray addObject:model];
            }
            for (int i = 0; i < self.dataArray.count; i++) {
                [self.selectCellDataArray addObject:@"0"];
            }
            [self.tableView reloadData];
        }
        
        
        
        
     
    }
    
    if (tag.integerValue == kSXTagGetGoldProClaimDetail)
    {
        
    }
    
    [self endRefreshing];
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    [self endRefreshing];
}
#pragma mark 停止刷新
- (void)endRefreshing{
    if (self.tableView.header.isRefreshing) {
          [self.tableView.header endRefreshing];
    }
    if (self.tableView.footer.isRefreshing) {
           [self.tableView.footer endRefreshing];
    }
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

- (IBAction)ClickConfirmUseGoldCoupon:(id)sender {
}

@end
