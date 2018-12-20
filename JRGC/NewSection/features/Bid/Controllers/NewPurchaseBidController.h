//
//  NewPurchaseBidController.h
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFBidModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewPurchaseBidController : UCFBaseViewController
@property(nonatomic, strong)UCFBidModel *bidDetaiModel;
- (void)reflectAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END
