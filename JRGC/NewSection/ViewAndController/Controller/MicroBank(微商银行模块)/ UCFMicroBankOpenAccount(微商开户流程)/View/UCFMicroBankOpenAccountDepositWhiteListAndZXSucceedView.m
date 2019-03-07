//
//  UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/7.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView.h"
#import "NZLabel.h"
@interface UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView ()

@property (nonatomic, strong) NZLabel *succeedTitleLabel;

@property (nonatomic, strong) NZLabel *succeedContentLabel;

@property (nonatomic, strong) UIImageView *bkImageView;

@end
@implementation UCFMicroBankOpenAccountDepositWhiteListAndZXSucceedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [self.rootLayout addSubview:self.succeedContentLabel];
        [self.rootLayout addSubview:self.succeedTitleLabel];
        [self.rootLayout addSubview:self.bkImageView];
        [self.rootLayout addSubview:self.settingTransactionPasswordButton];
    }
    return self;
}

- (NZLabel *)succeedContentLabel
{
    if (nil == _succeedContentLabel) {
        _succeedContentLabel = [NZLabel new];
        _succeedContentLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _succeedContentLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _succeedContentLabel.textAlignment = NSTextAlignmentCenter;
        _succeedContentLabel.font = [Color gc_Font:13.0];
        _succeedContentLabel.textColor = [Color color:PGColorOptionTitleGray];
        _succeedContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _succeedContentLabel.numberOfLines = 0;
        _succeedContentLabel.text = @"交易密码用于投标、提现等操作，为了您的\n账户安全，资金操作前请先设置交易密码。";
        [_succeedContentLabel sizeToFit];
        
    }
    return _succeedContentLabel;
}

- (NZLabel *)succeedTitleLabel
{
    if (nil == _succeedTitleLabel) {
        _succeedTitleLabel = [NZLabel new];
        _succeedTitleLabel.bottomPos.equalTo(self.succeedContentLabel.topPos).offset(10);
        _succeedTitleLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _succeedTitleLabel.myLeft = 0;
        _succeedTitleLabel.myRight = 0;
        _succeedTitleLabel.textAlignment = NSTextAlignmentCenter;
        _succeedTitleLabel.font = [Color gc_Font:20.0];
        _succeedTitleLabel.textColor = [Color color:PGColorOptionCellContentBlue];
        _succeedTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _succeedTitleLabel.numberOfLines = 0;
//        _succeedTitleLabel.text = @"成功开通 \n 微金徽商存管账户";
        [_succeedTitleLabel sizeToFit];
        
    }
    return _succeedTitleLabel;
}

- (UIImageView *)bkImageView
{
    if (nil == _bkImageView) {
        _bkImageView = [[UIImageView alloc] init];
        _bkImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _bkImageView.bottomPos.equalTo(self.succeedTitleLabel.topPos).offset(20);
        _bkImageView.myWidth = 220;
        _bkImageView.myHeight = 99;
        _bkImageView.image = [UIImage imageNamed:@"account_successful_img"];
    }
    return _bkImageView;
}

- (UIButton*)settingTransactionPasswordButton
{
    
    if(nil == _settingTransactionPasswordButton)
    {
        _settingTransactionPasswordButton = [UIButton buttonWithType:0];
        _settingTransactionPasswordButton.topPos.equalTo(self.succeedContentLabel.bottomPos).offset(30);
        _settingTransactionPasswordButton.rightPos.equalTo(@25);
        _settingTransactionPasswordButton.leftPos.equalTo(@25);
        _settingTransactionPasswordButton.heightSize.equalTo(@37);
        [_settingTransactionPasswordButton setTitle:@"设置交易密码" forState:UIControlStateNormal];
        _settingTransactionPasswordButton.titleLabel.font= [Color gc_Font:15.0];
        [_settingTransactionPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_settingTransactionPasswordButton setBackgroundColor:[Color color:PGColorOptionTitlerRead]];
        _settingTransactionPasswordButton.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 2;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _settingTransactionPasswordButton;
}

- (void)setUserSelectAccoutType:(SelectAccoutType)accoutType
{
    if ([UserInfoSingle sharedManager].superviseSwitch) {
        if (SingleUserInfo.loginData.userInfo.zxIsNew) {
            self.succeedTitleLabel.text = @"成功开通\n徽商银行存管账户";
        } else {
            self.succeedTitleLabel.text = @"成功开通\n微金徽商存管账户";
        }
    } else {
        self.succeedTitleLabel.text = accoutType == SelectAccoutTypeP2P ? @"成功开通\n微金徽商存管账户":@"成功开通\n尊享徽商存管账户";
    }
    
    [self.succeedTitleLabel sizeToFit];
}
@end
