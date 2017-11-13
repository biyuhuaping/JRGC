//
//  UCFExtractGoldViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/3.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFDrawGoldViewController.h"
#import "UILabel+Misc.h"
#import "UCFExtractViewCell.h"
#import "UCFDrawGoldModel.h"
#import "FullWebViewController.h"
#import "UCFDrawGoldHeaderView.h"
#import "MjAlertView.h"
#import "UCFGoldRechargeViewController.h"
#import "UCFNoDataView.h"
#import "UCFExtractGoldDetailController.h"
@interface UCFDrawGoldViewController ()<UITableViewDataSource,UITableViewDelegate,UCFExtractViewCellDelegate,UCFDrawGoldHeaderViewDelegate,MjAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *gotoNextButton;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel1;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel2;
@property (strong ,nonatomic) NSMutableArray * dataArray;
@property (strong ,nonatomic) NSString *nmGoldAmount;//可提金的克重
@property (strong, nonatomic) IBOutlet UIImageView *shaowImageView;
@property (strong, nonatomic)UILabel *goldAccoutLabel;
@property (strong ,nonatomic)NSString *rate;//提金费率
@property (strong ,nonatomic)NSString *goodsDetailUrl;
@property (strong ,nonatomic)UCFDrawGoldHeaderView *headerView;
@property (strong ,nonatomic)MjAlertView *alertView;
@property (strong ,nonatomic)NSString *needAmountStr;//提金是余额不足时需要充值的金额
@property (nonatomic, strong) UCFNoDataView *noDataView;                 // 无数据界面
- (IBAction)gotoNextBtn:(id)sender;

@end

@implementation UCFDrawGoldViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"提金";
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
//     tapGesture.delegate = self;
//    [self.tableView addGestureRecognizer:tapGesture];
  
    self.tableView.delegate =  self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [self createHeaderView];
    self.tableView.tableFooterView = [self createFooterView];
    _tipLabel1.text = [NSString stringWithFormat:@"已选提金克重0.000克；"];
    [_tipLabel1 setFontColor:UIColorWithRGB(0xffc027) string:@"0.000"];
    _tipLabel2.text = [NSString stringWithFormat:@"提金手续费0.00元"];
    [_tipLabel2 setFontColor:UIColorWithRGB(0x333333) string:@"0.00"];
    _gotoNextButton.backgroundColor = UIColorWithRGB(0xcccccc);
    _gotoNextButton.userInteractionEnabled = NO;
    [self getGoldGoodsInfoHttpRequest];
    
    UIImage *bgShadowImage= [UIImage imageNamed:@"tabbar_shadow.png"];
    self.shaowImageView.image = [bgShadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeTile];
    

    _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight-NavigationBarHeight) errorTitle:@"暂无数据"];
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];
}

