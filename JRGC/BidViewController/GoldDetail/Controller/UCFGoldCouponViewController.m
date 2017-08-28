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
@property (strong, nonatomic) IBOutlet UIButton *confirmUseGoldCouponBtn;

@property (strong, nonatomic) IBOutlet UIButton *allSelectBtn;
@property (strong, nonatomic) IBOutlet UILabel *remainGoldAccountLab;
@property (strong, nonatomic) IBOutlet UILabel *needGoldAccountLab;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *baseShadowView;

@property (strong, nonatomic) IBOutlet UILabel *selectTipStr;
@property (nonatomic,strong)NSMutableArray *selectCellDataArray;
@property (nonatomic,strong)NSDictionary *allSelectDataDict;
@property (nonatomic,assign) int pageNo;
@property (nonatomic,assign) int totalPage;//返金劵的总页数
@property (nonatomic,assign) int totalCount;
@property (nonatomic,assign) double tatolGetGoldAccout ;//可返金克重
@property (nonatomic,assign) double tatolNeetGoldAccout ;//需投总克重
@property (nonatomic,strong) NSString *cellSelectCountStr;//选择返金劵的张数
@property (nonatomic,strong)NSMutableString *goldRecordidsStr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickAllSelectBtn:(UIButton *)sender;
- (IBAction)ClickConfirmUseGoldCoupon:(id)sender;
@end

@implementation UCFGoldCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"使用返金券";
    [self addLeftButton];

    self.remainGoldAccountLab.text = [NSString stringWithFormat:@"%@克",self.remainAmountStr];
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImage *bgShadowImage= [UIImage imageNamed:@"tabbar_shadow.png"];
    self.baseShadowView.image = [bgShadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeTile];
    
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
    _tatolGetGoldAccout = 0;//可返金克重
    _tatolNeetGoldAccout = 0 ;//需投总克重
    self.goldRecordidsStr = [NSMutableString stringWithFormat:@""];
    for (UCFGoldCouponModel *model in self.dataArray) {
        if (model.isSelectedStatus) {
            cellSelectCount++;
            _tatolGetGoldAccout += [model.goldAccount doubleValue];
            _tatolNeetGoldAccout += [model.investMin doubleValue];
            if (cellSelectCount == 1) {
                [self.goldRecordidsStr appendString:model.goldCouponId];
            }else{
                 [self.goldRecordidsStr appendFormat:@",%@",model.goldCouponId];
            }
        }
    }
    self.cellSelectCountStr = [NSString stringWithFormat:@"%d",cellSelectCount];
    NSString *tatolGetGoldAccoutStr = [NSString stringWithFormat:@"%.3lf",_tatolGetGoldAccout];
    self.selectTipStr.text = [NSString stringWithFormat:@"已选用%@张，可返金%@克",_cellSelectCountStr,tatolGetGoldAccoutStr];
    self.needGoldAccountLab.text = [NSString stringWithFormat:@"%.3lf克",_tatolNeetGoldAccout];
    [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:_cellSelectCountStr];
    [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:tatolGetGoldAccoutStr];
    if (_tatolNeetGoldAccout > [self.remainAmountStr doubleValue]) {
        self.confirmUseGoldCouponBtn.userInteractionEnabled = NO;
        [self.confirmUseGoldCouponBtn setBackgroundColor:UIColorWithRGB(0xcccccc)];
    }else{
        self.confirmUseGoldCouponBtn.userInteractionEnabled = YES;
        [self.confirmUseGoldCouponBtn setBackgroundColor:UIColorWithRGB(0xFFC027)];
    }
}

