//
//  UCFMineNewSignApi.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMineNewSignApi : BaseRequest
- (id)initWithApptzticket:(NSString *)token;
@end

NS_ASSUME_NONNULL_END
