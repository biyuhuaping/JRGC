//
//  UCFMineHeadCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineHeadCell.h"
#import "NZLabel.h"
#import "UCFNewMineViewController.h"
@interface UCFMineHeadCell()
@property (nonatomic, strong) MyRelativeLayout *userMesageLayout;// 用户信息

@property (nonatomic, strong) UIButton *headImageBtn;//头像

@property (nonatomic, strong) UIButton *messageImageBtn;//消息

@property (nonatomic, strong) NZLabel     *totalAssetsLabel;//总资产

@property (nonatomic, strong) NZLabel     *totalAssetsMoneyLabel;//总资产多少元

@property (nonatomic, strong) NZLabel     *expectedInterestLabel;//预期利息

@property (nonatomic, strong) NZLabel     *expectedInterestMoneyLabel;//预期利息多少元

@property (nonatomic, strong) UIButton    *amountShownBtn;//金额是否展示

@property (nonatomic, strong) UIButton    *payBtn;//充值按钮

@property (nonatomic, strong) MyRelativeLayout *topUpWithdrawalLayout; //充值提现

@property (nonatomic, strong) NZLabel     *accountBalanceLabel;//账户总余额

@property (nonatomic, strong) NZLabel     *accountBalanceMoneyLabel;//账户总余额多少元

@property (nonatomic, strong) NZLabel     *topUpWithdrawalLabel;//充值与提现

@property (nonatomic, strong) UIImageView *arrowImageView;//箭头

@property (nonatomic, strong) UIButton    *arrowBtn;//点击按钮

@end
@implementation UCFMineHeadCell

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
        self.rootLayout.backgroundColor = [UIColor clearColor];
        [self.rootLayout addSubview:self.userMesageLayout];
        [self.userMesageLayout addSubview:self.headImageBtn];
        [self.userMesageLayout addSubview:self.messageImageBtn];
        [self.userMesageLayout addSubview:self.totalAssetsLabel];
        [self.userMesageLayout addSubview:self.totalAssetsMoneyLabel];
        [self.userMesageLayout addSubview:self.expectedInterestLabel];
        [self.userMesageLayout addSubview:self.expectedInterestMoneyLabel];
        [self.userMesageLayout addSubview:self.amountShownBtn];
        [self.userMesageLayout addSubview:self.payBtn];
        
        [self.rootLayout addSubview:self.topUpWithdrawalLayout];
        [self.topUpWithdrawalLayout addSubview:self.accountBalanceLabel];
        [self.topUpWithdrawalLayout addSubview:self.accountBalanceMoneyLabel];
        [self.topUpWithdrawalLayout addSubview:self.topUpWithdrawalLabel];
        [self.topUpWithdrawalLayout addSubview:self.arrowImageView];
        [self.topUpWithdrawalLayout addSubview:self.arrowBtn];
        
    }
    return self;
}

