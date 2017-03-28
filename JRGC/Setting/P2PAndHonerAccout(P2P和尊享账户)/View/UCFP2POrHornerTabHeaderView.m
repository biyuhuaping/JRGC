//
//  UCFP2POrHornerTabHeaderView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFP2POrHornerTabHeaderView.h"

@interface UCFP2POrHornerTabHeaderView ()
- (IBAction)CilckShowOrHideAccoutMoney:(UIButton *)sender;
- (IBAction)checkP2POrHonerAccout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *accountVisibleBtn;

@end

@implementation UCFP2POrHornerTabHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)CilckShowOrHideAccoutMoney:(UIButton *)sender {
    _isShowOrHideAccoutMoney = !_isShowOrHideAccoutMoney;
    if (_accoutTpye == SelectAccoutTypeHoner) { //尊享账户
        [[NSUserDefaults standardUserDefaults] setBool:_isShowOrHideAccoutMoney forKey:@"IsShowHonerAccoutMoney"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:_isShowOrHideAccoutMoney forKey:@"IsShowP2PAccoutMoney"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self setNeedsLayout];
}
- (IBAction)checkP2POrHonerAccout:(id)sender {
    [self.delegate checkP2POrHonerAccout];
}
-(void)setIsShowOrHideAccoutMoney:(BOOL)isShowOrHideAccoutMoney{
    _isShowOrHideAccoutMoney = isShowOrHideAccoutMoney;
    [self setNeedsLayout];
}
-(void)layoutSubviews{
    if (_accoutTpye == SelectAccoutTypeHoner) { //尊享账户
        
        if (!_isShowOrHideAccoutMoney){ //显示账户金额
            [self.accountVisibleBtn setImage:[UIImage imageNamed:@"account_invisible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text = @"¥0.00";//累计收益
            self.totalIncomeLab.text = @"¥0.00";//总资产
            self.availableAmountLab.text = @"¥0.00";//可用金额

        }else{//隐藏账户金额
            [self.accountVisibleBtn  setImage:[UIImage imageNamed:@"account_visible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text = @"***";//累计收益
            self.totalIncomeLab.text = @"***";//总资产
            self.availableAmountLab.text = @"***";//可用金额
        }
    }else{ //p2p账户
        if (!_isShowOrHideAccoutMoney){ //显示账户金额
            [self.accountVisibleBtn setImage:[UIImage imageNamed:@"account_invisible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text = @"¥0.00";//累计收益
            self.totalIncomeLab.text = @"¥0.00";//总资产
            self.availableAmountLab.text = @"¥0.00";//可用金额
            
        }else{//隐藏账户金额
            [self.accountVisibleBtn  setImage:[UIImage imageNamed:@"account_visible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text = @"***";//累计收益
            self.totalIncomeLab.text = @"***";//总资产
            self.availableAmountLab.text = @"***";//可用金额
            
        }
    }
}
@end
