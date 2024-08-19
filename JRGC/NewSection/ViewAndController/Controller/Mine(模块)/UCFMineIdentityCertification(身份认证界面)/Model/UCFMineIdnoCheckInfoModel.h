//
//  UCFMineIdnoCheckInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFMineIdnoCheckInfoData;
NS_ASSUME_NONNULL_BEGIN

@interface UCFMineIdnoCheckInfoModel : BaseModel

@property (nonatomic, assign) CGFloat code;

@property (nonatomic, strong) UCFMineIdnoCheckInfoData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMineIdnoCheckInfoData : BaseModel

@property (nonatomic, assign) CGFloat userId;

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, copy) NSString *codeName;

@property (nonatomic, copy) NSString *legalName;

@property (nonatomic, assign) BOOL isCompanyAgent;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *idno;

@property (nonatomic, copy) NSString *state;

@end

NS_ASSUME_NONNULL_END
