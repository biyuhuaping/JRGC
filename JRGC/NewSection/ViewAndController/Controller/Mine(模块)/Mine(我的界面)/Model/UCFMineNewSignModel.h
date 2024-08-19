//
//  UCFMineNewSignModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFMineNewSignData;

@interface UCFMineNewSignModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) UCFMineNewSignData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMineNewSignData : BaseModel

@property (nonatomic, copy) NSString *isOpen;

@property (nonatomic, copy) NSString *nextDayBeans;

@property (nonatomic, copy) NSString *totalCanUseScore;

@property (nonatomic, copy) NSString *signDays;

@property (nonatomic, assign) BOOL win;

@property (nonatomic, copy) NSString *winAmount;

@property (nonatomic, copy) NSString *returnAmount;

@property (nonatomic, copy) NSString *rewardAmt;

@end
NS_ASSUME_NONNULL_END
