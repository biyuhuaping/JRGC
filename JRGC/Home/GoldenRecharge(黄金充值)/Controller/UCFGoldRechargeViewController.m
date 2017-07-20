//
//  UCFGoldRechargeViewController.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeViewController.h"
#import "UCFGoldRechargeHeaderView.h"
#import "UCFGoldRechargeCell.h"
#import "UCFGoldRechargeModel.h"
#import "UCFGoldRechargeHistoryController.h"
#import "UCFGoldRechargeWebController.h"

@interface UCFGoldRechargeViewController () <UITableViewDelegate, UITableViewDataSource, UCFGoldRechargeHeaderViewDelegate, UCFGoldRechargeCellDelegate>
@property (weak, nonatomic) UCFGoldRechargeHeaderView *goldRechargeHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSString *backUrl;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    [self addRightBtn];
    [self createUI];
    [self initData];
}

- (void)createUI {
    UCFGoldRechargeHeaderView *goldChargeHeader = (UCFGoldRechargeHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeHeaderView" owner:self options:nil] lastObject];
    goldChargeHeader.delegate = self;
    self.tableview.tableHeaderView = goldChargeHeader;
    self.goldRechargeHeader = goldChargeHeader;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.tableview addGestureRecognizer:tap];
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    [self.goldRechargeHeader endEditing:YES];
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

- (void)initData {
    NSArray *array = @[@"温馨提示", @"充值金额仅限在黄金账户使用;", @"使用快捷支付充值最低金额应大于等于10元;", @"对首次充值后未交易的提现，平台收取0.4%的手续费;", @"充值/提现必须为银行借记卡,不支持存折、信用卡充值;", @"充值需要开通银行卡网上支付功能, 如有疑问请咨询开户行客服;", @"单笔充值不可超过银行充值限额;", @"如果充值金额没有及时到账,请拨打客服400-0322-988咨询。"];
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

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.goldRechargeHeader.frame = CGRectMake(0, 0, ScreenWidth, 168);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldRecharge";
    UCFGoldRechargeCell *goldRecharge = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == goldRecharge) {
        goldRecharge = (UCFGoldRechargeCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeCell" owner:self options:nil] lastObject];
    }
    goldRecharge.model = [self.dataArray objectAtIndex:indexPath.row];
    goldRecharge.delegate = self;
    return goldRecharge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFGoldRechargeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return model.cellHeight;
}

- (void)goldRechargeHeader:(UCFGoldRechargeHeaderView *)goldHeader didClickedHandInButton:(UIButton *)handInButton withMoney:(NSString *)money
{
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    if (!userId) {
        return;
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.bankUrl, @"backUrl", money, @"rechargeAmt", userId, @"userId",  nil];
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGoldRecharge owner:self signature:YES Type:SelectAccoutDefault];
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
