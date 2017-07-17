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
#import "UCFGoldCashCell.h"
#import "UCFGoldCashHistoryController.h"

@interface UCFGoldCashMoneyViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
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
    if (indexPath.section < 3) {
        static NSString *cellId = @"goldcash";
        UCFGoldCashCell *goldCash = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == goldCash) {
            goldCash = (UCFGoldCashCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashCell" owner:self options:nil] lastObject];
        }
        goldCash.indexPath = indexPath;
        return goldCash;
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
@end
