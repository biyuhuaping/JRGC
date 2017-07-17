//
//  UCFGoldMoneyBoadCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFGoldMoneyBoadCellDelegate <NSObject>

@optional

-(void)showGoldCalculatorView;
-(void)gotoGoldRechargeVC;
-(void)clickAllInvestmentBtn;

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

@end
