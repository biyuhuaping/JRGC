//
//  UCFP2POrHornerTabHeaderView.h
//  JRGC
//
//  Created by hanqiyuan on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFP2POrHornerTabHeaderViewDelete <NSObject>

@optional 
- (void)checkP2POrHonerAccout;
- (void)changeP2POrHonerAccoutMoneyAlertView;
- (void)gotoHonerCashActivityView;
@end

@interface UCFP2POrHornerTabHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *accumulatedIncomeLab;//累计收益
@property (strong, nonatomic) IBOutlet UILabel *totalIncomeLab;//累计收益
@property (strong, nonatomic) IBOutlet UILabel *totalIncomeTitleLab;//累计收益标题
@property (strong, nonatomic) IBOutlet UILabel *availableAmountLab;//累计收益
@property (strong, nonatomic) IBOutlet UIView *upView;//上面的view
@property (strong, nonatomic) IBOutlet UIView *downView;//下面的view

@property (weak, nonatomic) IBOutlet UILabel *allGetInterLab;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aboutLabelRight;//了解一下 右边距离的高度
@property (strong, nonatomic) IBOutlet UIView *honerCashTipView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *honerCashTipViewHight;//开户行view
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *honerCashTipViewLeft;//开户行view

@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
- (IBAction)clickHonerCashActivityVC:(id)sender;

@property (assign,nonatomic) SelectAccoutType accoutTpye;
@property (assign,nonatomic) BOOL isShowOrHideAccoutMoney;

@property (strong,nonatomic) NSDictionary *dataDict;
;
@property (nonatomic,assign) id<UCFP2POrHornerTabHeaderViewDelete> delegate;
@end
