//
//  UCFWJSetAndRestHsPwdModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/21.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFWJSetAndRestHsPwdData,UCFWJSetAndRestHsPwdTradereq;
NS_ASSUME_NONNULL_BEGIN

@interface UCFWJSetAndRestHsPwdModel : BaseModel

@property (nonatomic, assign) CGFloat code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) CGFloat ver;

@property (nonatomic, strong) UCFWJSetAndRestHsPwdData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFWJSetAndRestHsPwdData : BaseModel

@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong) UCFWJSetAndRestHsPwdTradereq *tradeReq;

@end

@interface UCFWJSetAndRestHsPwdTradereq : BaseModel

@property (nonatomic, copy) NSString *SIGN;

@property (nonatomic, copy) NSString *PARAMS;

@end

NS_ASSUME_NONNULL_END