- (IBAction)clickAllSelectBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        for (UCFGoldCouponModel *model in self.dataArray) {
           model.isSelectedStatus = YES;
        }
        NSDictionary *paramDict = @{@"nmPrdClaimId": _nmPrdClaimIdStr,@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]};
        [[NetworkModule sharedNetworkModule] newPostReq:paramDict tag:kSXTagGelectALLGoldCoupon owner:self signature:YES Type:SelectAccoutTypeGold];
        [self.tableView reloadData];
    }else{
        for (UCFGoldCouponModel *model in self.dataArray) {
            model.isSelectedStatus = NO;
        }
        [self.tableView reloadData];
        [self changeGoldCellSelectStatus];
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
    }

    NSString *pageNoStr = [NSString stringWithFormat:@"%d",self.pageNo];
    NSDictionary *paramDict = @{@"nmPrdClaimId": _nmPrdClaimIdStr,@"pageNo":pageNoStr,@"pageSize": @"20",@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"workshopCode":@""};
    
    [[NetworkModule sharedNetworkModule] newPostReq:paramDict tag:kSXTagGetGoldCouponList owner:self signature:YES Type:SelectAccoutTypeGold];
}
-(void)beginPost:(kSXTag)tag
{
    if(tag !=kSXTagGelectALLGoldCoupon)
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
            self.tableView.footer.hidden = NO;
            NSDictionary *pageData = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"];
            self.totalPage = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"totalPage"] intValue];
            self.totalCount = [[[pageData objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"totalCount"] intValue];
             NSArray *resultDataArray  = [pageData objectSafeArrayForKey:@"result"] ;
            if(_pageNo == 1)
            {
                [self.dataArray removeAllObjects];
                if (resultDataArray.count < 20) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            if(_pageNo <= _totalPage)
            {
                _pageNo++;
                if (resultDataArray.count < 20) {
                    [self.tableView.footer noticeNoMoreData];
                }
            }
            else
            {
                [self.tableView.footer noticeNoMoreData];
            }
            for (NSDictionary *dataDict in resultDataArray) {
                UCFGoldCouponModel *model = [[UCFGoldCouponModel alloc]initWithDictionary:dataDict];
                [self.dataArray addObject:model];
            }
            [self changeGoldCellSelectStatus];
            if (self.selectGoldCouponDict) {
                [self changeSelectGoldState];
            }
            [self.tableView reloadData];
        }
    }
    if (tag.integerValue == kSXTagGelectALLGoldCoupon)
    {
        if ([rstcode boolValue]) {
            
            //  goldAccountSum	黄金券返金总克重	string
            //goldRecordids	选中的黄金券ID	string	用逗号隔开
            //investMinSum	需要投资的总克重	string
            NSDictionary *dataDict  = [dic objectSafeDictionaryForKey:@"data"];
            self.allSelectDataDict = dataDict;
            self.cellSelectCountStr = [NSString stringWithFormat:@"%d",_totalCount];
            
             _tatolGetGoldAccout =  [[dataDict objectSafeForKey:@"goldAccountSum"] doubleValue];
            
            NSString *tatolGetGoldAccoutStr = [NSString stringWithFormat:@"%.3lf",_tatolGetGoldAccout];
           
            self.selectTipStr.text = [NSString stringWithFormat:@"已选用%@张，可返金%@克",self.cellSelectCountStr,tatolGetGoldAccoutStr];
            [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:self.cellSelectCountStr];
            [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:tatolGetGoldAccoutStr];
        
            
            _tatolNeetGoldAccout = [[dataDict objectSafeForKey:@"investMinSum"] doubleValue];
            
            NSString *investMinSumStr = [NSString stringWithFormat:@"%.3lf",_tatolNeetGoldAccout];
            self.needGoldAccountLab.text = [NSString stringWithFormat:@"%@克",investMinSumStr];
            if ([investMinSumStr doubleValue] > [self.remainAmountStr doubleValue]) {
                self.confirmUseGoldCouponBtn.userInteractionEnabled = NO;
                [self.confirmUseGoldCouponBtn setBackgroundColor:UIColorWithRGB(0xcccccc)];
            }else{
                self.confirmUseGoldCouponBtn.userInteractionEnabled = YES;
                [self.confirmUseGoldCouponBtn setBackgroundColor:UIColorWithRGB(0xFFC027)];
            }
        }else{
        
              [AuxiliaryFunc showAlertViewWithMessage:message];
        }
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

-(void)changeSelectGoldState
{
    int cellSelectCount = [[self.selectGoldCouponDict objectSafeForKey:@"selectedGoldCouponNum"] intValue]  ;//已选张数
    _tatolGetGoldAccout = [[self.selectGoldCouponDict objectSafeForKey:@"goldAccountSum"] doubleValue];//可返金克重
    _tatolNeetGoldAccout = [[self.selectGoldCouponDict objectSafeForKey:@"investMinSum"] doubleValue] ;//需投总克重
    self.goldRecordidsStr = [self.selectGoldCouponDict objectSafeForKey:@"goldRecordids"];
    
    NSArray *selectGoldCouonArray  = [self.goldRecordidsStr  componentsSeparatedByString:@","];
    for (NSString *selectModelStr in selectGoldCouonArray)
    {
        for (UCFGoldCouponModel *model in self.dataArray) {
            if ([model.goldCouponId isEqualToString:selectModelStr]) {
                model.isSelectedStatus = YES;
                break;
            }
        }
    }
    self.cellSelectCountStr = [NSString stringWithFormat:@"%d",cellSelectCount];
    NSString *tatolGetGoldAccoutStr = [NSString stringWithFormat:@"%.3lf",_tatolGetGoldAccout];
    self.selectTipStr.text = [NSString stringWithFormat:@"已选用%@张，可返金%@克",_cellSelectCountStr,tatolGetGoldAccoutStr];
    self.needGoldAccountLab.text = [NSString stringWithFormat:@"%.3lf克",_tatolNeetGoldAccout];
    [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:_cellSelectCountStr];
    [self.selectTipStr setFontColor:UIColorWithRGB(0xfc8c0e) string:tatolGetGoldAccoutStr];
    if (_tatolNeetGoldAccout > [self.remainAmountStr doubleValue] ) {
        self.confirmUseGoldCouponBtn.userInteractionEnabled = NO;
        [self.confirmUseGoldCouponBtn setBackgroundColor:UIColorWithRGB(0xcccccc)];
    }else{
        self.confirmUseGoldCouponBtn.userInteractionEnabled = YES;
        [self.confirmUseGoldCouponBtn setBackgroundColor:UIColorWithRGB(0xFFC027)];
    }
    self.selectGoldCouponDict = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ClickConfirmUseGoldCoupon:(id)sender
{

    /*
     goldAccountSum	黄金券返金总克重	string
     goldRecordids	选中的黄金券ID	string	用逗号隔开
     investMinSum	需要投资的总克重	string
     */
    NSString *investMinSumStr  = [NSString stringWithFormat:@"%.0lf",_tatolNeetGoldAccout];
    if ([investMinSumStr doubleValue] > [self.remainAmountStr doubleValue]) {
        return;
    }
    if (_tatolGetGoldAccout == 0 || _tatolNeetGoldAccout == 0) {//没有选择时，直接返回空
        [self.delegate getSelectedGoldCouponNum:nil];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (self.allSelectBtn.selected) {//如果是全选,则用服务端的数据
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.allSelectDataDict];
        [dic setObject:self.cellSelectCountStr forKey:@"selectedGoldCouponNum"];
        [self.delegate getSelectedGoldCouponNum:dic];
    }else{
        NSString *tatolGetGoldAccoutStr = [NSString stringWithFormat:@"%.3lf",_tatolGetGoldAccout];
        
        [self.delegate getSelectedGoldCouponNum:@{@"goldAccountSum":tatolGetGoldAccoutStr,
                                                  @"investMinSum":investMinSumStr,
                                                  @"goldRecordids":self.goldRecordidsStr,
                                                  @"selectedGoldCouponNum":self.cellSelectCountStr}];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
