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
@end

@interface UCFP2POrHornerTabHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *accumulatedIncomeLab;//累计收益
@property (strong, nonatomic) IBOutlet UILabel *totalIncomeLab;//累计收益
@property (strong, nonatomic) IBOutlet UILabel *totalIncomeTitleLab;//累计收益标题
@property (strong, nonatomic) IBOutlet UILabel *availableAmountLab;//累计收益
@property (strong, nonatomic) IBOutlet UIView *upView;//上面的view
@property (strong, nonatomic) IBOutlet UIView *downView;//下面的view


@property (assign,nonatomic) SelectAccoutType accoutTpye;
@property (assign,nonatomic) BOOL isShowOrHideAccoutMoney;

@property (strong,nonatomic) NSDictionary *dataDict;
;
@property (nonatomic,assign) id<UCFP2POrHornerTabHeaderViewDelete> delegate;
@end
