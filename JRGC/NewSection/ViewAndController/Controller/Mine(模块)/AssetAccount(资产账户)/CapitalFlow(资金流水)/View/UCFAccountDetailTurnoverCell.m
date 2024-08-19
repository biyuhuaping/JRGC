//
//  UCFAccountDetailTurnoverCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/9.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFAccountDetailTurnoverCell.h"
#import "NZLabel.h"
#import "UCFAccountCenterAssetsOverViewModel.h"
#define LabelLeft 15
#define LayoutHeight 37
#import "FundsDetailFrame.h"
#import "FundsDetailModel.h"
@interface UCFAccountDetailTurnoverCell ()

@property (nonatomic, strong) MyRelativeLayout *bkLayout;// v背景

@property (nonatomic, strong) UIView      *titleVerticalView;

@property (nonatomic, strong) NZLabel     *titleLabel;

@property (nonatomic, strong) NZLabel     *contentLabel;

@property (nonatomic, strong) UIView      *titleLineView;

@property (nonatomic, strong) MyRelativeLayout *availBalanceLayout;// 可用余额

@property (nonatomic, strong) NZLabel     *availBalanceLabel;

@property (nonatomic, strong) NZLabel     *availBalanceContentLabel;

@property (nonatomic, strong) UIView      *availBalanceRound;

@property (nonatomic, strong) UIView      *availBalanceLinView;

@property (nonatomic, strong) MyRelativeLayout *waitPrincipalLayout;// 待收本金

@property (nonatomic, strong) NZLabel     *waitPrincipalLabel;

@property (nonatomic, strong) NZLabel     *waitPrincipalContentLabel;

@property (nonatomic, strong) UIView      *waitPrincipalRound;

@property (nonatomic, strong) UIView      *waitPrincipalLinView;

@property (nonatomic, strong) MyRelativeLayout *waitInterestLayout;// 预期利息

@property (nonatomic, strong) NZLabel     *waitInterestLabel;

@property (nonatomic, strong) NZLabel     *waitInterestContentLabel;

@property (nonatomic, strong) UIView      *waitInterestRound;

@property (nonatomic, strong) UIView      *waitInterestLinView;

@property (nonatomic, strong) MyRelativeLayout *frozenBalanceLayout;// 冻结金额

@property (nonatomic, strong) NZLabel     *frozenBalanceLabel;

@property (nonatomic, strong) NZLabel     *frozenBalanceContentLabel;

@property (nonatomic, strong) UIView      *frozenBalanceRound;

@property (nonatomic, strong) UIView      *frozenBalanceLinView;
@end
@implementation UCFAccountDetailTurnoverCell

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
        [self.bkLayout addSubview:self.titleLabel];
        [self.bkLayout addSubview:self.contentLabel];
        [self.bkLayout addSubview:self.titleLineView];
        
        [self.bkLayout addSubview:self.availBalanceLayout];
        //        [self.availBalanceLayout addSubview:self.availBalanceRound];
        [self.availBalanceLayout addSubview:self.availBalanceLabel];
        [self.availBalanceLayout addSubview:self.availBalanceContentLabel];
        //        [self.availBalanceLayout addSubview:self.availBalanceLinView];
        
        [self.bkLayout addSubview:self.waitPrincipalLayout];
        //        [self.waitPrincipalLayout addSubview:self.waitPrincipalRound];
        [self.waitPrincipalLayout addSubview:self.waitPrincipalLabel];
        [self.waitPrincipalLayout addSubview:self.waitPrincipalContentLabel];
        //        [self.waitPrincipalLayout addSubview:self.waitPrincipalLinView];
        
        [self.bkLayout addSubview:self.waitInterestLayout];
        //        [self.waitInterestLayout addSubview:self.waitInterestRound];
        [self.waitInterestLayout addSubview:self.waitInterestLabel];
        [self.waitInterestLayout addSubview:self.waitInterestContentLabel];
        //        [self.waitInterestLayout addSubview:self.waitInterestLinView];
        
        [self.bkLayout addSubview:self.frozenBalanceLayout];
        //        [self.frozenBalanceLayout addSubview:self.frozenBalanceRound];
        [self.frozenBalanceLayout addSubview:self.frozenBalanceLabel];
        [self.frozenBalanceLayout addSubview:self.frozenBalanceContentLabel];
        //        [self.frozenBalanceLayout addSubview:self.frozenBalanceLinView];
        
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
        _titleVerticalView.backgroundColor = [Color color:PGColorOptionTitlerRead];
        _titleVerticalView.myTop = 18;
        _titleVerticalView.myHeight = 16;
        _titleVerticalView.myWidth = 4;
        _titleVerticalView.myLeft = 15;
        _titleVerticalView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
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
        _titleLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _titleLineView.topPos.equalTo(self.titleVerticalView.bottomPos).offset(15);
        _titleLineView.myHeight = 0.5;
        _titleLineView.myRight = 15;
        _titleLineView.myLeft = 15;
    }
    return _titleLineView;
}