- (MyRelativeLayout *)topUpWithdrawalLayout
{
    if (nil == _topUpWithdrawalLayout) {
        _topUpWithdrawalLayout = [MyRelativeLayout new];
        _topUpWithdrawalLayout.backgroundColor = [UIColor whiteColor];
        _topUpWithdrawalLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _topUpWithdrawalLayout.myHeight = 235;
        _topUpWithdrawalLayout.widthSize.equalTo(self.rootLayout.widthSize);
        _topUpWithdrawalLayout.topPos.equalTo(self.rootLayout.topPos);
        _topUpWithdrawalLayout.myLeft = 0;
    }
    return _topUpWithdrawalLayout;
}
- (MyRelativeLayout *)userMesageLayout
{
    if (nil == _userMesageLayout) {
        _userMesageLayout = [MyRelativeLayout new];
        _userMesageLayout.backgroundColor = [UIColor whiteColor];
        _userMesageLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _userMesageLayout.myHeight = 50;
        _userMesageLayout.widthSize.equalTo(self.rootLayout.widthSize);
        _userMesageLayout.bottomPos.equalTo(self.rootLayout.bottomPos);
        _userMesageLayout.myLeft = 0;
        
        
    }
    return _userMesageLayout;
}
- (UIButton *)headImageBtn
{
    if (nil == _headImageBtn) {
        _headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageBtn.topPos.equalTo(@30);
        _headImageBtn.leftPos.equalTo(@15);
        _headImageBtn.myHeight = 40;
        _headImageBtn.myHeight = 40;
        _headImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_headImageBtn setImage:[UIImage imageNamed:@"MineUserHead.png"] forState:UIControlStateNormal];
        _headImageBtn.tag = 10001;
        [_headImageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headImageBtn;
}
- (UIButton *)messageImageBtn
{
    if (nil == _messageImageBtn) {
        _messageImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageImageBtn.centerYPos.equalTo(self.headImageBtn.centerYPos);
        _messageImageBtn.rightPos.equalTo(@15);
        _messageImageBtn.myHeight = self.headImageBtn.myHeight;
        _messageImageBtn.myWidth = self.headImageBtn.myWidth;
        _messageImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_messageImageBtn setImage:[UIImage imageNamed:@"MineMessageicon.png"] forState:UIControlStateNormal];
        _messageImageBtn.tag = 10002;
        [_messageImageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _messageImageBtn;
}

- (NZLabel *)totalAssetsLabel
{
    if (nil == _totalAssetsLabel) {
        _totalAssetsLabel = [NZLabel new];
        _totalAssetsLabel.topPos.equalTo(self.headImageBtn.bottomPos).offset(8);
        _totalAssetsLabel.leftPos.equalTo(@25);
        _totalAssetsLabel.textAlignment = NSTextAlignmentLeft;
        _totalAssetsLabel.font = [Color gc_Font:14.0];
        _totalAssetsLabel.textColor = [Color color:PGColorOptionThemeWhite];
        _totalAssetsLabel.text = @"总资产";
        [_totalAssetsLabel sizeToFit];
    }
    return _totalAssetsLabel;
}
- (UIButton*)amountShownBtn{
    
    if(_amountShownBtn == nil)
    {
        _amountShownBtn = [UIButton buttonWithType:0];
        _amountShownBtn.centerYPos.equalTo(self.totalAssetsLabel.centerYPos);
        _amountShownBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _amountShownBtn.leftPos.equalTo(self.totalAssetsLabel.rightPos).offset(0);
        _amountShownBtn.widthSize.equalTo(@40);
        _amountShownBtn.heightSize.equalTo(@40);
        [_amountShownBtn setImage:[UIImage imageNamed:@"MineShowCapital.png"] forState:UIControlStateNormal];
        _amountShownBtn.tag = 10003;
        [_amountShownBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _amountShownBtn;
}

- (NZLabel *)totalAssetsMoneyLabel
{
    if (nil == _totalAssetsMoneyLabel) {
        _totalAssetsMoneyLabel = [NZLabel new];
        _totalAssetsMoneyLabel.topPos.equalTo(self.totalAssetsLabel.bottomPos).offset(12);
        _totalAssetsMoneyLabel.leftPos.equalTo(self.totalAssetsLabel.leftPos);
        _totalAssetsMoneyLabel.rightPos.equalTo(self.payBtn.leftPos);
        _totalAssetsMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _totalAssetsMoneyLabel.font = [Color gc_Font:30.0];
        _totalAssetsMoneyLabel.textColor = [Color color:PGColorOptionThemeWhite];
        //        [_titleLabel sizeToFit];
    }
    return _totalAssetsMoneyLabel;
}

- (UIButton*)payBtn{
    
    if(_payBtn == nil)
    {
        _payBtn = [UIButton buttonWithType:0];
        _payBtn.centerYPos.equalTo(self.totalAssetsMoneyLabel.centerYPos);
        _payBtn.rightPos.equalTo(@20);
        _payBtn.widthSize.equalTo(@90);
        _payBtn.heightSize.equalTo(@30 );
        [_payBtn setTitle:@"充值" forState:UIControlStateNormal];
        _payBtn.titleLabel.font= [Color gc_Font:14.0];
        [_payBtn setTitleColor:[Color color:PGColorOptionTitleOrange] forState:UIControlStateNormal];
        _payBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 15;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
        _payBtn.tag = 10004;
        [_payBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (NZLabel *)expectedInterestLabel
{
    if (nil == _expectedInterestLabel) {
        _expectedInterestLabel = [NZLabel new];
        _expectedInterestLabel.topPos.equalTo(self.totalAssetsMoneyLabel.bottomPos).offset(10);
        _expectedInterestLabel.leftPos.equalTo(self.totalAssetsLabel.leftPos);
        _expectedInterestLabel.textAlignment = NSTextAlignmentLeft;
        _expectedInterestLabel.font = [Color gc_Font:13.0];
        _expectedInterestLabel.textColor = self.totalAssetsMoneyLabel.textColor;
        _expectedInterestLabel.text = @"预期利息";
        [_expectedInterestLabel sizeToFit];
    }
    return _expectedInterestLabel;
}

- (NZLabel *)expectedInterestMoneyLabel //预期利息多少元
{
    if (nil == _expectedInterestMoneyLabel) {
        _expectedInterestMoneyLabel = [NZLabel new];
        _expectedInterestMoneyLabel.centerYPos.equalTo(self.expectedInterestLabel.centerYPos);
        _expectedInterestMoneyLabel.leftPos.equalTo(self.expectedInterestLabel.rightPos).offset(10);
        _expectedInterestMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _expectedInterestMoneyLabel.font = [Color gc_Font:13.0];
        _expectedInterestMoneyLabel.textColor = self.totalAssetsMoneyLabel.textColor;
        //        [_titleLabel sizeToFit];
    }
    return _expectedInterestMoneyLabel;
}

- (NZLabel *)accountBalanceLabel//账户总余额
{
    if (nil == _accountBalanceLabel) {
        _accountBalanceLabel = [NZLabel new];
        _accountBalanceLabel.centerYPos.equalTo(self.topUpWithdrawalLayout.centerYPos);
        _accountBalanceLabel.leftPos.equalTo(@25);
        _accountBalanceLabel.textAlignment = NSTextAlignmentLeft;
        _accountBalanceLabel.font = [Color gc_Font:14.0];
        _accountBalanceLabel.textColor = [Color color:PGColorOptionTitleBlackGray];
        _accountBalanceLabel.text = @"账户总余额";
        [_accountBalanceLabel sizeToFit];
    }
    return _accountBalanceLabel;
}
- (NZLabel *)accountBalanceMoneyLabel
{
    if (nil == _accountBalanceMoneyLabel) {
        _accountBalanceMoneyLabel = [NZLabel new];
        _accountBalanceMoneyLabel.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
        _accountBalanceMoneyLabel.leftPos.equalTo(self.accountBalanceLabel.rightPos).offset(10);
        _accountBalanceMoneyLabel.rightPos.equalTo(self.topUpWithdrawalLabel.leftPos);
        _accountBalanceMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _accountBalanceMoneyLabel.font = [Color gc_Font:15.0];
        _accountBalanceMoneyLabel.textColor = [Color color:PGColorOptionTitleOrange];
        //        [_titleLabel sizeToFit];
    }
    return _accountBalanceMoneyLabel;
}
- (NZLabel *)topUpWithdrawalLabel
{
    if (nil == _topUpWithdrawalLabel) {
        _topUpWithdrawalLabel = [NZLabel new];
        _topUpWithdrawalLabel.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
        _topUpWithdrawalLabel.rightPos.equalTo(self.arrowImageView.leftPos).offset(6);
        _topUpWithdrawalLabel.textAlignment = NSTextAlignmentLeft;
        _topUpWithdrawalLabel.font = [Color gc_Font:12.0];
        _topUpWithdrawalLabel.textColor = [Color color:PGColorOptionTitleBlackGray];
        _topUpWithdrawalLabel.text = @"充值与提现";
        [_topUpWithdrawalLabel sizeToFit];
        
    }
    return _topUpWithdrawalLabel;
}

- (UIImageView *)arrowImageView
{
    if (nil == _arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.centerYPos.equalTo(self.accountBalanceLabel.centerYPos);
        _arrowImageView.rightPos.equalTo(@15);
        _arrowImageView.myWidth = 8;
        _arrowImageView.myHeight = 13;
        _arrowImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
    }
    return _arrowImageView;
}
- (UIButton*)arrowBtn{
    
    if(_arrowBtn == nil)
    {
        _arrowBtn = [UIButton buttonWithType:0];
        _arrowBtn.centerYPos.equalTo(self.rootLayout.centerYPos);
        _arrowBtn.centerXPos.equalTo(self.rootLayout.centerXPos);
        _arrowBtn.widthSize.equalTo(self.topUpWithdrawalLayout.widthSize);
        _arrowBtn.heightSize.equalTo(self.topUpWithdrawalLayout.heightSize);;
        _arrowBtn.adjustsImageWhenHighlighted = NO;
        _arrowBtn.tag = 10005;
        [_arrowBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

- (void)buttonClick:(UIButton *)btn
{
    if ([self.bc isKindOfClass:[UCFNewMineViewController class]]) {
        [(UCFNewMineViewController *)self.bc headCellButtonClick:btn];
    }
    
}
- (void)refreshCellData:(id)data
{
    [super refreshCellData:data];
    
}
@end
