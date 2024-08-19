//
//  UCFCalulatorModel.h
//  JRGC
//
//  Created by zrc on 2019/4/12.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFCalulatorModel : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *taotalIntrest;

@property (nonatomic, copy) NSString *transferDes;

@property (nonatomic, copy) NSString *bankBaseIntrest;

@property (nonatomic, assign) NSInteger extraBeanCount;

@property (nonatomic, copy) NSString *statusdes;

@end

NS_ASSUME_NONNULL_END
