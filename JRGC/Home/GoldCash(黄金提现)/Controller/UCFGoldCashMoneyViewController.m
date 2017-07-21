//
//  UCFGoldCashMoneyViewController.m
//  JRGC
//
//  Created by njw on 2017/7/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashMoneyViewController.h"
#import "UCFGoldRechargeModel.h"
#import "UCFGoldRechargeCell.h"
#import "UCFGoldCashOneCell.h"
#import "UCFGoldCashTwoCell.h"
#import "UCFGoldCashThreeCell.h"
#import "UCFGoldCashHistoryController.h"

@interface UCFGoldCashMoneyViewController () <UITableViewDataSource, UITableViewDelegate, UCFGoldCashThreeCellDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) UCFGoldCashTwoCell *amoutCell;
@end

@implementation UCFGoldCashMoneyViewController

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    [self createUI];
    [self addRightBtn];
    [self initData];
    
    
}

- (void)createUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:tap];
    
    [self.tableview setContentInset:UIEdgeInsetsMake(23, 0, 0, 0)];
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)clickRightBtn {
    UCFGoldCashHistoryController *goldCashHistory = [[UCFGoldCashHistoryController alloc] initWithNibName:@"UCFGoldCashHistoryController" bundle:nil];
    goldCashHistory.baseTitleText = @"提现记录";
    [self.navigationController pushViewController:goldCashHistory animated:YES];
}

- (void)addRightBtn {
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 88, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:@"提现记录" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initData {
    NSArray *array = @[@"温馨提示", @"单笔提现金额不能低于10元，提现申请成功后不可撤回;", @"对首次充值后无投资的提现，平台收取0.4%的手续费;", @"金额大于50W在工作日8:30-16:30内发起当日到账，当日此时段申请次日到账;", @"如遇问题,请拨打客服400-0322-988咨询。"];
    [self.dataArray removeAllObjects];
    for (NSString *str in array) {
        UCFGoldRechargeModel *model = [[UCFGoldRechargeModel alloc] init];
        model.tipString = str;
        CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
        if ([str isEqualToString:[array firstObject]]) {
            model.isShowBlackDot = NO;
            model.cellHeight = size.height + 16;
        }
        else {
            model.isShowBlackDot = YES;
            model.cellHeight = size.height + 5;
        }
        [self.dataArray addObject:model];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return self.dataArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"goldcash1";
        UCFGoldCashOneCell *goldCash1 = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldCash1) {
            goldCash1 = (UCFGoldCashOneCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashOneCell" owner:self options:nil] lastObject];
        }
        goldCash1.amountLabel.text = self.balanceMoney == nil ? @"¥0.00" : [NSString stringWithFormat:@"¥%@", self.balanceMoney];
        return goldCash1;
    }
    else if (indexPath.section == 1) {
        static NSString *cellId = @"goldcash2";
        UCFGoldCashTwoCell *goldCash2 = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldCash2) {
            goldCash2 = (UCFGoldCashTwoCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashTwoCell" owner:self options:nil] lastObject];
        }
        goldCash2.avavilableMoney = self.balanceMoney;
//        if (self.cashAll) {
//            goldCash2.textField.text = self.balanceMoney;
//            self.cashAll = NO;
//        }
        self.amoutCell = goldCash2;
        return goldCash2;
    }
    else if (indexPath.section == 2) {
        static NSString *cellId = @"goldcash3";
        UCFGoldCashThreeCell *goldCash3 = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldCash3) {
            goldCash3 = (UCFGoldCashThreeCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashThreeCell" owner:self options:nil] lastObject];
        }
        goldCash3.delegate = self;
        return goldCash3;
    }
    else {
        static NSString *cellId = @"goldRecharge";
        UCFGoldRechargeCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldRecharge) {
            goldRecharge = (UCFGoldRechargeCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeCell" owner:self options:nil] lastObject];
        }
        goldRecharge.model = [self.dataArray objectAtIndex:indexPath.row];
        return goldRecharge;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 21;
    }
    else if (indexPath.section == 1) {
        return 44;
    }
    else if (indexPath.section == 2) {
        return 69;
    }
    UCFGoldRechargeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (void)goldCashcell:(UCFGoldCashThreeCell *)cashCell didClickCashButton:(UIButton *)cashButton
{
    [self.tableview endEditing:YES];
    NSString *inputMoney = [Common deleteStrHeadAndTailSpace:self.amoutCell.textField.text];
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
        [MBProgressHUD displayHudError:@"请输入提现金额"];
        return;
    }
//    comparResult = [inputMoney compare:self.balanceMoney options:NSNumericSearch];
//    if (comparResult == NSOrderedDescending || comparResult == NSOrderedSame) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值金额不可大于最大可提现金额" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    comparResult = [inputMoney compare:self.balanceMoney options:NSNumericSearch];
    if (comparResult == NSOrderedDescending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"充值金额不可大于最大可提现金额" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    if (!userId) {
        return;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:inputMoney, @"amount", userId, @"userId",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldCash owner:self signature:YES Type:SelectAccoutDefault];
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
    if (tag.intValue == kSXTagGoldCash) {
        if ([rstcode intValue] == 1) {
            [AuxiliaryFunc showToastMessage:@"提现成功" withView:self.view];
            [self performSelector:@selector(backGoldAccount) withObject:nil afterDelay:0.5];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
}

- (void)backGoldAccount
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_GOLD_ACCOUNT object:nil];
}

@end
