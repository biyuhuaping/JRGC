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

@interface UCFGoldRechargeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) UCFGoldRechargeHeaderView *goldRechargeHeader;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation UCFGoldRechargeViewController

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
    [self addRightBtn];
    [self createUI];
    [self initData];
}

- (void)createUI {
    UCFGoldRechargeHeaderView *goldChargeHeader = (UCFGoldRechargeHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldRechargeHeaderView" owner:self options:nil] lastObject];
    self.tableview.tableHeaderView = goldChargeHeader;
    self.goldRechargeHeader = goldChargeHeader;
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
    self.goldRechargeHeader.frame = CGRectMake(0, 0, ScreenWidth, 153);
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
    
    return goldRecharge;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFGoldRechargeModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return model.cellHeight;
}

@end
