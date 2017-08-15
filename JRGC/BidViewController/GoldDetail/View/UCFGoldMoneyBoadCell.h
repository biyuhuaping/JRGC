//
//  UCFGoldMoneyBoadCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFGoldModel.h"
@protocol UCFGoldMoneyBoadCellDelegate <NSObject>

@optional

-(void)showGoldCalculatorView;
-(void)gotoGoldRechargeVC;
-(void)clickAllInvestmentBtn;
-(void)clickGoldSwitch:(UISwitch *)goldSwitch;

@end

@interface UCFGoldMoneyBoadCell : UITableViewCell

@property (strong ,nonatomic) NSDictionary *dataDict;
@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
@property (strong, nonatomic) IBOutlet UILabel *availableAllMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *estimatAmountPayableLabel;
@property (strong, nonatomic) IBOutlet UILabel *getUpWeightGoldLabel;

@property (strong, nonatomic) IBOutlet UILabel *availableMoneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountBeanLabel;
@property (nonatomic, assign)id<UCFGoldMoneyBoadCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UISwitch *goldSwitch;
@property (nonatomic,assign)BOOL isGoldCurrentAccout;//是否是活期的标
@property (nonatomic,strong)UCFGoldModel *goldModel;


@end
