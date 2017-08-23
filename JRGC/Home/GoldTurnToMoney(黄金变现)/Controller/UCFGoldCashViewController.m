//
//  UCFGoldCashViewController.m
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashViewController.h"
#import "UCFCashGoldHeader.h"
#import "UCFGoldCashSecondCell.h"
#import "UCFGoldCashThirdCell.h"
#import "UCFGoldCashFourthCell.h"
#import "UCFGoldCashButtonCell.h"
#import "UCFGoldCashTipCell.h"
#import "UCFGoldCashModel.h"
#import "ToolSingleTon.h"
#import "UCFCashGoldResultModel.h"
#import "UCFGoldCashSucessController.h"
#import "MjAlertView.h"
#import "UCFCashGoldTipview.h"

@interface UCFGoldCashViewController () <UITableViewDataSource, UITableViewDelegate, UCFGoldCashButtonCellDelegate, UIAlertViewDelegate, UCFGoldCashFourthCellDelegate, UCFCashGoldTipviewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *availableGoldAmount;
@property (copy, nonatomic) NSString *cashServiceRate;
@property (copy, nonatomic) NSString *liquidateToken;
@property (weak, nonatomic) UCFCashGoldHeader *cashGoldHeader;
@property (weak, nonatomic) UCFGoldCashThirdCell *amoutCell;
@property (strong, nonatomic) UCFCashGoldResultModel *cashGoldResult;
@property (copy, nonatomic) NSString *goldAveragePrice;
@property (assign, nonatomic) BOOL isGoOn;
@property (weak, nonatomic) MjAlertView *tipView;
@end

@implementation UCFGoldCashViewController

- (NSString *)goldAveragePrice
{
    if (!_goldAveragePrice) {
        _goldAveragePrice = [NSString stringWithFormat:@"%.2lf", [ToolSingleTon sharedManager].readTimePrice * [self.amoutCell.textField.text doubleValue]];
    }
    return _goldAveragePrice;
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.cashGoldHeader.frame = CGRectMake(0, 0, ScreenWidth, 130);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTipMessage) name:CURRENT_GOLD_PRICE object:nil];
    
    UCFCashGoldHeader *cashGoldHeader = (UCFCashGoldHeader *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCashGoldHeader" owner:self options:nil] lastObject];
    
    self.tableview.tableHeaderView = cashGoldHeader;
    self.cashGoldHeader = cashGoldHeader;
    
    [self.tableview setContentInset:UIEdgeInsetsMake(10, 0, 100, 0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.tableview addGestureRecognizer:tap];
    self.isGoOn = NO;
    
    [self initData];
    [self getViewDataFromNet];
}

- (void)tapped:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

- (void)getViewDataFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!userId) {
        return;
    }
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId" : userId} tag:kSXTagGoldChangeCashInfo owner:self signature:YES Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.integerValue == kSXTagGoldChangeCashInfo) {
        if ([rstcode intValue] == 1) {
            NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
            self.availableGoldAmount = [dict objectSafeForKey:@"availableGoldAmount"];
            self.cashServiceRate = [dict objectSafeForKey:@"cashServiceRate"];
            self.liquidateToken = [dict objectSafeForKey:@"liquidateToken"];
            NSString *tipStr = [[dict objectSafeForKey:@"pageContent"] stringByReplacingOccurrencesOfString:@"•" withString:@""];
            NSArray *tipArray = [tipStr componentsSeparatedByString:@"\n"];
            [self.dataArray removeAllObjects];
            [self initData];
            for (NSString *str in tipArray) {
                UCFGoldCashModel *model = [[UCFGoldCashModel alloc] init];
                model.tipString = str;
            model.isShowBlackDot = YES;
            CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
            model.cellHeight = size.height+5;
            [self.dataArray addObject:model];
            }
            
            [self.tableview reloadData];
        }else {
            if (![rsttext isEqualToString:@""] && rsttext) {
                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            }
        }
    }
    else if (tag.integerValue == kSXTagGoldChangeCash) {
        NSDictionary *dict = [dic objectSafeDictionaryForKey:@"data"];
        UCFCashGoldResultModel *cashGoldResu = [[UCFCashGoldResultModel alloc] init];
        cashGoldResu.dealGoldPrice = [NSString stringWithFormat:@"%@",[dict objectSafeForKey:@"dealGoldPrice"]];
        cashGoldResu.liquidateGoldAmount = [dict objectSafeForKey:@"liquidateGoldAmount"];
        cashGoldResu.liquidateMoney = [dict objectSafeForKey:@"liquidateMoney"];
        cashGoldResu.liquidateToken = [dict objectSafeForKey:@"liquidateToken"];
        cashGoldResu.orderId = [dict objectSafeForKey:@"orderId"];
        cashGoldResu.poundage = [dict objectSafeForKey:@"poundage"];
        cashGoldResu.realTimeliquidateAmt = [dict objectSafeForKey:@"realTimeliquidateAmt"];
        self.cashGoldResult = cashGoldResu;
        self.liquidateToken = cashGoldResu.liquidateToken;
        self.goldAveragePrice = cashGoldResu.liquidateGoldAmount;
        if ([[dic objectForKey:@"code"] integerValue] == 43068) {
            NSString *meg = [NSString stringWithFormat:@"由于金价实时波动，变现是金价增长至%@元/克", self.cashGoldResult.realTimeliquidateAmt];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:meg delegate:self cancelButtonTitle:@"放弃变现" otherButtonTitles:@"继续变现", nil];
            [alertView show];
            return;
        }
        UCFGoldCashSucessController *cashSuc = [[UCFGoldCashSucessController alloc] initWithNibName:@"UCFGoldCashSucessController" bundle:nil];
        cashSuc.baseTitleText = @"确认成功";
        cashSuc.cashResuModel = self.cashGoldResult;
        cashSuc.isPurchaseSuccess = [[dic objectSafeForKey:@"ret"] boolValue];
        [self.navigationController pushViewController:cashSuc animated:YES];
