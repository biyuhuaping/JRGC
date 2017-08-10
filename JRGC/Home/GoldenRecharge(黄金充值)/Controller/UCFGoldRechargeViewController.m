//
//  UCFGoldRechargeViewController.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeViewController.h"
#import "UCFGoldRechargeCell.h"
#import "UCFGoldRechargeModel.h"
#import "UCFGoldRechargeHistoryController.h"
#import "UCFGoldRechargeWebController.h"
#import "UCFContractModel.h"
#import "FullWebViewController.h"
#import "UCFGoldChargeOneCell.h"
#import "UCFGoldChargeSecCell.h"
#import "UCFColdChargeThirdCell.h"
#import "UCFGoldRechargeFourthCell.h"
#import "UCFGoldRechargeBankCell.h"

@interface UCFGoldRechargeViewController () <UITableViewDelegate, UITableViewDataSource, UCFGoldRechargeCellDelegate, UCFGoldChargeSecCellDelegate, UCFColdChargeThirdCellDelegate>
//@property (weak, nonatomic) UCFGoldRechargeHeaderView *goldRechargeHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *backUrl;
@property (strong, nonatomic) NSArray *constracts;
@property (weak, nonatomic) UCFGoldChargeOneCell *chargeOneCell;
@end

@implementation UCFGoldRechargeViewController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSString *)bankUrl
{
    if (nil == _backUrl) {
        _backUrl = [NSString stringWithFormat:@"schem://jinronggongchang/backupper"];
    }
    return _backUrl;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    [self addRightBtn];
    [self createUI];
//    [self initData];
    [self getTipInfoFromNet];
}

