//
//  UCFBankCard.h
//  JRGC
//
//  Created by NJW on 15/5/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFBankCard : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bankCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *quickPayImageView;//***快捷支付图片
@property (weak, nonatomic) IBOutlet UIImageView *image_bankCardValuable;//***银行卡失效图片
//***当银行卡失效的时候页面部分至灰色
-(void)thisBankCardInvaluable:(BOOL)_gray;
@end