//        else {
//            if (![rsttext isEqualToString:@""] && rsttext) {
//                [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
//            }
//        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)initData {
    NSString *tipOneStr = [NSString stringWithFormat:@"黄金价格实时波动，在0.50元的波动范围内成交，成交瞬间系统价格不低于%.2f/克则立即为你变现", ([ToolSingleTon sharedManager].readTimePrice - 0.5)];
    NSArray *tipsArray = [[NSArray alloc] initWithObjects:tipOneStr, @"温馨提示:", nil];
    [self.dataArray removeAllObjects];
    for (NSString *str in tipsArray) {
        UCFGoldCashModel *model = [[UCFGoldCashModel alloc] init];
        if (str == [tipsArray firstObject]) {
            model.tipString = str;
            model.isShowBlackDot = NO;
            CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
            model.cellHeight = size.height;
        }
        else if ([str isEqualToString:@"温馨提示:"]) {
            model.tipString = str;
            model.isShowBlackDot = NO;
            CGSize size = [self sizeWithString:str font:[UIFont systemFontOfSize:13] constraintSize:CGSizeMake(ScreenWidth - 40, MAXFLOAT)];
            model.cellHeight = size.height+5;
        }
        [self.dataArray addObject:model];
    }
}

- (void)refreshTipMessage
{
    [self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if (section == 3) {
        return self.dataArray.count -1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else if (section == 1) {
        return 15;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    else if (section == 2) {
        return 28;
    }
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cellId = @"goldcashsecond";
                UCFGoldCashSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = (UCFGoldCashSecondCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashSecondCell" owner:self options:nil] lastObject];
                }
                if (self.availableGoldAmount) {
                    cell.availableCashGoldAmount.text = self.availableGoldAmount;
                }
                return cell;
            }
                break;
                
            case 1: {
                cellId = @"goldcashthird";
                UCFGoldCashThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = (UCFGoldCashThirdCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashThirdCell" owner:self options:nil] lastObject];
                }
                cell.avavilableGoldAmount = self.availableGoldAmount;
                self.amoutCell = cell;
                return cell;
            }
                break;
                
            case 2: {
                cellId = @"goldcashforth";
                UCFGoldCashFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = (UCFGoldCashFourthCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashFourthCell" owner:self options:nil] lastObject];
                }
                cell.delegate = self;
                if (self.cashServiceRate) {
                    cell.cashServiceFee.text = [NSString stringWithFormat:@"%@元", self.cashServiceRate];
                }
                return cell;
            }
                break;
        }
        
    }
    else if (indexPath.section == 1) {
        cellId = @"goldcashbutton";
        UCFGoldCashButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashButtonCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashButtonCell" owner:self options:nil] lastObject];
        }
        if (self.availableGoldAmount.doubleValue > 0.0) {
            cell.canCash = YES;
        }
        else {
            cell.canCash = NO;
        }
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.section == 2) {
        cellId = @"goldcashtip";
        UCFGoldCashTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashTipCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashTipCell" owner:self options:nil] lastObject];
        }
        cell.goldCashModel = [self.dataArray firstObject];
        return cell;
    }
    else if (indexPath.section == 3) {
        cellId = @"goldcashtip";
        UCFGoldCashTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashTipCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashTipCell" owner:self options:nil] lastObject];
        }
        cell.goldCashModel = [self.dataArray objectAtIndex:(indexPath.row + 1)];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 37;
    }
    else if (indexPath.section == 2)  {
        UCFGoldCashModel *model = [self.dataArray firstObject];
        return model.cellHeight;
    }
    else if (indexPath.section == 3) {
        UCFGoldCashModel *model = [self.dataArray objectAtIndex:(indexPath.row + 1)];
        return model.cellHeight;
    }
    return 44;
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

