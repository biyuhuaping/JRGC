//
//  UCFTransCalculatorRequest.h
//  JRGC
//
//  Created by zrc on 2019/4/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "UCFCalulatorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFTransCalculatorRequest : BaseRequest
- (instancetype)initWithParmDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
