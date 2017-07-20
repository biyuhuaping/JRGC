//
//  UCFGoldAccountViewController.m
//  JRGC
//
//  Created by 金融工场 on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldAccountViewController.h"
#import "UCFGoldAccountHeadView.h"
#import "UCFSettingItem.h"
#import "UCFCellStyleModel.h"
#import "UCFGoldCashViewController.h"
#import "GoldTransactionRecordViewController.h"
#import "UCFGoldRechargeViewController.h"
#import "GoldAccountFirstCell.h"
#import "UCFMyGoldInvestInfoViewController.h"
#import "UCFGoldCashMoneyViewController.h"
#import "UCFNoDataView.h"
#import "UCFGoldAuthorizationViewController.h"
#import "UserInfoSingle.h"
#import "HSHelper.h"
#import "UCFExtractGoldViewController.h"


@interface UCFGoldAccountViewController ()<UITableViewDelegate,UITableViewDataSource, GoldAccountFirstCellDeleage>
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (weak, nonatomic) IBOutlet UIButton *buyGoldBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsBtn;
@property (weak, nonatomic) IBOutlet UIButton *goldCashBtn;
@property (strong, nonatomic) UCFGoldAccountHeadView *headerView;
@property (strong, nonatomic) NSMutableArray    *dataArray;

@property (copy, nonatomic)NSString     *availableGoldAmount;  //可用黄金克重
@property (copy, nonatomic)NSString     *balanceAmount;        //账户余额
@property (copy, nonatomic)NSString     *collectGoldAmount;    //待收黄金克重
@property (copy, nonatomic)NSString     *dealPrice;            //成交均价
@property (copy, nonatomic)NSString     *holdGoldAmount;       //持有黄金克重

@end

