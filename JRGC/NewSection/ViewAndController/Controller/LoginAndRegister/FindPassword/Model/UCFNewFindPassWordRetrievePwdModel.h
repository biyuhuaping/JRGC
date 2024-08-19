//
//  UCFNewFindPassWordRetrievePwdModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFNewFindPassWordRetrievePwdData;
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewFindPassWordRetrievePwdModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFNewFindPassWordRetrievePwdData *data;

@property (nonatomic, assign) BOOL ret;
@end

@interface UCFNewFindPassWordRetrievePwdData : BaseModel

@end
NS_ASSUME_NONNULL_END
