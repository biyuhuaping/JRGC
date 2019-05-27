//
//  UCFMineTableViewHead.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineTableViewHead.h"
#import "NZLabel.h"
#import "UCFNewMineViewController.h"
#import "UCFMineMyReceiptModel.h"
#import "UCFMineMySimpleInfoModel.h"

#import "FirstWaves.h"
#import "SecondWaves.h"
#import "ThirdWaves.h"
@interface UCFMineTableViewHead ()

@property (nonatomic, strong) UIImageView *bkImageView;//背景图

@property (nonatomic, strong) UIButton *headImageBtn;//头像

@property (nonatomic, strong) UIButton *memberLeverBtn;//用户等级

@property (nonatomic, strong) UIButton *messageImageBtn;//消息

@property (nonatomic, strong) NZLabel     *totalAssetsLabel;//总资产

@property (nonatomic, strong) NZLabel     *totalAssetsMoneyLabel;//总资产多少元

@property (nonatomic, strong) NZLabel     *expectedInterestLabel;//预期利息

@property (nonatomic, strong) NZLabel     *expectedInterestMoneyLabel;//预期利息多少元

@property (nonatomic, strong) UIButton    *amountShownBtn;//金额是否展示

@property (nonatomic, strong) UIButton    *payBtn;//充值按钮

@property (nonatomic, strong) UIImageView *waveImageView;//背景图

@property (nonatomic,strong)FirstWaves *firstWare;

@property (nonatomic,strong)SecondWaves *secondWare;

@property (nonatomic,strong)ThirdWaves *thirdWare;

@property (nonatomic, strong) MyRelativeLayout *topUpWithdrawalLayout; //充值提现

@property (nonatomic, strong) NZLabel     *accountBalanceLabel;//账户总余额

@property (nonatomic, strong) NZLabel     *accountBalanceMoneyLabel;//账户总余额多少元

@property (nonatomic, strong) NZLabel     *topUpWithdrawalLabel;//充值与提现

@property (nonatomic, strong) UIImageView *arrowImageView;//箭头

@property (nonatomic, strong) UIButton    *arrowBtn;//点击按钮

@property (nonatomic, copy)   NSString *total;//总资产

@property (nonatomic, copy)   NSString *totalDueIn;//总待收利息

@property (nonatomic, copy)   NSString *cashBalance;//余额

@end
@implementation UCFMineTableViewHead

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        [self.rootLayout addSubview:self.userMesageLayout];
        [self.userMesageLayout addSubview:self.bkImageView];
        [self.userMesageLayout addSubview:self.memberLeverBtn];
        [self.userMesageLayout addSubview:self.headImageBtn];
        [self.userMesageLayout addSubview:self.messageImageBtn];
        [self.userMesageLayout addSubview:self.totalAssetsLabel];
        [self.userMesageLayout addSubview:self.totalAssetsMoneyLabel];
        [self.userMesageLayout addSubview:self.expectedInterestLabel];
        [self.userMesageLayout addSubview:self.expectedInterestMoneyLabel];
        [self.userMesageLayout addSubview:self.amountShownBtn];
        [self.userMesageLayout addSubview:self.payBtn];
//        [self.userMesageLayout addSubview:self.waveImageView];
        
        [self.userMesageLayout addSubview:self.firstWare];
        [self.userMesageLayout addSubview:self.secondWare];
        [self.userMesageLayout addSubview:self.thirdWare];
        
        
        [self.rootLayout addSubview:self.topUpWithdrawalLayout];
        [self.topUpWithdrawalLayout addSubview:self.accountBalanceLabel];
        [self.topUpWithdrawalLayout addSubview:self.accountBalanceMoneyLabel];
        [self.topUpWithdrawalLayout addSubview:self.topUpWithdrawalLabel];
        [self.topUpWithdrawalLayout addSubview:self.arrowImageView];
        [self.topUpWithdrawalLayout addSubview:self.arrowBtn];
        
        
    }
    return self;
}

