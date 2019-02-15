//
//  UCFRegistVerificationMobileModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFRegistVerificationMobileData;

@interface UCFRegistVerificationMobileModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) UCFRegistVerificationMobileData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, assign) BOOL ret;
@end

@interface UCFRegistVerificationMobileData : BaseModel

@end
NS_ASSUME_NONNULL_END
