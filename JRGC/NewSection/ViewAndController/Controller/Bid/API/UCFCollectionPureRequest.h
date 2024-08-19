//
//  UCFCollectionPureRequest.h
//  JRGC
//
//  Created by zrc on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseRequest.h"
#import "UCFCollectRootModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFCollectionPureRequest : BaseRequest
- (instancetype)initWithParmDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
