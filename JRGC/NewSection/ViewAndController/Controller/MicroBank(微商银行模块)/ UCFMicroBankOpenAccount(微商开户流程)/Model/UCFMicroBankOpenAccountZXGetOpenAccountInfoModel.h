//
//  UCFMicroBankOpenAccountZXGetOpenAccountInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class
UCFMicroBankOpenAccountZXGetOpenAccountInfoData;
NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountZXGetOpenAccountInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankOpenAccountZXGetOpenAccountInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end

@interface UCFMicroBankOpenAccountZXGetOpenAccountInfoData : BaseModel

@end
NS_ASSUME_NONNULL_END
