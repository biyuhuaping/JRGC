//
//  UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/8.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "UCFMicroBankOpenAccountOpenAccountIntoBankInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface UCFMicroBankOpenAccountTradersPasswordSetHsPwdReturnJsonModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankOpenAccountOpenAccountIntoBankInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end


NS_ASSUME_NONNULL_END
