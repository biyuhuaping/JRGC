//
//  UCFMicroBankOpenAccountChangeBankCardInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/5.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class
UCFMicroBankOpenAccountChangeBankCardInfoData;
NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountChangeBankCardInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankOpenAccountChangeBankCardInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end


@interface UCFMicroBankOpenAccountChangeBankCardInfoData : BaseModel

@end

NS_ASSUME_NONNULL_END
