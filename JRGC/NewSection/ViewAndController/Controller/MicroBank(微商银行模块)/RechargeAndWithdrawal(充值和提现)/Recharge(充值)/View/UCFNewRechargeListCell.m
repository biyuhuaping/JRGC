//
//  UCFNewRechargeListCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewRechargeListCell.h"
#import "NZLabel.h"
#import "UCFAccountCenterAssetsOverViewModel.h"
#define LabelLeft 25
#define LayoutHeight 40
#import "FundsDetailFrame.h"
#import "FundsDetailModel.h"
#import "UCFToolsMehod.h"
@interface UCFNewRechargeListCell()
@property (nonatomic, strong) MyRelativeLayout *bkLayout;// v背景

@property (nonatomic, strong) UIView      *titleVerticalView;

@property (nonatomic, strong) NZLabel     *orderTipLabel;

@property (nonatomic, strong) NZLabel     *statueLabel;

@property (nonatomic, strong) NZLabel     *orderNumLabel;

@property (nonatomic, strong) UIView      *titleLineView;

@property (nonatomic, strong) MyRelativeLayout *availBalanceLayout;// 金额

@property (nonatomic, strong) NZLabel     *availBalanceLabel;

@property (nonatomic, strong) NZLabel     *moneyLabel;


@property (nonatomic, strong) MyRelativeLayout *waitInterestLayout;// 发生时间

@property (nonatomic, strong) NZLabel     *waitInterestLabel;

@property (nonatomic, strong) NZLabel     *timeValueLabel;

@property(nonatomic, strong)NSDictionary    *dataDict;
@end
@implementation UCFNewRechargeListCell

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
        _titleVerticalView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 2;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
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
        _availBalanceLabel.myCenterY = 4;
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
        _moneyLabel.centerYPos.equalTo(self.availBalanceLabel.centerYPos);
        _moneyLabel.myRight = 25;
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.font = [Color gc_Font:14.0];
        _moneyLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _moneyLabel.text = @"  ";
        [_moneyLabel sizeToFit];
    }
    return _moneyLabel;
}

- (MyRelativeLayout *)waitInterestLayout
{
    if (nil == _waitInterestLayout){
        _waitInterestLayout = [MyRelativeLayout new];
        _waitInterestLayout.backgroundColor = [UIColor whiteColor];
        _waitInterestLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _waitInterestLayout.myWidth = PGScreenWidth;
        _waitInterestLayout.myHeight = LayoutHeight;
        _waitInterestLayout.topPos.equalTo(self.availBalanceLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _waitInterestLayout;
}

- (NZLabel *)waitInterestLabel
{
    if (nil == _waitInterestLabel) {
        _waitInterestLabel = [NZLabel new];
        _waitInterestLabel.myCenterY = -6;
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
        _timeValueLabel.centerYPos.equalTo(self.waitInterestLabel.centerYPos);
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
    _orderNumLabel.text = [_dataDict objectForKey:@"payNum"];
    NSString *payAmt = [_dataDict objectForKey:@"payAmt"];
    NSString *payAmtStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",[payAmt doubleValue]]];
    _moneyLabel.text = [NSString stringWithFormat:@"¥%@",payAmtStr];
    _timeValueLabel.text = [_dataDict objectForKey:@"createTime"];
    NSInteger statue = [[_dataDict objectForKey:@"status"] integerValue];
    if (statue == 1) {
        _statueLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _statueLabel.text = @"未支付";
        
    } else if (statue == 2) {
        _statueLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _statueLabel.text = @"支付中";
    } else if (statue == 3) {
        _statueLabel.text = @"充值成功";
        _statueLabel.textColor = [Color color:PGColorOptionCellContentBlue];
        
    } else {
        _statueLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _statueLabel.text = @"充值失败";
        
    }
    
    [self.orderTipLabel sizeToFit];
    [self.statueLabel sizeToFit];
    [self.orderNumLabel sizeToFit];
    [self.moneyLabel sizeToFit];
    [self.timeValueLabel sizeToFit];
    
}
@end