- (void)createUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.tableview addGestureRecognizer:tap];
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)getTipInfoFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldRechargeInfo owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)addRightBtn {
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 88, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:@"充值记录" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clickRightBtn
{
    UCFGoldRechargeHistoryController *goldRechargeHistory = [[UCFGoldRechargeHistoryController alloc] initWithNibName:@"UCFGoldRechargeHistoryController" bundle:nil];
    goldRechargeHistory.baseTitleText = @"充值记录";
    [self.navigationController pushViewController:goldRechargeHistory animated:YES];
}

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constraintSize:(CGSize)constraintSize
{
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    CGRect stringRect = [string boundingRectWithSize:constraintSize options:options attributes:attributes context:NULL];
    stringSize = stringRect.size;
    
    return stringSize;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 32;
    }
    else if (section == 1) {
        return 15;
    }
    else if (section == 2) {
        return 0.001;
    }
    else
        return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
    else if (section == 1) {
        return 15;
    }
    else if (section == 2) {
        return 15;
    }
    else
        return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellId = @"goldRechargeSectionHeader";
    UIView *goldRechargeHeader = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == goldRechargeHeader) {
        goldRechargeHeader = [[UIView alloc] init];
        goldRechargeHeader.restorationIdentifier = cellId;
        goldRechargeHeader.backgroundColor = UIColorWithRGB(0xebebee);
    }
    if (section == 0) {
        goldRechargeHeader.frame = CGRectMake(0, 0, ScreenWidth, 32);
    }
    else if (section == 1) {
        goldRechargeHeader.frame = CGRectMake(0, 0, ScreenWidth, 15);
    }
    else if (section == 2) {
        goldRechargeHeader.frame = CGRectMake(0, 0, ScreenWidth, 0.001);
    }
    return goldRechargeHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *cellId = @"goldRechargeSectionFooter";
    UIView *goldRechargeFooter = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == goldRechargeFooter) {
        goldRechargeFooter = [[UIView alloc] init];
        goldRechargeFooter.restorationIdentifier = cellId;
        goldRechargeFooter.backgroundColor = UIColorWithRGB(0xebebee);
    }
    if (section == 1 || section == 2) {
        goldRechargeFooter.frame = CGRectMake(0, 0, ScreenWidth, 15);
    }
    else {
        goldRechargeFooter.frame = CGRectMake(0, 0, ScreenWidth, 0.001);
    }
    return goldRechargeFooter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5) {
        return self.dataArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"goldrechargebank";
        UCFGoldRechargeBankCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldRecharge) {
            goldRecharge = (UCFGoldRechargeBankCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeBankCell" owner:self options:nil] lastObject];
        }
        return goldRecharge;
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = @"goldRechargeFourth";
        UCFGoldRechargeFourthCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldRecharge) {
            goldRecharge = (UCFGoldRechargeFourthCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeFourthCell" owner:self options:nil] lastObject];
        }
        return goldRecharge;
    }
    else if (indexPath.section == 2) {
        static NSString *cellId = @"goldRechargeFirst";
        UCFGoldChargeOneCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldRecharge) {
            goldRecharge = (UCFGoldChargeOneCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldChargeOneCell" owner:self options:nil] lastObject];
        }
        self.chargeOneCell = goldRecharge;
        return goldRecharge;
    }
    else if (indexPath.section == 3) {
        static NSString *cellId = @"goldRechargeSecond";
        UCFGoldChargeSecCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldRecharge) {
            goldRecharge = (UCFGoldChargeSecCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldChargeSecCell" owner:self options:nil] lastObject];
        }
        goldRecharge.constracts = self.constracts;
        goldRecharge.delegate = self;
        return goldRecharge;
    }
    else if (indexPath.section == 4) {
        static NSString *cellId = @"goldRechargeThird";
        UCFColdChargeThirdCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldRecharge) {
            goldRecharge = (UCFColdChargeThirdCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFColdChargeThirdCell" owner:self options:nil] lastObject];
            goldRecharge.delegate = self;
        }
        return goldRecharge;
    }
    else {
        static NSString *cellId = @"goldRecharge";
        UCFGoldRechargeCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldRecharge) {
            goldRecharge = (UCFGoldRechargeCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeCell" owner:self options:nil] lastObject];
        }
        goldRecharge.indexPath = indexPath;
        goldRecharge.model = [self.dataArray objectAtIndex:indexPath.row];
        goldRecharge.delegate = self;
        return goldRecharge;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    else if (indexPath.section == 1) {
        return 30;
    }
    else if (indexPath.section == 2) {
        return 37;
    }
    else if (indexPath.section == 3) {
        return 22;
    }
    else if (indexPath.section == 4) {
        return 37;
    }
    UCFGoldRechargeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (void)goldRechargeCell:(UCFColdChargeThirdCell *)rechargeCell didClickRechargeButton:(UIButton *)rechargeButton
{
    [self.tableview endEditing:YES];
    NSString *inputMoney = [Common deleteStrHeadAndTailSpace:self.chargeOneCell.textField.text];
    if ([Common isPureNumandCharacters:inputMoney]) {
        [MBProgressHUD displayHudError:@"请输入正确金额"];
        return;
    }
    inputMoney = [NSString stringWithFormat:@"%.2f",[inputMoney doubleValue]];
    NSComparisonResult comparResult = [@"0.01" compare:[Common deleteStrHeadAndTailSpace:inputMoney] options:NSNumericSearch];
    //ipa 版本号 大于 或者等于 Apple 的版本，返回，不做自己服务器检测
    if (comparResult == NSOrderedDescending) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入充值金额" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        //        [alert show];
        [MBProgressHUD displayHudError:@"请输入充值金额"];
        return;
    }
    comparResult = [inputMoney compare:@"10000000.00" options:NSNumericSearch];
    if (comparResult == NSOrderedDescending || comparResult == NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值金额不可大于1000万" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    if (!userId) {
        return;
    }
    if ([inputMoney doubleValue] < 10.00f) {
        [MBProgressHUD displayHudError:@"充值金额大于10元"];
        return;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.bankUrl, @"backUrl", inputMoney, @"rechargeAmt", userId, @"userId",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldRecharge owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)goldRechargeSecCell:(UCFGoldChargeSecCell *)goldRechargeSecCell didClickedConstractWithId:(NSString *)constractId
{
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId", [NSString stringWithFormat:@"%@", constractId], @"contractTemplateId", nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldContractInfo owner:self signature:YES Type:SelectAccoutTypeGold];
}

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSMutableDictionary *dic = [(NSString *)result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagGoldRecharge) {
        if ([rstcode intValue] == 1) {
            UCFGoldRechargeWebController *webRecharge = [[UCFGoldRechargeWebController alloc] initWithNibName:@"UCFGoldRechargeWebController" bundle:nil];
            webRecharge.rootVc = self.rootVc;
            webRecharge.baseTitleText = @"充值";
            NSDictionary *data = [dic objectSafeDictionaryForKey:@"data"];
            webRecharge.backUrl = self.bankUrl;
            webRecharge.paramDictory = [data objectSafeDictionaryForKey:@"params"];
            webRecharge.url = [data objectSafeForKey:@"url"];
            [self.navigationController pushViewController:webRecharge animated:YES];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    else if (tag.intValue == kSXTagGoldRechargeInfo) {
        if ([rstcode intValue] == 1) {
            NSDictionary *data = [dic objectSafeDictionaryForKey:@"data"];
            NSArray *contractInfo = [data objectSafeDictionaryForKey:@"contractList"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *contractDict in contractInfo) {
                UCFContractModel *contract = [[UCFContractModel alloc] init];
                contract.Id = [contractDict objectSafeForKey:@"id"];
                contract.contractName = [contractDict objectSafeForKey:@"contractName"];
                [temp addObject:contract];
            }
            self.constracts = temp;
            NSString *tipContent = [data objectSafeForKey:@"pageContent"];
            NSString *tipStr = [tipContent stringByReplacingOccurrencesOfString:@"• " withString:@""];
            NSArray *array = [tipStr componentsSeparatedByString:@"\n"];
            [self.dataArray removeAllObjects];
            for (NSString *str in array) {
                UCFGoldRechargeModel *model = [[UCFGoldRechargeModel alloc] init];
                model.tipString = str;
                CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
                model.isShowBlackDot = YES;
                model.cellHeight = size.height + 5;
                [self.dataArray addObject:model];
            }
            UCFGoldRechargeModel *firstModel = [[UCFGoldRechargeModel alloc] init];
            firstModel.tipString = @"温馨提示";
            CGSize size = [self sizeWithString:@"温馨提示" font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
            firstModel.isShowBlackDot = NO;
            firstModel.cellHeight = size.height + 16;
            [self.dataArray insertObject:firstModel atIndex:0];
            [self.tableview reloadData];
        }
    }
    else if (tag.intValue == kSXTagGetGoldContractInfo) {
        if ([rstcode intValue] == 1)
        {
            NSDictionary *constractResult = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
            
            NSString *contractContentStr = [constractResult objectSafeForKey:@"contractContent"];
            NSString *contractTitle = [constractResult objectSafeForKey:@"contractName"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:contractContentStr title:contractTitle];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}

- (void)goldCell:(UCFGoldRechargeCell *)goldCell didDialedWithNO:(NSString *)No
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
}

@end
