//
//  UCFRegisterGetRegisterInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFRegisterGetRegisterInfoData;
@interface UCFRegisterGetRegisterInfoModel : BaseModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) UCFRegisterGetRegisterInfoData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFRegisterGetRegisterInfoData : BaseModel

@property (nonatomic, copy) NSString *registTicket;

@end

NS_ASSUME_NONNULL_END
