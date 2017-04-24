//
//  CalculatorView.h
//  JRGC
//
//  Created by 金融工场 on 15/5/18.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkModule.h"

@interface CalculatorView : UIView<UITextFieldDelegate,NetworkModuleDelegate>
{
    UILabel *totalMoneyLabel;
    UILabel *preGetMoneyLabel;
    UILabel *bankGetMoneyLabel;
    UITextField *moneyTextField;
    UILabel *minLabel;
    UILabel *maxLabel;
    UISlider *slider;
    double   maxValue;
    NSString *tempFloatValue;
}
@property(nonatomic, assign)BOOL isTransid;
@property(nonatomic,copy)   NSString *annleRate;
@property(nonatomic,copy)   NSString *repayPeriodDay;
@property(nonatomic,copy)   NSString *bankBaseRate;
@property(nonatomic,assign) double    normalMinInvest;
@property(nonatomic,strong) NSDictionary *tranBidDataDict;
@property(nonatomic,assign) SelectAccoutType accoutType;
- (void)reloadViewWithData:(NSDictionary *)dataDict AndNowMoney:(NSString *)currentMoney;
- (void)reloadViewWithData:(NSDictionary *)dataDict AndNowMoney:(NSString *)currentMoney AndPreMoney:(NSString *)preMoney BankMoney:(NSString *)bankMoney;
- (void)reloadViewWithData:(NSDictionary *)dataDict AndNowMoney:(NSString *)currentMoney AndChildPrdClaimId:(NSString *)childPrdClaimId;
@end
