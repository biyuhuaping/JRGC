//
//  UCFTransPureBidApi.h
//  JRGC
//
//  Created by zrc on 2019/2/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFTransPureBidApi : BaseRequest
- (id)initWithApptzticket:(NSString *)apptzticket prdTransferId:(NSString *)prdTransferId InvestAmt:(NSString *)investAmt;
@end

NS_ASSUME_NONNULL_END
