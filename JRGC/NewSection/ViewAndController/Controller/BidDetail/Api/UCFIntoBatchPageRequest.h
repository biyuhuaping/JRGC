//
//  UCFIntoBatchPageRequest.h
//  JRGC
//
//  Created by zrc on 2019/3/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "UCFBatchPageRootModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFIntoBatchPageRequest : BaseRequest
- (instancetype)initWithTenderID:(NSString *)tenderId;
@end

NS_ASSUME_NONNULL_END
