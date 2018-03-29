//
//  UCFGoldBidSuccessViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFGoldBidSuccessViewController : UCFBaseViewController
@property (assign ,nonatomic) BOOL isPurchaseSuccess;//是否购买成功
@property(nonatomic ,strong) NSDictionary *dataDict;
@property (strong,nonatomic)NSString *errorMessageStr;
@end
