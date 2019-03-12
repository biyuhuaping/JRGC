//
//  UCFRegisterUserBaseMessVerifCodeModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "UCFRegisterGetRegisterInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFRegisterUserBaseMessVerifCodeModel : BaseModel

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) UCFRegisterGetRegisterInfoData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;

@end

NS_ASSUME_NONNULL_END