@implementation UCFGoldAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 210);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark NetData
- (void)getNetData
{
    NSDictionary *parametersDict =  @{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID]};
    self.accoutType = SelectAccoutDefault;
    [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagGoldAccount owner:self signature:YES Type:self.accoutType];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    BOOL ret = [[dic objectSafeForKey:@"ret"] boolValue];
    NSString *rsttext =  [dic objectSafeForKey:@"message"];
    if(tag.integerValue == kSXTagGoldAccount) {
        if (ret) {
            NSDictionary *dataDict = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
            self.availableGoldAmount = [dataDict objectSafeForKey:@"availableGoldAmount"];
            self.balanceAmount = [dataDict objectSafeForKey:@"balanceAmount"];
            self.collectGoldAmount = [dataDict objectSafeForKey:@"collectGoldAmount"];
            self.dealPrice = [dataDict objectSafeForKey:@"dealPrice"];
            self.holdGoldAmount = [dataDict objectSafeForKey:@"holdGoldAmount"];
            [_headerView updateGoldAccount:dataDict];
            [self.baseTableView reloadData];
        } else {
            [MBProgressHUD displayHudError:rsttext];
        }
    }
}
#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFCellStyleModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFCellStyleModel *model = self.dataArray[indexPath.row];
    if (model.cellStyle  == CellStyleDefault) {
        static NSString *cellID = @"cellID00";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = UIColorWithRGB(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            UIView *lineView = [Common addSepateViewWithRect:CGRectMake(15, model.cellHeight - 0.5, ScreenWidth, 0.5) WithColor:UIColorWithRGB(0xe3e5ea)];
            lineView.tag = 1000;
            [cell.contentView addSubview:lineView];
        }
        UIView *lineView = [cell.contentView viewWithTag:1000];
        if ([model.leftTitle isEqualToString:@"支付账户"]) {
            lineView.frame = CGRectMake(0, model.cellHeight - 0.5, ScreenWidth, 0.5);
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = UIColorWithRGB(0xf9f9f9);
            cell.textLabel.textColor = UIColorWithRGB(0x333333);
        } else {
            lineView.frame = CGRectMake(15, model.cellHeight - 1, ScreenWidth, 1);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.backgroundColor = [UIColor whiteColor];
            if ([model.leftTitle isEqualToString:@"提金订单"]) {
                lineView.frame = CGRectZero;
            }
        }
        cell.textLabel.text = model.leftTitle;
        return cell;
    } else if (model.cellStyle  == CellSepLine) {
        static NSString *cellID = @"cellID01";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *lineView = [Common addSepateViewWithRect:CGRectMake(0, 0, ScreenWidth, 0.5) WithColor:UIColorWithRGB(0xd8d8d8)];

            UIView *lineView1 = [Common addSepateViewWithRect:CGRectMake(0, model.cellHeight - 0.5, ScreenWidth, 0.5) WithColor:UIColorWithRGB(0xd8d8d8)];
            [cell addSubview:lineView];
            [cell addSubview:lineView1];
            cell.backgroundColor = UIColorWithRGB(0xe3e5ea);
        }
        return cell;
    } else {
        static NSString *cellID = @"cellID02";
        GoldAccountFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"GoldAccountFirstCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = UIColorWithRGB(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            UIView *lineView = [Common addSepateViewWithRect:CGRectMake(0, model.cellHeight - 0.5, ScreenWidth, 0.5) WithColor:UIColorWithRGB(0xe3e5ea)];
            lineView.tag = 1000;
            [cell.contentView addSubview:lineView];
            cell.delegate = self;
            cell.textLabel.text = @"可用余额";
        }
        [cell updateaVailableMoenyLab:self.balanceAmount];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCFCellStyleModel *model  =[self.dataArray objectAtIndex:indexPath.row];
    if ([model.leftTitle isEqualToString:@"已购黄金"]) {
        [self gotoGoldInvestInfoVC];
    } else if ([model.leftTitle isEqualToString:@"提金订单"]) {
        UCFExtractGoldViewController *vc1 = [[UCFExtractGoldViewController alloc] initWithNibName:@"UCFExtractGoldViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    }
}
- (void)initData
{
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    UCFCellStyleModel *model01 = [[UCFCellStyleModel alloc] initWithCellStyle:CellStyleDefault WithLeftTitle:@"已购黄金" WithRightImage:[UIImage imageNamed:@"list_icon_arrow"] WithTargetClassName:@"" WithCellHeight:44 WithDelegate:self];
    UCFCellStyleModel *model02 = [[UCFCellStyleModel alloc] initWithCellStyle:CellStyleDefault WithLeftTitle:@"提金订单" WithRightImage:[UIImage imageNamed:@"list_icon_arrow"] WithTargetClassName:@"" WithCellHeight:44 WithDelegate:self];
    UCFCellStyleModel *model03 = [[UCFCellStyleModel alloc] initWithCellStyle:CellSepLine WithLeftTitle:nil WithRightImage:nil WithTargetClassName:nil WithCellHeight:10 WithDelegate:nil];
    UCFCellStyleModel *model04 = [[UCFCellStyleModel alloc] initWithCellStyle:CellStyleDefault WithLeftTitle:@"支付账户" WithRightImage:nil WithTargetClassName:nil WithCellHeight:37 WithDelegate:self];
    UCFCellStyleModel *model05 = [[UCFCellStyleModel alloc] initWithCellStyle:CellCustom WithLeftTitle:@"可用余额" WithRightImage:nil WithTargetClassName:nil WithCellHeight:44 WithDelegate:self];
    [self.dataArray addObject:model01];
    [self.dataArray addObject:model02];
    [self.dataArray addObject:model03];
    [self.dataArray addObject:model04];
    [self.dataArray addObject:model05];
    //刷新黄金账户数据通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNetData) name:UPDATE_GOLD_ACCOUNT object:nil];
    
}
- (void)initUI
{
    [self addLeftButton];
    [self addRightBtn];
    baseTitleLabel.text = @"黄金账户";
//    self.baseTableView.delegate = self;
//    self.baseTableView.dataSource = self;
    [_buyGoldBtn setBackgroundColor:UIColorWithRGB(0xffc027)];
    [_withdrawalsBtn setBackgroundColor:UIColorWithRGB(0x7C9DC7)];
    [_goldCashBtn setBackgroundColor:UIColorWithRGB(0x7C9DC7)];
    self.baseTableView.backgroundColor = UIColorWithRGB(0xe3e5eb);
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldAccountHeadView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 210);
        self.baseTableView.tableHeaderView = _headerView;
    }
    [self getNetData];
}