-(UIView *)createHeaderView
{
    UIView  *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,125 + 47)];
    headerView.backgroundColor= [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, ScreenWidth-30, 15)];
    titleLabel.textColor = UIColorWithRGB(0x555555);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"可提取黄金克重";
    [headerView addSubview:titleLabel];

    
    _goldAccoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 10, ScreenWidth-30,24)];
    _goldAccoutLabel.textColor = UIColorWithRGB(0xffc027);
    _goldAccoutLabel.font = [UIFont systemFontOfSize:30];
    _goldAccoutLabel.textAlignment = NSTextAlignmentCenter;
    _goldAccoutLabel.text = @"0.000克";
    [_goldAccoutLabel setFont:[UIFont systemFontOfSize:16] string:@"克"];
    [headerView addSubview:_goldAccoutLabel];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, ScreenWidth, 47)];
    downView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    UIView *topView =[[UIView alloc] init];
    topView.backgroundColor = UIColorWithRGB(0xEBEBEE);;
    topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
    [downView addSubview:topView];
    
    UILabel *commendLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 , 10 + (37 - 14)/2, 120, 14)];
    commendLabel.text = @"请选择规格数量";
    commendLabel.font = [UIFont systemFontOfSize:14.0f];
    commendLabel.textColor = UIColorWithRGB(0x555555);
    [downView addSubview:commendLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 15-7 , 10 + (37 - 11)/2, 7, 11)];
    arrowImageView.image = [UIImage imageNamed:@"home_arrow_blue"];
    [downView addSubview:arrowImageView];
    UILabel *commendLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImageView.frame) - 10 - 120 , 10 + (37 - 15)/2, 120, 15)];
    commendLabel1.text = @"查看详情";
    commendLabel1.textAlignment = NSTextAlignmentRight;
    commendLabel1.font = [UIFont systemFontOfSize:14.0f];
    commendLabel1.textColor = UIColorWithRGB(0x4AA1F9);
    [downView addSubview:commendLabel1];
    
    UIButton *goldGoodsDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goldGoodsDetailBtn.backgroundColor = [UIColor clearColor];
    goldGoodsDetailBtn.frame = CGRectMake(0 , 10, ScreenWidth,37);
    [goldGoodsDetailBtn addTarget:self action:@selector(clickGoldGoodsDetail) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:goldGoodsDetailBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [downView addSubview:lineView];
    [headerView addSubview:downView];
    return headerView;
}
-(UIView *)createHeaderView1
{
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"UCFDrawGoldHeaderView" owner:nil options:nil] firstObject];
    _headerView.frame =  CGRectMake(0, 0, ScreenWidth, 172);
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.delegate = self;
    [_headerView.goldAmountLabel setFont:[UIFont systemFontOfSize:16] string:@"克"];
    return _headerView;
}
-(void)clickGoldGoodsDetail
{

    FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:self.goodsDetailUrl title:@"详情"];
    webView.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webView animated:YES];
}
-(UIView *)createFooterView
{
    UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,30)];
    footView.backgroundColor =UIColorWithRGB(0xebebee);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, ScreenWidth-30, 15)];
    titleLabel.textColor = UIColorWithRGB(0x999999);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"提金服务由运营方承担";
    [footView addSubview:titleLabel];
    return footView;
}
#pragma TebleViewDetegate
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return  [self createHeaderView1];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return  [self createFooterView];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellindifier = @"UCFExtractViewCell";
    UCFExtractViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFExtractViewCell" owner:nil options:nil]firstObject];
    }
    cell.delegate = self;
    if (indexPath.row < _dataArray.count)
    {
        UCFDrawGoldModel *goldModel = [_dataArray objectAtIndex:indexPath.row];
        cell.goldModel = goldModel;
    }
    
    return cell;
}
-(void)clickGoldGoodsDetailBtn:(UCFExtractViewCell *)cell
{
 
//    [self clickGoldGoodsDetail];
    NSString *webUrlStr = cell.goldModel.introductionPageUrl;
    NSString *title = cell.goldModel.goldGoodsName;
    DLog(@"webUrlStr--->>>>%@   %@",webUrlStr,title);
    FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:webUrlStr title:title];
    webView.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webView animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     UCFDrawGoldModel *goldModel = [_dataArray objectAtIndex:indexPath.row];
     FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:goldModel.introductionPageUrl title:goldModel.goldGoodsName];
        webView.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webView animated:YES];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (void)clickSubtractBtnCell:(UCFExtractViewCell *)cell withgoldModel:(UCFDrawGoldModel *)goldModel;
{
    int goodsNumber   =  [goldModel.goodsNumber intValue];
    if (goodsNumber > 0)
    {
        goodsNumber --;
        goldModel.subtractBtnStatus = goodsNumber != 0;
        goldModel.goodsNumber = [NSString stringWithFormat:@"%d",goodsNumber];
        cell.goldGoodsNumberLabel.text = [NSString stringWithFormat:@"%d",goodsNumber];
        [self changeGoldAddOrSubtractStuaus:goldModel];
    }
}
- (void)clickAddBtnCell:(UCFExtractViewCell *)cell withgoldModel:(UCFDrawGoldModel *)goldModel;
{
    int goodsNumber   =  [goldModel.goodsNumber intValue];
    goodsNumber ++;
    goldModel.subtractBtnStatus = goodsNumber != 0;
    goldModel.goodsNumber = [NSString stringWithFormat:@"%d",goodsNumber];
    cell.goldGoodsNumberLabel.text = [NSString stringWithFormat:@"%d",goodsNumber];
    [self changeGoldAddOrSubtractStuaus:goldModel];
}
#define 改变加减号的状态
-(void)changeGoldAddOrSubtractStuaus:(UCFDrawGoldModel *)goldGoodsModel
{
    //第一步 计算已知买的黄金克重
    double  buyedGoldGoodsAmount = 0.00;
    for (UCFDrawGoldModel * goldModel in _dataArray)
    {
        buyedGoldGoodsAmount += [goldModel.goldAmount doubleValue] * [goldModel.goodsNumber doubleValue];
    }
    //第二步 计算剩余克重
    double remainGoldGoodsAmount = [_nmGoldAmount doubleValue] - buyedGoldGoodsAmount;
    
    //第三步 根据剩余克重 更新每个标准的可否点击加号的状态
    for (UCFDrawGoldModel * goldModel in _dataArray)
    {
        goldModel.addBtnStatus = [goldModel.goldAmount doubleValue] <= remainGoldGoodsAmount;
        goldModel.subtractBtnStatus = [goldModel.goodsNumber intValue] > 0;
        goldModel.numberBtnStatus = goldModel.addBtnStatus || (!goldModel.addBtnStatus && [goldModel.goodsNumber intValue] > 0);
    }
    NSString *buyedGoldGoodsAmountStr = [NSString stringWithFormat:@"%.3lf",buyedGoldGoodsAmount];
    NSString *feeStrGoldGoodsAmount = [NSString stringWithFormat:@"%.2lf",buyedGoldGoodsAmount *  [_rate doubleValue]];
    _tipLabel1.text = [NSString stringWithFormat:@"已选提金克重%@克；",buyedGoldGoodsAmountStr];
    [_tipLabel1 setFontColor:UIColorWithRGB(0xffc027) string:buyedGoldGoodsAmountStr];
    _tipLabel2.text = [NSString stringWithFormat:@"提金手续费%@元",feeStrGoldGoodsAmount];
    [_tipLabel2 setFontColor:UIColorWithRGB(0x333333) string:feeStrGoldGoodsAmount];
    _gotoNextButton.backgroundColor = buyedGoldGoodsAmount == 0 ? UIColorWithRGB(0xcccccc) : UIColorWithRGB(0xffc027);
    _gotoNextButton.userInteractionEnabled = buyedGoldGoodsAmount != 0;
    [self.tableView reloadData];
}
#pragma mark -活期详情页面数据请求
-(void)getGoldGoodsInfoHttpRequest
{
    NSDictionary *strParameters  = @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID] };
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetNmDrawGoldGoodsInfo owner:self signature:YES Type:SelectAccoutTypeGold];
    
}
- (void)beginPost:(kSXTag)tag
{
   [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = [dic objectSafeForKey:@"message"];
    int code = [[dic objectSafeForKey:@"code"]intValue];
    if (tag.integerValue == kSXTagGetNmDrawGoldGoodsInfo) {
        if ([rstcode intValue] == 1)
        {
            NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
            
            self.goodsDetailUrl = [dataDict objectSafeForKey:@"goodsDetail"];
            self.nmGoldAmount = [dataDict objectSafeForKey:@"nmGoldAmount"];
           
            _goldAccoutLabel.text = [NSString stringWithFormat:@"%@克",self.nmGoldAmount];;
//             _headerView.goldAmountLabel.text = [NSString stringWithFormat:@"%@克",self.nmGoldAmount];;
//            [_headerView.goldAmountLabel setFont:[UIFont systemFontOfSize:16] string:@"克"];
            self.rate  = [dataDict objectSafeForKey:@"rate"];
            NSArray *goodsListArry = [dataDict objectSafeArrayForKey:@"goodsList"];
            _dataArray = [[NSMutableArray alloc]initWithCapacity:goodsListArry.count];
            for (NSDictionary * dic in goodsListArry)
            {
                UCFDrawGoldModel *goldModel = [UCFDrawGoldModel goldModelWithDict:dic];
                goldModel.addBtnStatus = [goldModel.goldAmount doubleValue] <=   [_nmGoldAmount doubleValue];
                goldModel.subtractBtnStatus = NO;
                goldModel.numberBtnStatus = goldModel.addBtnStatus;
                goldModel.goodsNumber = @"0";
                [_dataArray addObject:goldModel];
            }
            [self.tableView reloadData];
        }
        else{
            _noDataView.hidden = NO;
             [MBProgressHUD displayHudError:rsttext];
        }
    }
    else if (tag.integerValue == kSXTagDrawGoldGoodsInfoSubmit) {
        /*
         
         
         变量名    含义    类型    备注
         code        number    -102, "已选提金克重不可超过可提取黄金克",-103, "您的账户余额不足以支付提取黄金手续费,请充值"
         data        object
         needAmount    手续费差额    string    code为-103时,有此参数
         params    参数    object
         url    链接    string    @mock=http://www.baidu.com
         message        string    @mock=获取成功
         ret        boolean    @mock=true
         ver        number    @mock=1
         
         {"ret":true,"code":10000,"message":"获取成功","ver":1,"data":{"params":{},"url":"http://ugolden.bjlhhr.com/gold-wallet-ff/index.html#/create/d60c40398e174e3081522987dc063dff"}}
         */
            if ([rstcode intValue] == 1)
            {
                NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
                NSString *urlStr = [dataDict objectSafeForKey:@"url"];
                UCFExtractGoldDetailController *extractGoldDetailWeb = [[UCFExtractGoldDetailController alloc] initWithNibName:@"UCFWebViewJavascriptBridgeMall" bundle:nil];
                extractGoldDetailWeb.url = urlStr;
                [self.navigationController pushViewController:extractGoldDetailWeb animated:YES];
            }
            else{
                
                if (code == -102)
                {//"已选提金克重不可超过可提取黄金克"
                    
                }
                else if (code == -103)//"您的账户余额不足以支付提取黄金手续费,请充值"  bbbbbbbbbbbbb
                {
                    NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
                    self.needAmountStr = [dataDict objectSafeForKey:@"needAmount"];
                     _alertView = [[MjAlertView alloc]initDrawGoldRechangeAlertType:MjAlertViewTypeDrawGoldRechane withMessage:rsttext delegate:self];
                    [_alertView show];
                }
            }
        }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    if (tag.integerValue == kSXTagGetNmDrawGoldGoodsInfo)
    {
        _noDataView.hidden = NO;
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoNextBtn:(id)sender
{
    /*
     goodsAmount    金条克重(克)    string    多规格用逗号(,)隔开
     goodsId    金条id    string    多规格用逗号(,)隔开
     goodsNum    金条数量    string    多规格用逗号(,)隔开
     orderId    订单号    string    从订单列表里提交传此参数
     userId        string
     */
    NSMutableString *goodsIdsArryStr = [[NSMutableString alloc] initWithCapacity:0];
    NSMutableString *goodsAmountStr = [[NSMutableString alloc] initWithCapacity:0];
    NSMutableString *goodsNumsArryStr = [[NSMutableString alloc] initWithCapacity:0];
    [goodsIdsArryStr setString:@""];
    int  buyedGoldGoodsCount = 0;
    for ( int i = 0 ;i < _dataArray.count;i++) {
        UCFDrawGoldModel *goldModel = _dataArray[i];
        if([goldModel.goodsNumber intValue] > 0)
        {
            buyedGoldGoodsCount ++;
            NSString *goodsIdStr =  [NSString stringWithFormat:@"%@",goldModel.goodsId];
            if (buyedGoldGoodsCount == 1) {
                [goodsIdsArryStr appendFormat:@"%@",goodsIdStr];
                [goodsAmountStr appendFormat:@"%@",goldModel.goldAmount];
                [goodsNumsArryStr appendFormat:@"%@",goldModel.goodsNumber];
            }else{
                [goodsIdsArryStr appendFormat:@",%@",goodsIdStr];
                [goodsAmountStr appendFormat:@",%@",goldModel.goldAmount];
                [goodsNumsArryStr appendFormat:@",%@",goldModel.goodsNumber];
            }
        }
    }
    NSDictionary *strParameters  = @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"goodsAmount":goodsAmountStr,@"goodsId":goodsIdsArryStr,@"goodsNum":goodsNumsArryStr};
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagDrawGoldGoodsInfoSubmit owner:self signature:YES Type:SelectAccoutTypeGold];
}
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index;
{
    //去充值页面
    if (index== 101)
    {
        UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
        goldRecharge.baseTitleText = @"充值";
        goldRecharge.needToRechareStr =self.needAmountStr;
        goldRecharge.rootVc = self;
        [self.navigationController pushViewController:goldRecharge animated:YES];
    }
}
@end
