//
//  UCFCashWithdrawalRequest.m
//  JRGC
//
//  Created by zrc on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCashWithdrawalRequest.h"

@interface UCFCashWithdrawalRequest ()
@property(nonatomic, strong)NSDictionary      *parameterDict;
@end

@implementation UCFCashWithdrawalRequest


- (id)initWithParameterdict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.parameterDict = dict;
    }
    return self;
}

/**
 *  @author KZ, 17-09-11 20:09:12
 *
 *  请求的借口
 *
 *  @return 返回需要请求的借口的URI
 */
- (NSString *)requestUrl {
    return AccountCashWithDrawalApiURL;
}
/**
 *  @author KZ, 17-09-11 20:09:28
 *
 *  返回请求的参数
 *
 *  @return 封装好的参数
 */
- (id)requestArgument {

    return self.parameterDict;
}
@end
