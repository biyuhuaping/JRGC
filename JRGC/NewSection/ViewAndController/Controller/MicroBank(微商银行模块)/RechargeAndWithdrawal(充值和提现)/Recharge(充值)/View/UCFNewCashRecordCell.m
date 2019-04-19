//
//  UCFNewCashRecordCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewCashRecordCell.h"
#import "NZLabel.h"
#import "UCFAccountCenterAssetsOverViewModel.h"
#define LabelLeft 25
#define LayoutHeight 37
#import "FundsDetailFrame.h"
#import "FundsDetailModel.h"
#import "UCFToolsMehod.h"
@interface UCFNewCashRecordCell()
@property (nonatomic, strong) MyRelativeLayout *bkLayout;// v背景

@property (nonatomic, strong) UIView      *titleVerticalView;

@property (nonatomic, strong) NZLabel     *orderTipLabel;

@property (nonatomic, strong) NZLabel     *statueLabel;

@property (nonatomic, strong) NZLabel     *orderNumLabel;

@property (nonatomic, strong) UIView      *titleLineView;

@property (nonatomic, strong) MyRelativeLayout *availBalanceLayout;// 金额

@property (nonatomic, strong) NZLabel     *availBalanceLabel;

@property (nonatomic, strong) NZLabel     *moneyLabel;

@property (nonatomic, strong) MyRelativeLayout *waitPrincipalLayout;// 提现方式

@property (nonatomic, strong) NZLabel     *waitPrincipalLabel;

@property (nonatomic, strong) NZLabel     *cashWayLabel;

@property (nonatomic, strong) MyRelativeLayout *waitInterestLayout;// 发生时间

@property (nonatomic, strong) NZLabel     *waitInterestLabel;

@property (nonatomic, strong) NZLabel     *timeValueLabel;

@property(nonatomic, strong)NSDictionary    *dataDict;
@end
@implementation UCFNewCashRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化视图对象
        
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        
        [self.rootLayout addSubview:self.bkLayout];
        
        [self.bkLayout addSubview:self.titleVerticalView];
        [self.bkLayout addSubview:self.orderTipLabel];
        [self.bkLayout addSubview:self.statueLabel];
        [self.bkLayout addSubview:self.orderNumLabel];
        [self.bkLayout addSubview:self.titleLineView];
        
        [self.bkLayout addSubview:self.availBalanceLayout];
        [self.availBalanceLayout addSubview:self.availBalanceLabel];
        [self.availBalanceLayout addSubview:self.moneyLabel];
        
        [self.bkLayout addSubview:self.waitPrincipalLayout];
        [self.waitPrincipalLayout addSubview:self.waitPrincipalLabel];
        [self.waitPrincipalLayout addSubview:self.cashWayLabel];
        
        [self.bkLayout addSubview:self.waitInterestLayout];
        [self.waitInterestLayout addSubview:self.waitInterestLabel];
        [self.waitInterestLayout addSubview:self.timeValueLabel];
        
    }
    return self;
}

- (MyRelativeLayout *)bkLayout
{
    if (nil == _bkLayout){
        _bkLayout = [MyRelativeLayout new];
        _bkLayout.backgroundColor = [UIColor whiteColor];
        _bkLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _bkLayout.myLeft = 0;
        _bkLayout.myRight = 0;
        _bkLayout.myBottom = 0;
        _bkLayout.myTop = 10;
        //        _wjLayout.myCenterX = - 70;
    }
    return _bkLayout;
}
-(UIView *)titleVerticalView
{
    if (nil == _titleVerticalView) {
        _titleVerticalView = [UIView new];
        _titleVerticalView.myTop = 18;
        _titleVerticalView.myHeight = 16;
        _titleVerticalView.myWidth = 4;
        _titleVerticalView.myLeft = 15;
        _titleVerticalView.backgroundColor = [Color color:PGColorOpttonRateNoramlTextColor];
    }
    return _titleVerticalView;
}
-(UIView *)titleLineView
{
    if (nil == _titleLineView) {
        _titleLineView = [UIView new];
        _titleLineView.myTop = 51;
        _titleLineView.myHeight = 0.5;
        _titleLineView.myRight = 15;
        _titleLineView.myLeft = 15;
        _titleLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    }
    return _titleLineView;
}

