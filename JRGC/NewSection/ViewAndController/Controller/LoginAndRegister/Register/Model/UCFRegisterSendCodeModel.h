//
//  UCFRegisterSendCodeModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/23.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFRegisterSendCodeData;

@interface UCFRegisterSendCodeModel : BaseModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) UCFRegisterSendCodeData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;

@end

@interface UCFRegisterSendCodeData : BaseModel

@end
NS_ASSUME_NONNULL_END
