//
//  UCFRechargeAndWithdrawalAccountBalancePageModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFRechargeAndWithdrawalAccountBalancePageData;
NS_ASSUME_NONNULL_BEGIN

@interface UCFRechargeAndWithdrawalAccountBalancePageModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFRechargeAndWithdrawalAccountBalancePageData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFRechargeAndWithdrawalAccountBalancePageData : BaseModel

@property (nonatomic, assign) BOOL zxIsShow;//尊享模块是否展示

@property (nonatomic, assign) NSInteger wjOpenStatus;//微金开户状态

@property (nonatomic, assign) CGFloat zxBalance;//尊享账户可用额度

@property (nonatomic, assign) CGFloat goldBalance;//黄金账户余额

@property (nonatomic, assign) CGFloat p2pBalance;//微金账户余额

@property (nonatomic, assign) BOOL nmIsShow;//黄金模块是否展示

@property (nonatomic, assign) BOOL wjIsShow;//微金模块是否展示

@end


NS_ASSUME_NONNULL_END