- (SecondWaves *)secondWare
{
    if (nil == _secondWare) {
        _secondWare = [[SecondWaves alloc]initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _secondWare.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
        _secondWare.alpha=0.5;
        _secondWare.myLeft = 0;
        _secondWare.myBottom = 0;
    }
    return _secondWare;
}

- (ThirdWaves *)thirdWare
{
    if (nil == _thirdWare) {
        _thirdWare = [[ThirdWaves alloc]initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _thirdWare.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
        _thirdWare.alpha=0.5;
        _thirdWare.myLeft = 0;
        _thirdWare.myBottom = 0;
    }
    return _thirdWare;
}

- (FirstWaves *)firstWare
{
    if (nil == _firstWare) {
        _firstWare = [[FirstWaves alloc]initWithFrame:CGRectMake(0, 0, PGScreenWidth, 50)];
        _firstWare.transform = CGAffineTransformMakeRotation(180 *M_PI / 180.0);
        _firstWare.alpha=1.0;
        _firstWare.myLeft = 0;
        _firstWare.myBottom = 0;
    }
    return _firstWare;
}

- (MyRelativeLayout *)topUpWithdrawalLayout
{
    if (nil == _topUpWithdrawalLayout) {
        _topUpWithdrawalLayout = [MyRelativeLayout new];
        _topUpWithdrawalLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        _topUpWithdrawalLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        _topUpWithdrawalLayout.myHeight = 50;
        _topUpWithdrawalLayout.widthSize.equalTo(self.rootLayout.widthSize);
        _topUpWithdrawalLayout.bottomPos.equalTo(self.rootLayout.bottomPos);
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
        _userMesageLayout.myHeight = 235;
        _userMesageLayout.widthSize.equalTo(self.rootLayout.widthSize);
        _userMesageLayout.topPos.equalTo(self.rootLayout.topPos);
        _userMesageLayout.myLeft = 0;
        
        
    }
    return _userMesageLayout;
}

- (UIImageView *)bkImageView
{
    if (nil == _bkImageView) {
        _bkImageView = [[UIImageView alloc] init];
        _bkImageView.myLeft = 0;
        _bkImageView.myTop = 0;
        _bkImageView.widthSize.equalTo(self.userMesageLayout.widthSize);
        _bkImageView.myHeight = 235;
        _bkImageView.image = [UIImage imageNamed:@"mine_head_bg"];
    }
    return _bkImageView;
}

- (UIImageView *)waveImageView
{
    if (nil == _waveImageView) {
        _waveImageView = [[UIImageView alloc] init];
        _waveImageView.myLeft = 0;
        _waveImageView.myBottom = 0;
        _waveImageView.myRight = 0;
        _waveImageView.myHeight = 42;
        _waveImageView.image = [UIImage imageNamed:@"wave"];
    }
    return _waveImageView;
}
- (UIButton *)headImageBtn
{
    if (nil == _headImageBtn) {
        _headImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _headImageBtn.myTop = 16;//(@30);
        _headImageBtn.myLeft = 0;
        _headImageBtn.myHeight = 63;
        _headImageBtn.myWidth = 67;
//        表示 上 左 下 右的偏移量;解释下,这四个量的含义:
//        top : 为正数的时候,是往下偏移,为负数的时候往上偏移;
//        left : 为正数的时候往右偏移,为负数的时候往左偏移;
//        bottom : 为正数的时候往上偏移,为负数的时候往下偏移;
//        right :为正数的时候往左偏移,为负数的时候往右偏移;
        _headImageBtn.imageEdgeInsets = UIEdgeInsetsMake(30,15, 0, 0);
        _headImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_headImageBtn setImage:[UIImage imageNamed:@"mine_icon_head"] forState:UIControlStateNormal];
        _headImageBtn.tag = 10001;
        [_headImageBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headImageBtn;
}

- (UIButton *)memberLeverBtn
{
    if (nil == _memberLeverBtn) {
        _memberLeverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _memberLeverBtn.titleLabel.font = [Color gc_Font:15.0];
        [_memberLeverBtn setBackgroundColor:[Color color:PGColorOpttonMyVipBackgroundColor]];
        [_memberLeverBtn setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        _memberLeverBtn.bottomPos.equalTo(self.headImageBtn.bottomPos).offset(5);
        _memberLeverBtn.leftPos.equalTo(self.headImageBtn.rightPos).offset(0);
        _memberLeverBtn.myHeight = 24;
        _memberLeverBtn.myWidth = 80;
        _memberLeverBtn.tag = 10006;
        [_memberLeverBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _memberLeverBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 12;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _memberLeverBtn;
}
- (UIButton *)messageImageBtn
{
    if (nil == _messageImageBtn) {
        _messageImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageImageBtn.centerYPos.equalTo(self.memberLeverBtn.centerYPos);
        _messageImageBtn.rightPos.equalTo(@0);
        _messageImageBtn.heightSize.equalTo(self.headImageBtn.heightSize);
        _messageImageBtn.widthSize.equalTo(self.headImageBtn.widthSize);
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
        _totalAssetsLabel.topPos.equalTo(self.headImageBtn.bottomPos).offset(10);
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
        _totalAssetsMoneyLabel.topPos.equalTo(self.totalAssetsLabel.bottomPos).offset(5);
        _totalAssetsMoneyLabel.leftPos.equalTo(self.totalAssetsLabel.leftPos);
        _totalAssetsMoneyLabel.rightPos.equalTo(self.payBtn.leftPos);
        _totalAssetsMoneyLabel.textAlignment = NSTextAlignmentLeft;
        _totalAssetsMoneyLabel.font = [Color gc_ANC_font:33.0];
        _totalAssetsMoneyLabel.textColor = [Color color:PGColorOptionThemeWhite];
        _totalAssetsMoneyLabel.text =@"   ";
        [_totalAssetsMoneyLabel sizeToFit];
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
        [_payBtn setBackgroundColor:[Color color:PGColorOptionThemeWhite]];
        
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
        _expectedInterestLabel.topPos.equalTo(self.totalAssetsMoneyLabel.bottomPos).offset(4);
        _expectedInterestLabel.leftPos.equalTo(self.totalAssetsLabel.leftPos);
        _expectedInterestLabel.textAlignment = NSTextAlignmentLeft;
        _expectedInterestLabel.font = [Color gc_Font:14.0];
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
        _expectedInterestMoneyLabel.font = [Color gc_ANC_font:18.0];
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
        _accountBalanceMoneyLabel.font = [Color gc_ANC_font:20.0];
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
        _topUpWithdrawalLabel.textColor = [Color color:PGColorOptionTitleGray];
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
        _arrowBtn.centerYPos.equalTo(self.topUpWithdrawalLayout.centerYPos);
        _arrowBtn.centerXPos.equalTo(self.topUpWithdrawalLayout.centerXPos);
        _arrowBtn.widthSize.equalTo(self.topUpWithdrawalLayout.widthSize);
        _arrowBtn.heightSize.equalTo(self.topUpWithdrawalLayout.heightSize);
        _arrowBtn.adjustsImageWhenHighlighted = NO;
        _arrowBtn.tag = 10005;
        [_arrowBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowBtn;
}

- (void)buttonClick:(UIButton *)btn
{
    self.callBack(btn); //1
}

#pragma mark - 数据重新加载
- (void)showMyReceipt:(UCFMineMyReceiptModel *__nonnull)myModel
{
    if (myModel == nil || ![myModel isKindOfClass:[UCFMineMyReceiptModel class]]) {
        self.totalAssetsMoneyLabel.text = @"   ";//总资产
        self.expectedInterestMoneyLabel.text = @"";//总待收利息
        self.accountBalanceMoneyLabel.text = @"";//余额
        [self.memberLeverBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [self.memberLeverBtn setTitle:@"" forState:UIControlStateNormal];
        [self.messageImageBtn setImage:[UIImage imageNamed:@"MineMessageicon"] forState:UIControlStateNormal];
    }
    else
    {
        self.total = myModel.data.total;//总资产
        self.totalDueIn = myModel.data.totalDueIn;//总待收利息
        self.cashBalance = myModel.data.cashBalance;//余额
        
        self.totalAssetsMoneyLabel.text =  [NSString AddCNY:self.total];//总资产
        [self.totalAssetsMoneyLabel setFont:[Color gc_Font:22.0] string:@"¥"];
        self.expectedInterestMoneyLabel.text = [NSString AddCNY:self.totalDueIn];//总待收利息
        self.accountBalanceMoneyLabel.text = [NSString AddCNY:self.cashBalance];//余额
        
        if (myModel.data.unReadMsgCount > 0) {
            [self.messageImageBtn setImage:[UIImage imageNamed:@"MineUNMessageicon"] forState:UIControlStateNormal];
        }
        else
        {
            [self.messageImageBtn setImage:[UIImage imageNamed:@"MineMessageicon"] forState:UIControlStateNormal];
        }
        if ([myModel.data.memberLever integerValue] <= 1)
        {
            [self.memberLeverBtn setTitle:@"普通会员" forState:UIControlStateNormal];
        }
        else
        {
            [self.memberLeverBtn setImage:[UIImage imageNamed:@"icon_vip"] forState:UIControlStateNormal];
            [self.memberLeverBtn setTitle:[NSString stringWithFormat:@"VIP%ld",(long)[myModel.data.memberLever integerValue] - 1] forState:UIControlStateNormal];
            CGFloat gap = 10.f;
            self.memberLeverBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -gap / 2 +5 , 0, gap / 2);
            self.memberLeverBtn.titleEdgeInsets = UIEdgeInsetsMake(0, gap / 2, 0 ,  gap / 2 );
            self.memberLeverBtn.contentEdgeInsets = UIEdgeInsetsMake(0, gap / 2, 0, gap / 2);
        }
        if (self.amountShownBtn.selected) {
            [self hiddenMoney:self.amountShownBtn.selected];
        }
    }
    [self.totalAssetsMoneyLabel sizeToFit];
    [self.expectedInterestMoneyLabel sizeToFit];
    [self.accountBalanceMoneyLabel sizeToFit];
    
}

//- (void)showMySimple:(UCFMineMySimpleInfoModel *__nonnull)myModel
//{
//    if (myModel != nil && [myModel isKindOfClass:[UCFMineMySimpleInfoModel class]])
//    {
//
//        if (myModel.data.unReadMsgCount > 0) {
//             [self.messageImageBtn setImage:[UIImage imageNamed:@"MineUNMessageicon"] forState:UIControlStateNormal];
//        }
//        else
//        {
//            [self.messageImageBtn setImage:[UIImage imageNamed:@"MineMessageicon"] forState:UIControlStateNormal];
//        }
//        if ([myModel.data.memberLever integerValue] <= 1)
//        {
//            [self.memberLeverBtn setTitle:@"普通会员" forState:UIControlStateNormal];
//        }
//        else
//        {
////            self.memberLeverBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//            [self.memberLeverBtn setImage:[UIImage imageNamed:@"icon_vip"] forState:UIControlStateNormal];
//            [self.memberLeverBtn setTitle:[NSString stringWithFormat:@"VIP%ld",(long)[myModel.data.memberLever integerValue] - 1] forState:UIControlStateNormal];
////            typedef struct UIEdgeInsets {
////                CGFloat top, left, bottom, right;  // specify amount to inset (positive) for each of the edges. values can be negative to 'outset'
////            } UIEdgeInsets
//
//            CGFloat gap = 10.f;
//            self.memberLeverBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -gap / 2 +5 , 0, gap / 2);
//            self.memberLeverBtn.titleEdgeInsets = UIEdgeInsetsMake(0, gap / 2, 0 ,  gap / 2 );
//            self.memberLeverBtn.contentEdgeInsets = UIEdgeInsetsMake(0, gap / 2, 0, gap / 2);
//        }
//    }
//    else
//    {
//        [self.memberLeverBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [self.memberLeverBtn setTitle:@"" forState:UIControlStateNormal];
//        [self.messageImageBtn setImage:[UIImage imageNamed:@"MineMessageicon"] forState:UIControlStateNormal];
//    }
//}

- (void)removeHeadViewUserData
{
//    [self showMySimple:nil];
    [self showMyReceipt:nil];
}
- (void)hiddenMoney:(BOOL )isHiddenMoney
{
    if (isHiddenMoney) {
        self.totalAssetsMoneyLabel.text = @"****";//总资产
        self.expectedInterestMoneyLabel.text = @"****";//总待收利息
        self.accountBalanceMoneyLabel.text = @"****";//余额
        [self.amountShownBtn setImage:[UIImage imageNamed:@"mine_icon_invisible"] forState:UIControlStateNormal];
    }
    else
    {
        self.totalAssetsMoneyLabel.text = self.total;//总资产
        self.expectedInterestMoneyLabel.text = self.totalDueIn;//总待收利息
        self.accountBalanceMoneyLabel.text = self.cashBalance;//余额
        
        self.totalAssetsMoneyLabel.text =  [NSString AddCNY:self.total];//总资产
        [self.totalAssetsMoneyLabel setFont:[Color gc_Font:22.0] string:@"¥"];
        self.expectedInterestMoneyLabel.text = [NSString AddCNY:self.totalDueIn];//总待收利息
        self.accountBalanceMoneyLabel.text = [NSString AddCNY:self.cashBalance];//余额
    
        [self.amountShownBtn setImage:[UIImage imageNamed:@"MineShowCapital.png"] forState:UIControlStateNormal];
    }
    
    [self.totalAssetsMoneyLabel sizeToFit];
    [self.expectedInterestMoneyLabel sizeToFit];
    [self.accountBalanceMoneyLabel sizeToFit];
}
@end
