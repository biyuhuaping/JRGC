//
//  UCFUserStatusInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFUserStatusInfoData,UCFUserStatusInfoUsersatus;
NS_ASSUME_NONNULL_BEGIN

@interface UCFUserStatusInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFUserStatusInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFUserStatusInfoData : BaseModel

@property (nonatomic, strong) UCFUserStatusInfoUsersatus *userSatus;

@end

@interface UCFUserStatusInfoUsersatus : BaseModel

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) BOOL isNew;

@property (nonatomic, assign) NSInteger isRisk;

@property (nonatomic, assign) NSInteger isAutoBid;

@property (nonatomic, assign) NSInteger openStatus;

@property (nonatomic, assign) BOOL nmGoldAuthStatus;

@property (nonatomic, assign) BOOL company;

@property (nonatomic, assign) NSInteger batchMaxmum;

@property (nonatomic, assign) NSInteger zxOpenStatus;

@property (nonatomic, assign) BOOL zxAuthorization;

@end

NS_ASSUME_NONNULL_END
