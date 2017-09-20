//
//  UCFRechargeAndCashView.h
//  JRGC
//
//  Created by hanqiyuan on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFAccoutCardModel.h"
@class UCFRechargeAndCashView;
@protocol UCFRechargeAndCashViewDelegate <NSObject>

-(void)clickRechargeAndCashView:(UCFRechargeAndCashView *)cardView WithTag:(NSInteger)tag  WithModel:(UCFAccoutCardModel *)cardModel;

@end

@interface UCFRechargeAndCashView : UIView
@property (strong, nonatomic) IBOutlet UILabel *cardtitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cardBgImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cardLogoImage;
@property (strong, nonatomic) IBOutlet UILabel *cardDetialLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardStateLabel;
@property (strong, nonatomic) UCFAccoutCardModel *accoutCardModel;
@property (assign, nonatomic) id<UCFRechargeAndCashViewDelegate> delegate;
@end