- (void)goldCashcell:(UCFGoldCashButtonCell *)cashCell didClickCashGoldButton:(UIButton *)cashButton
{
    [self.tableview endEditing:YES];
    NSString *inputAmout = [Common deleteStrHeadAndTailSpace:self.amoutCell.textField.text];
    if ([Common isPureNumandCharacters:inputAmout]) {
        [MBProgressHUD displayHudError:@"请输入正确的黄金克重"];
        return;
    }
    inputAmout = [NSString stringWithFormat:@"%.3f",[inputAmout doubleValue]];
    NSComparisonResult comparResult = [@"0.001" compare:[Common deleteStrHeadAndTailSpace:inputAmout] options:NSNumericSearch];
    //ipa 版本号 大于 或者等于 Apple 的版本，返回，不做自己服务器检测
    if (comparResult == NSOrderedDescending) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入充值金额" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        //        [alert show];
        [MBProgressHUD displayHudError:@"请输入变现的黄金克重"];
        return;
    }
    
//    if ([Common stringA:inputMoney ComparedStringB:@"10"] == -1) {
//        [MBProgressHUD displayHudError:[NSString stringWithFormat:@"单笔提现金额不低于10元"]];
//        return;
//    }
    NSString *maxAmountStr = self.availableGoldAmount;
    
    if ([Common stringA:inputAmout ComparedStringB:maxAmountStr] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"可变现黄金不足，多多投资吧" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self cashGold];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.isGoOn = YES;
        [self cashGold];
    }
}

- (void)goldCashFourthDidClickedTipButton:(UIButton *)button
{
    __weak typeof(self) weakSelf = self;
    MjAlertView *alertView = [[MjAlertView alloc] initCustomAlertViewWithBlock:^(id blockContent) {
        UIView *view = (UIView *)blockContent;
        view.frame = CGRectMake(0, 0, 265, 245);
        
        UCFCashGoldTipview *tipview = (UCFCashGoldTipview *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCashGoldTipview" owner:self options:nil] lastObject];
        tipview.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f元", [ToolSingleTon sharedManager].readTimePrice];
        tipview.serviceFeeLabel.text = [NSString stringWithFormat:@"%@元/克", weakSelf.cashServiceRate];
        tipview.actualGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f元", [ToolSingleTon sharedManager].readTimePrice-[weakSelf.cashServiceRate floatValue]];
        tipview.frame = view.bounds;
        view.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
        tipview.delegate = weakSelf;
        [view addSubview:tipview];
    }];
    weakSelf.tipView = alertView;
    [alertView show];
}

- (void)cashGoldTipViewDidClickedCloseButton:(UIButton *)button
{
    [self.tipView hide];
}

- (void)cashGold {
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (!self.isGoOn && self.goldAveragePrice != nil) {
        self.goldAveragePrice = nil;
    }
    else{
        self.isGoOn = NO;
    }

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", self.liquidateToken, @"liquidateToken", self.amoutCell.textField.text, @"goldAmount", self.goldAveragePrice, @"money",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldChangeCash owner:self signature:YES Type:SelectAccoutDefault];
}

@end