- (NZLabel *)contentLabel
{
    if (nil == _contentLabel) {
        _contentLabel = [NZLabel new];
        _contentLabel.centerYPos.equalTo(self.titleVerticalView.centerYPos);
        _contentLabel.myRight = 25;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.font = [Color gc_Font:18.0];
        _contentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        //        _titleLabel.text = @"可用余额";
        //        [_titleLabel sizeToFit];
    }
    return _contentLabel;
}
- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.centerYPos.equalTo(self.titleVerticalView.centerYPos);
        _titleLabel.leftPos.equalTo(self.titleVerticalView.rightPos).offset(6);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [Color gc_Font:18.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        //        _titleLabel.text = @"可用余额";
        //        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (MyRelativeLayout *)availBalanceLayout
{
    if (nil == _availBalanceLayout){
        _availBalanceLayout = [MyRelativeLayout new];
        _availBalanceLayout.backgroundColor = [UIColor whiteColor];
        _availBalanceLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _availBalanceLayout.myWidth = PGScreenWidth;
        _availBalanceLayout.myHeight = LayoutHeight;
        _availBalanceLayout.myLeft = 0;
        _availBalanceLayout.topPos.equalTo(self.titleLineView.bottomPos).offset(5);
        //        _wjLayout.myCenterX = - 70;
    }
    return _availBalanceLayout;
}
- (UIView *)availBalanceRound
{
    if (nil == _availBalanceRound) {
        _availBalanceRound = [UIView new];
        _availBalanceRound.myLeft = 25;
        _availBalanceRound.myCenterY = 0;
        _availBalanceRound.myWidth = 7;
        _availBalanceRound.myHeight = 7;
        _availBalanceRound.backgroundColor = PNBlue;
        _availBalanceRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _availBalanceRound;
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

- (NZLabel *)availBalanceContentLabel
{
    if (nil == _availBalanceContentLabel) {
        _availBalanceContentLabel = [NZLabel new];
        _availBalanceContentLabel.myCenterY = 0;
        _availBalanceContentLabel.myRight = 25;
        _availBalanceContentLabel.textAlignment = NSTextAlignmentRight;
        _availBalanceContentLabel.font = [Color gc_Font:14.0];
        _availBalanceContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _availBalanceContentLabel.text = @"  ";
        [_availBalanceContentLabel sizeToFit];
    }
    return _availBalanceContentLabel;
}

-(UIView *)availBalanceLinView
{
    if (nil == _availBalanceLinView) {
        _availBalanceLinView = [UIView new];
        _availBalanceLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _availBalanceLinView.myBottom = 0;
        _availBalanceLinView.myHeight = 0.5;
        _availBalanceLinView.myWidth = PGScreenWidth;
        _availBalanceLinView.myLeft = 18;
    }
    return _availBalanceLinView;
}


- (MyRelativeLayout *)waitPrincipalLayout
{
    if (nil == _waitPrincipalLayout){
        _waitPrincipalLayout = [MyRelativeLayout new];
        _waitPrincipalLayout.backgroundColor = [UIColor whiteColor];
        _waitPrincipalLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _waitPrincipalLayout.myWidth = PGScreenWidth;
        _waitPrincipalLayout.myHeight = LayoutHeight;
        _waitPrincipalLayout.myLeft = 0;
        _waitPrincipalLayout.topPos.equalTo(self.availBalanceLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _waitPrincipalLayout;
}

- (UIView *)waitPrincipalRound
{
    if (nil == _waitPrincipalRound) {
        _waitPrincipalRound = [UIView new];
        _waitPrincipalRound.myLeft = 25;
        _waitPrincipalRound.myCenterY = 0;
        _waitPrincipalRound.myWidth = 7;
        _waitPrincipalRound.myHeight = 7;
        _waitPrincipalRound.backgroundColor = PNOrange;
        _waitPrincipalRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _waitPrincipalRound;
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
        _waitPrincipalLabel.text = @"冻结资金";
        [_waitPrincipalLabel sizeToFit];
    }
    return _waitPrincipalLabel;
}

- (NZLabel *)waitPrincipalContentLabel
{
    if (nil == _waitPrincipalContentLabel) {
        _waitPrincipalContentLabel = [NZLabel new];
        _waitPrincipalContentLabel.myCenterY = 0;
        _waitPrincipalContentLabel.myRight = 25;
        _waitPrincipalContentLabel.textAlignment = NSTextAlignmentRight;
        _waitPrincipalContentLabel.font = [Color gc_Font:14.0];
        _waitPrincipalContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitPrincipalContentLabel.text = @"  ";
        [_waitPrincipalContentLabel sizeToFit];
    }
    return _waitPrincipalContentLabel;
}

-(UIView *)waitPrincipalLinView
{
    if (nil == _waitPrincipalLinView) {
        _waitPrincipalLinView = [UIView new];
        _waitPrincipalLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _waitPrincipalLinView.myBottom = 0;
        _waitPrincipalLinView.myHeight = 0.5;
        _waitPrincipalLinView.myWidth = PGScreenWidth;
        _waitPrincipalLinView.myLeft = 18;
    }
    return _waitPrincipalLinView;
}
- (MyRelativeLayout *)waitInterestLayout
{
    if (nil == _waitInterestLayout){
        _waitInterestLayout = [MyRelativeLayout new];
        _waitInterestLayout.backgroundColor = [UIColor whiteColor];
        _waitInterestLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _waitInterestLayout.myWidth = PGScreenWidth;
        _waitInterestLayout.myHeight = LayoutHeight;
        _waitInterestLayout.myLeft = 0;
        _waitInterestLayout.topPos.equalTo(self.waitPrincipalLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _waitInterestLayout;
}

- (UIView *)waitInterestRound
{
    if (nil == _waitInterestRound) {
        _waitInterestRound = [UIView new];
        _waitInterestRound.myLeft = 25;
        _waitInterestRound.myCenterY = 0;
        _waitInterestRound.myWidth = 7;
        _waitInterestRound.myHeight = 7;
        _waitInterestRound.backgroundColor = PNYellow;
        _waitInterestRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _waitInterestRound;
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

- (NZLabel *)waitInterestContentLabel
{
    if (nil == _waitInterestContentLabel) {
        _waitInterestContentLabel = [NZLabel new];
        _waitInterestContentLabel.myCenterY = 0;
        _waitInterestContentLabel.myRight = 25;
        _waitInterestContentLabel.textAlignment = NSTextAlignmentRight;
        _waitInterestContentLabel.font = [Color gc_Font:14.0];
        _waitInterestContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _waitInterestContentLabel.text = @"  ";
        [_waitInterestContentLabel sizeToFit];
    }
    return _waitInterestContentLabel;
}

-(UIView *)waitInterestLinView
{
    if (nil == _waitInterestLinView) {
        _waitInterestLinView = [UIView new];
        _waitInterestLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _waitInterestLinView.myBottom = 0;
        _waitInterestLinView.myHeight = 0.5;
        _waitInterestLinView.myWidth = PGScreenWidth;
        _waitInterestLinView.myLeft = 18;
    }
    return _waitInterestLinView;
}
- (MyRelativeLayout *)frozenBalanceLayout
{
    if (nil == _frozenBalanceLayout){
        _frozenBalanceLayout = [MyRelativeLayout new];
        _frozenBalanceLayout.backgroundColor = [UIColor whiteColor];
        _frozenBalanceLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _frozenBalanceLayout.myWidth = PGScreenWidth;
        _frozenBalanceLayout.myHeight = LayoutHeight;
        _frozenBalanceLayout.myLeft = 0;
        _frozenBalanceLayout.topPos.equalTo(self.waitInterestLayout.bottomPos);
        //        _wjLayout.myCenterX = - 70;
    }
    return _frozenBalanceLayout;
}

- (UIView *)frozenBalanceRound
{
    if (nil == _frozenBalanceRound) {
        _frozenBalanceRound = [UIView new];
        _frozenBalanceRound.myLeft = 25;
        _frozenBalanceRound.myCenterY = 0;
        _frozenBalanceRound.myWidth = 7;
        _frozenBalanceRound.myHeight = 7;
        _frozenBalanceRound.backgroundColor = PNPinkRed;
        _frozenBalanceRound.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        {
            //设置圆角的半径
            sbv.layer.cornerRadius = 3.5;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _frozenBalanceRound;
}

- (NZLabel *)frozenBalanceLabel
{
    if (nil == _frozenBalanceLabel) {
        _frozenBalanceLabel = [NZLabel new];
        _frozenBalanceLabel.myCenterY = 0;
        _frozenBalanceLabel.myLeft = LabelLeft;
        _frozenBalanceLabel.textAlignment = NSTextAlignmentLeft;
        _frozenBalanceLabel.font = [Color gc_Font:15.0];
        _frozenBalanceLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _frozenBalanceLabel.text = @"备注";
        [_frozenBalanceLabel sizeToFit];
    }
    return _frozenBalanceLabel;
}

- (NZLabel *)frozenBalanceContentLabel
{
    if (nil == _frozenBalanceContentLabel) {
        _frozenBalanceContentLabel = [NZLabel new];
        _frozenBalanceContentLabel.myCenterY = 0;
        _frozenBalanceContentLabel.myRight = 25;
        _frozenBalanceContentLabel.textAlignment = NSTextAlignmentRight;
        _frozenBalanceContentLabel.font = [Color gc_Font:14.0];
        _frozenBalanceContentLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _frozenBalanceContentLabel.text = @"  ";
        [_frozenBalanceContentLabel sizeToFit];
    }
    return _frozenBalanceContentLabel;
}

-(UIView *)frozenBalanceLinView
{
    if (nil == _frozenBalanceLinView) {
        _frozenBalanceLinView = [UIView new];
        _frozenBalanceLinView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _frozenBalanceLinView.myBottom = 0;
        _frozenBalanceLinView.myHeight = 0.5;
        _frozenBalanceLinView.myWidth = PGScreenWidth;
        _frozenBalanceLinView.myLeft = 18;
    }
    return _frozenBalanceLinView;
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
    if (nil == model || ![model isKindOfClass:[FundsDetailFrame class]]) {
        return;
    }
//    FAccountDetailWZAndZXViewController: 0x10ef06ad0>请求返回数据:{"status":"1","pageData":{"result":[{"waterTypeName":"成功放款，扣除冻结资金","createTime":"2017-10-11 18:07:17","cashValue":"0.00","frozen":"-100.00","actType":"","remark":"消费贷-掌0002","yearMonth":"2017年10月"}
    FundsDetailFrame *newModel = model;
    FundsDetailModel *ass = newModel.fundsDetailModel;
   
    self.availBalanceContentLabel.text = [NSString AddCNY:ass.cashValue];
    self.waitPrincipalContentLabel.text = [NSString AddCNY:ass.frozen];
    self.waitInterestContentLabel.text = ass.createTime;
    self.frozenBalanceContentLabel.text = ass.remark;

    [self.availBalanceContentLabel sizeToFit] ;
    [self.waitPrincipalContentLabel sizeToFit];
    [self.waitInterestContentLabel sizeToFit];
    [self.frozenBalanceContentLabel sizeToFit];
    
    self.titleLabel.text = ass.waterTypeName;
    [self.titleLabel sizeToFit];
}
@end
