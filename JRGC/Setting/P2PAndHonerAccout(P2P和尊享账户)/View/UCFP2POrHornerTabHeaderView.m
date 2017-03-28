//
//  UCFP2POrHornerTabHeaderView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFP2POrHornerTabHeaderView.h"
#import "UIDic+Safe.h"
@interface UCFP2POrHornerTabHeaderView ()
{
    NSString *cashBalanceStr;
    NSString *interestsStr;
    NSString *totalStr;
}
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
    [self checkData];
}
- (IBAction)checkP2POrHonerAccout:(id)sender {
    [self.delegate checkP2POrHonerAccout];
}
-(void)setIsShowOrHideAccoutMoney:(BOOL)isShowOrHideAccoutMoney{
    _isShowOrHideAccoutMoney = isShowOrHideAccoutMoney;
    [self checkData];
}
-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    [self checkData];
}
-(void)layoutSubviews{
    [self dataDict];
}
-(void)checkData{
    if (_dataDict == nil) {
        if (!_isShowOrHideAccoutMoney){ //显示账户金额
            [self.accountVisibleBtn setImage:[UIImage imageNamed:@"account_invisible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text =  @"¥0.00";//累计收益
            self.totalIncomeLab.text = @"¥0.00";//总资产
            self.availableAmountLab.text = @"¥0.00";//可用金额
        }else{
            [self.accountVisibleBtn  setImage:[UIImage imageNamed:@"account_visible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text = @"****";//累计收益
            self.totalIncomeLab.text = @"****";//总资产
            self.availableAmountLab.text = @"****";//可用金额
        }
        return;
    }
    cashBalanceStr = [NSString stringWithFormat:@"¥%@",[self.dataDict objectSafeForKey:@"cashBalance"]];//可用金额
    interestsStr = [NSString stringWithFormat:@"¥%@",[self.dataDict  objectSafeForKey:@"interests"]];//累计收益
    totalStr = [NSString stringWithFormat:@"¥%@",[self.dataDict  objectSafeForKey:@"total"]];//累计收益
    if (!_isShowOrHideAccoutMoney){ //显示账户金额
        [self.accountVisibleBtn setImage:[UIImage imageNamed:@"account_invisible"] forState:UIControlStateNormal];
        self.accumulatedIncomeLab.text =  [self checkNullStr:interestsStr];//累计收益
        self.totalIncomeLab.text = [self checkNullStr:totalStr];//总资产
        self.availableAmountLab.text = [self checkNullStr:cashBalanceStr];//可用金额
    }else{//隐藏账户金额
        [self.accountVisibleBtn  setImage:[UIImage imageNamed:@"account_visible"] forState:UIControlStateNormal];
        self.accumulatedIncomeLab.text = @"****";//累计收益
        self.totalIncomeLab.text = @"****";//总资产
        self.availableAmountLab.text = @"****";//可用金额
    }
}
-(NSString *)checkNullStr:(NSString *)nullStr
{
    nullStr = [nullStr substringFromIndex:1];
    if ([nullStr isKindOfClass:[NSNull class]]|| nullStr==nil || [nullStr isEqualToString:@""] || [nullStr floatValue] == 0) {
        return @"¥0.00";
    }else{
        return nullStr;
    }
}
@end
