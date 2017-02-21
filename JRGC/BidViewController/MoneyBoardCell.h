//
//  MoneyBoardCell.h
//  JRGC
//
//  Created by 金融工场 on 15/4/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//
@protocol MoneyBoardCellDelegate <NSObject>

- (void)changeGongDouSwitchStatue:(UISwitch *)sender;

- (void)allInvestOrGotoPay:(NSInteger)mark;

- (void)showCalutorView;

- (void)reloadSuperView:(UITextField *)textField;
@end
#import <UIKit/UIKit.h>

@interface MoneyBoardCell : UITableViewCell <UITextFieldDelegate>
@property (nonatomic, strong)UIView     *topView;
@property (nonatomic, strong)UIView     *keYongBaseView;
@property (nonatomic, strong)UILabel    *keYongTipLabel;
@property (nonatomic, strong)UILabel    *KeYongMoneyLabel;
@property (nonatomic, strong)UILabel    *totalKeYongTipLabel;
@property (nonatomic, strong)UIView     *inputBaseView;
@property (nonatomic, strong)UITextField    *inputMoneyTextFieldLable;
@property (nonatomic, strong)UIButton       *calulatorBtn;
@property (nonatomic, strong)UIView         *midSepView;
@property (nonatomic, strong)UILabel        *myMoneyAccountLabel;
@property (nonatomic, strong)UILabel        *myMoneyLabel;
@property (nonatomic, strong)UILabel        *gongDouAccout;
@property (nonatomic, strong)UILabel        *gongDouCountLabel;
@property (nonatomic, strong)UISwitch       *gongDouSwitch;
@property (nonatomic, strong)UIButton       *rechargeBtn;
@property (nonatomic, strong)UIButton       *allTouziBtn;
@property (nonatomic, assign)id<MoneyBoardCellDelegate> delegate;
@property (nonatomic, assign)BOOL isCompanyAgent; //是否为机构用户

@property (nonatomic, strong)NSDictionary   *dataDict;
@property (nonatomic, assign)BOOL           isTransid;
@property (nonatomic, assign)BOOL           isCollctionkeyBid;//是否是一键投资标 
@end