- (NZLabel *)orderNumLabel
{
    if (nil == _orderNumLabel) {
        _orderNumLabel = [NZLabel new];
        _orderNumLabel.centerYPos.equalTo(self.titleVerticalView.centerYPos);
        _orderNumLabel.rightPos.equalTo(self.statueLabel.leftPos).offset(10);
         _orderNumLabel.leftPos.equalTo(self.orderTipLabel.rightPos).offset(4);
        _orderNumLabel.textAlignment = NSTextAlignmentLeft;
        _orderNumLabel.font = [Color gc_Font:14.0];
        _orderNumLabel.adjustsFontSizeToFitWidth = YES;
        _orderNumLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        //        _titleLabel.text = @"可用余额";
        //        [_titleLabel sizeToFit];
    }
    return _orderNumLabel;
}
- (NZLabel *)statueLabel
{
    if (nil == _statueLabel) {
        _statueLabel = [NZLabel new];
        _statueLabel.centerYPos.equalTo(self.titleVerticalView.centerYPos);
        _statueLabel.myRight = 15;
        _statueLabel.myWidth = 70;
        _statueLabel.textAlignment = NSTextAlignmentRight;
        _statueLabel.font = [Color gc_Font:16.0];
        _statueLabel.textColor = [Color color:PGColorOptionTitleBlack];
        //        _titleLabel.text = @"可用余额";
        //        [_titleLabel sizeToFit];
    }
    return _statueLabel;
}
- (NZLabel *)orderTipLabel
{
    if (nil == _orderTipLabel) {
        _orderTipLabel = [NZLabel new];
        _orderTipLabel.centerYPos.equalTo(self.titleVerticalView.centerYPos);
        _orderTipLabel.leftPos.equalTo(self.titleVerticalView.rightPos).offset(6);
        _orderTipLabel.textAlignment = NSTextAlignmentLeft;
        _orderTipLabel.font = [Color gc_Font:16.0];
        _orderTipLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _orderTipLabel.text = @"订单号";
        _orderTipLabel.myWidth = 50;
        [_orderTipLabel sizeToFit];
    }
    return _orderTipLabel;
}

