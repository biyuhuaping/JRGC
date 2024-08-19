//
//  UCFGoldCouponViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/8/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//
@protocol UCFGoldCouponViewControllerDelegate <NSObject>

-(void)getSelectedGoldCouponNum:(NSDictionary *)goldCouponDict;

@end
#import "UCFBaseViewController.h"
@interface UCFGoldCouponViewController : UCFBaseViewController
@property (nonatomic,strong)NSString *nmPrdClaimIdStr;//黄金标id
@property (nonatomic,strong)NSString *remainAmountStr;//黄金标可购克重
@property (nonatomic,strong)NSDictionary  *selectGoldCouponDict;
@property (nonatomic,assign)id<UCFGoldCouponViewControllerDelegate> delegate;
@end
