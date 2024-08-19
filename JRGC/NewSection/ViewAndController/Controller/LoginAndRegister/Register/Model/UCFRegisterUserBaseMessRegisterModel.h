//
//  UCFRegisterUserBaseMessRegisterModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "UCFLoginModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFRegisterUserBaseMessRegisterModel : BaseModel
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) UCFLoginData *data;

@property (nonatomic, assign) BOOL ret;

@property (nonatomic, assign) NSInteger ver;

@end

NS_ASSUME_NONNULL_END