- (MyRelativeLayout *)availBalanceLayout
{
    if (nil == _availBalanceLayout){
        _availBalanceLayout = [MyRelativeLayout new];
        _availBalanceLayout.backgroundColor = [UIColor whiteColor];
        _availBalanceLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _availBalanceLayout.myWidth = PGScreenWidth;
        _availBalanceLayout.myHeight = LayoutHeight;
        _availBalanceLayout.topPos.equalTo(self.titleLineView.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _availBalanceLayout;
}

- (NZLabel *)availBalanceLabel
{
    if (nil == _availBalanceLabel) {
        _availBalanceLabel = [NZLabel new];
        _availBalanceLabel.myCenterY = 0;
        _availBalanceLabel.myLeft = LabelLeft;
        _availBalanceLabel.textAlignment = NSTextAlignmentLeft;
        _availBalanceLabel.font = [Color gc_Font:15.0];
        _availBalanceLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _availBalanceLabel.text = @"金额";
        [_availBalanceLabel sizeToFit];
    }
    return _availBalanceLabel;
}

- (NZLabel *)moneyLabel
{
    if (nil == _moneyLabel) {
        _moneyLabel = [NZLabel new];
        _moneyLabel.myCenterY = 0;
        _moneyLabel.myRight = 25;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [Color gc_Font:14.0];
        _moneyLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _moneyLabel.text = @"  ";
        [_moneyLabel sizeToFit];
    }
    return _moneyLabel;
}

- (MyRelativeLayout *)waitPrincipalLayout
{
    if (nil == _waitPrincipalLayout){
        _waitPrincipalLayout = [MyRelativeLayout new];
        _waitPrincipalLayout.backgroundColor = [UIColor whiteColor];
        _waitPrincipalLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _waitPrincipalLayout.myWidth = PGScreenWidth;
        _waitPrincipalLayout.myHeight = LayoutHeight;
        _waitPrincipalLayout.topPos.equalTo(self.availBalanceLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _waitPrincipalLayout;
}



- (NZLabel *)waitPrincipalLabel
{
    if (nil == _waitPrincipalLabel) {
        _waitPrincipalLabel = [NZLabel new];
        _waitPrincipalLabel.myCenterY = 0;
        _waitPrincipalLabel.myLeft = LabelLeft;
        _waitPrincipalLabel.textAlignment = NSTextAlignmentLeft;
        _waitPrincipalLabel.font = [Color gc_Font:15.0];
        _waitPrincipalLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitPrincipalLabel.text = @"提现方式";
        [_waitPrincipalLabel sizeToFit];
    }
    return _waitPrincipalLabel;
}

- (NZLabel *)cashWayLabel
{
    if (nil == _cashWayLabel) {
        _cashWayLabel = [NZLabel new];
        _cashWayLabel.myCenterY = 0;
        _cashWayLabel.myRight = 25;
        _cashWayLabel.textAlignment = NSTextAlignmentRight;
        _cashWayLabel.font = [Color gc_Font:14.0];
        _cashWayLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _cashWayLabel.text = @"  ";
        [_cashWayLabel sizeToFit];
    }
    return _cashWayLabel;
}


- (MyRelativeLayout *)waitInterestLayout
{
    if (nil == _waitInterestLayout){
        _waitInterestLayout = [MyRelativeLayout new];
        _waitInterestLayout.backgroundColor = [UIColor whiteColor];
        _waitInterestLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _waitInterestLayout.myWidth = PGScreenWidth;
        _waitInterestLayout.myHeight = LayoutHeight;
        _waitInterestLayout.topPos.equalTo(self.waitPrincipalLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _waitInterestLayout;
}

- (NZLabel *)waitInterestLabel
{
    if (nil == _waitInterestLabel) {
        _waitInterestLabel = [NZLabel new];
        _waitInterestLabel.myCenterY = 0;
        _waitInterestLabel.myLeft = LabelLeft;
        _waitInterestLabel.textAlignment = NSTextAlignmentLeft;
        _waitInterestLabel.font = [Color gc_Font:15.0];
        _waitInterestLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitInterestLabel.text = @"发生时间";
        [_waitInterestLabel sizeToFit];
    }
    return _waitInterestLabel;
}

- (NZLabel *)timeValueLabel
{
    if (nil == _timeValueLabel) {
        _timeValueLabel = [NZLabel new];
        _timeValueLabel.myCenterY = 0;
        _timeValueLabel.myRight = 25;
        _timeValueLabel.textAlignment = NSTextAlignmentRight;
        _timeValueLabel.font = [Color gc_Font:14.0];
        _timeValueLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _timeValueLabel.text = @"  ";
        [_timeValueLabel sizeToFit];
    }
    return _timeValueLabel;
}

//- (void)reloadAccountContent:(UCFAccountCenterAssetsOverViewAssetlist *)model{
//
//    UCFAccountCenterAssetsOverViewAssetlist *ass = model;
//    self.availBalanceContentLabel.text = [NSString stringWithFormat:@"￥%@",ass.availBalance];
//    self.waitPrincipalContentLabel.text = [NSString stringWithFormat:@"￥%@",ass.waitPrincipal];
//    self.waitInterestContentLabel.text = [NSString stringWithFormat:@"￥%@",ass.waitInterest];
//    self.frozenBalanceContentLabel.text = [NSString stringWithFormat:@"￥%@",ass.frozenBalance];
//
//    [self.availBalanceContentLabel sizeToFit] ;
//    [self.waitPrincipalContentLabel sizeToFit];
//    [self.waitInterestContentLabel sizeToFit];
//    [self.frozenBalanceContentLabel sizeToFit];
//
//    //    “P2P” :微金账户 “ZX”：尊享账户 "GOLD":黄金账户
//    if ([ass.type isEqualToString:@"P2P"]) {
//        self.titleVerticalView.backgroundColor = PNBlue;
//        self.titleLabel.text = @"微金资金流水";
//        [self.enterButton setTitle:@"微金资金流水" forState:UIControlStateNormal];
//        self.enterButton.tag = 1000;
//    }
//    else if ([ass.type isEqualToString:@"ZX"]) {
//        self.titleVerticalView.backgroundColor = PNOrange;
//        self.titleLabel.text = @"尊享账户总资产";
//        [self.enterButton setTitle:@"尊享资金流水" forState:UIControlStateNormal];
//        self.enterButton.tag = 1001;
//    }
//    else if ([ass.type isEqualToString:@"GOLD"]) {
//        self.titleVerticalView.backgroundColor = PNYellow;
//        self.titleLabel.text = @"黄金账户总资产";
//        [self.enterButton setTitle:@"黄金交易记录" forState:UIControlStateNormal];
//        self.enterButton.tag = 1002;
//
//        self.waitInterestLayout.myVisibility = MyVisibility_Invisible;// 预期利息
//        self.frozenBalanceLayout.myVisibility = MyVisibility_Invisible;// 冻结金额
//    }
//    [self.titleLabel sizeToFit];
//}


#pragma mark - 数据重新加载
- (void)showInfo:(id)model
{
    if (model == nil || ![model isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.dataDict = [NSDictionary dictionaryWithDictionary:model];
    self.orderNumLabel.text = [self.dataDict objectSafeForKey:@"indentNo"];
    NSString *reflectAmount = [self.dataDict objectSafeForKey:@"reflectAmount"];
    NSString *reflectAmountStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",[reflectAmount doubleValue]]];
//    self.moneyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",reflectAmountStr];
    self.timeValueLabel.text = [self.dataDict objectSafeForKey:@"happenTime"];
    NSInteger statue = [[self.dataDict objectForKey:@"handleState"] integerValue];
    
    NSString *withdrawModeStr = [self.dataDict objectSafeForKey:@"withdrawMode"];
    if ([withdrawModeStr isEqualToString:@""]) {//如果提现方式为空 就隐藏该字段
//        self.cashWayViewHight.constant = 0;
//        self.cashWayLabel.hidden  = YES;
//        self.withdrawalWayLabel.hidden = YES;
        
//        /**视图可见，等价于hidden = false*/
//        MyVisibility_Visible,
//        /**视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域*/
//        MyVisibility_Invisible,
//        /**视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域*/
//        MyVisibility_Gone
        self.waitPrincipalLayout.myVisibility = MyVisibility_Gone;
        
    }else{
//        self.cashWayViewHight.constant = 27;
//        self.cashWayLabel.hidden  = NO;
//        self.withdrawalWayLabel.hidden = NO;
        self.waitPrincipalLayout.myVisibility = MyVisibility_Visible;
        if ([withdrawModeStr intValue] == 1) { // 1:实时到账 2:大额提现
            self.cashWayLabel.text = @"实时到账";
        }else{
            self.cashWayLabel.text = @"大额提现";
        }
    }
    //  0：未处理；7：已退款；9：提现成功；10：提现失败；11：处理中
    if (statue == 9) { // 9:提现成功
        self.statueLabel.textColor = UIColorWithRGB(0x4aa1f9);
    }else if(statue == 11 || statue == 10) // 10：提现失败；11：处理中
    {
        self.statueLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }else{ //0：未处理；7：已退款；
        self.statueLabel.textColor = UIColorWithRGB(0x999999);
    }
    switch (statue) {
        case 0:
        {
            self.statueLabel.text = @"未处理";
        }
            break;
        case 7:
        {
            self.statueLabel.text = @"已退款";
        }
            break;
        case 9:
        {
            self.statueLabel.text = @"提现成功";
        }
            break;
        case 10:
        {
            self.statueLabel.text = @"提现失败";
        }
            break;
        case 11:
        {
            self.statueLabel.text = @"处理中";
        }
        default:
            break;
    }
    
    [self.orderTipLabel sizeToFit];
    [self.statueLabel sizeToFit];
    [self.orderNumLabel sizeToFit];
    [self.moneyLabel sizeToFit];
    [self.cashWayLabel sizeToFit];
    [self.waitPrincipalLabel sizeToFit];
    [self.timeValueLabel sizeToFit];

}
@end
