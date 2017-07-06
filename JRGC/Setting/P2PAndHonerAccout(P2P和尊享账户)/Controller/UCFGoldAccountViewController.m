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

@interface UCFGoldAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *baseTableView;
@property (weak, nonatomic) IBOutlet UIButton *buyGoldBtn;
@property (weak, nonatomic) IBOutlet UIButton *withdrawalsBtn;
@property (weak, nonatomic) IBOutlet UIButton *goldCashBtn;
@property (strong, nonatomic) UCFGoldAccountHeadView *headerView;
@property (strong, nonatomic) NSMutableArray    *dataArray;
@end

@implementation UCFGoldAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];

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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"GoldAccountFirstCell" owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = UIColorWithRGB(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
            UIView *lineView = [Common addSepateViewWithRect:CGRectMake(0, model.cellHeight - 0.5, ScreenWidth, 0.5) WithColor:UIColorWithRGB(0xe3e5ea)];
            lineView.tag = 1000;
            [cell.contentView addSubview:lineView];
        }
        cell.textLabel.text = @"可用余额";
        return cell;
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldAccountHeadView" owner:nil options:nil] firstObject];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 210);
        self.baseTableView.tableHeaderView = _headerView;
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


}
- (void)initUI
{
    [self addLeftButton];
    baseTitleLabel.text = @"黄金账户";
    self.baseTableView.delegate = self;
    self.baseTableView.dataSource = self;
    [_buyGoldBtn setBackgroundColor:UIColorWithRGB(0xffc027)];
    [_withdrawalsBtn setBackgroundColor:UIColorWithRGB(0x7C9DC7)];
    [_goldCashBtn setBackgroundColor:UIColorWithRGB(0x7C9DC7)];

    self.baseTableView.backgroundColor = UIColorWithRGB(0xe3e5eb);
    [self addRightBtn];

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
    
}
- (IBAction)bottomButtomClicked:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqualToString:@"买金"]) {
        
    } else if ([title isEqualToString:@"变现"]) {
        UCFGoldCashViewController *vc1 = [[UCFGoldCashViewController alloc] initWithNibName:@"UCFGoldCashViewController" bundle:nil];
        [self.navigationController pushViewController:vc1 animated:YES];
    } else if ([title isEqualToString:@"提金"]) {
        
    }
}
@end