- (void)addRightBtn {
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 88, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:@"交易记录" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)clickRightBtn
{
    GoldTransactionRecordViewController *vc1 = [[GoldTransactionRecordViewController alloc] initWithNibName:@"GoldTransactionRecordViewController" bundle:nil];
    [self.navigationController pushViewController:vc1 animated:YES];
}
- (IBAction)bottomButtomClicked:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    NSString *showStr = @"";
    if ([title isEqualToString:@"买金"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    } else if ([title isEqualToString:@"变现"]) {
        showStr = @"暂时没有可变现的黄金";
//        UCFGoldCashViewController *vc1 = [[UCFGoldCashViewController alloc] initWithNibName:@"UCFGoldCashViewController" bundle:nil];
//        [self.navigationController pushViewController:vc1 animated:YES];
    } else if ([title isEqualToString:@"提金"]) {
        showStr = @"暂时没有可提金的黄金";
    }
    [MBProgressHUD displayHudError:showStr];
}
    
#pragma mark - GoldAccountFirstCellDelegate
    
- (void)goldAccountFirstCell:(GoldAccountFirstCell *)goldFirstCell didClickedRechargeButton:(UIButton *)button
{
//        UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
//        goldRecharge.baseTitleText = @"充值";
//        goldRecharge.rootVc = self;
//        [self.navigationController pushViewController:goldRecharge animated:YES];
//        return;
    NSString *tipStr1 = ZXTIP1;
    NSInteger openStatus = [UserInfoSingle sharedManager].openStatus ;
    NSInteger enjoyOpenStatus = [UserInfoSingle sharedManager].enjoyOpenStatus;
    if (openStatus < 3 && enjoyOpenStatus < 3 ) {//去开户页面
        [self showHSAlert:tipStr1];
        return;
    }
    else{
        if(![UserInfoSingle sharedManager].goldAuthorization){//去授权页面
            HSHelper *helper = [HSHelper new];
            [helper pushGoldAuthorizationType:SelectAccoutTypeGold nav:self.navigationController];
            return;
        }else{
            //去充值页面
            UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
            goldRecharge.baseTitleText = @"充值";
            goldRecharge.rootVc = self;
            [self.navigationController pushViewController:goldRecharge animated:YES];
        }
    }
}

- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 8000;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 8000) {
        if (buttonIndex == 1) {
            HSHelper *helper = [HSHelper new];
            [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
        }
    }
}
    
- (void)goldAccountFirstCell:(GoldAccountFirstCell *)goldFirstCell didClickedCashButton:(UIButton *)button
    {
    UCFGoldCashMoneyViewController *goldCashMoney = [[UCFGoldCashMoneyViewController alloc] initWithNibName:@"UCFGoldCashMoneyViewController" bundle:nil];
    goldCashMoney.baseTitleText = @"提现";
    goldCashMoney.balanceMoney = self.balanceAmount;
    [self.navigationController pushViewController:goldCashMoney animated:YES];
}
#pragma 去已购黄金页面
-(void)gotoGoldInvestInfoVC{
    UCFMyGoldInvestInfoViewController *myGoldInvestVC = [[UCFMyGoldInvestInfoViewController alloc] initWithNibName:@"UCFMyGoldInvestInfoViewController" bundle:nil];
    [self.navigationController pushViewController:myGoldInvestVC animated:YES];
}
@end
