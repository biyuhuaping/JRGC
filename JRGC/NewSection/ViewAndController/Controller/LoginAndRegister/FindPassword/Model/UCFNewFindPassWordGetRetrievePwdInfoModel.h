//
//  UCFNewFindPassWordGetRetrievePwdInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFNewFindPassWordGetRetrievePwdInfoData;

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewFindPassWordGetRetrievePwdInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFNewFindPassWordGetRetrievePwdInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFNewFindPassWordGetRetrievePwdInfoData : BaseModel

@end
NS_ASSUME_NONNULL_END
