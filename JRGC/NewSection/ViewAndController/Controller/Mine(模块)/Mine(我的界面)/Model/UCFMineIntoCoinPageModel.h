//
//  UCFMineIntoCoinPageModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFMineIntoCoinPageData,UCFMineIntoCoinPageCoinrequest,UCFMineIntoCoinPageParam;

@interface UCFMineIntoCoinPageModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMineIntoCoinPageData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMineIntoCoinPageData : BaseModel

@property (nonatomic, strong) UCFMineIntoCoinPageCoinrequest *coinRequest;

@end

@interface UCFMineIntoCoinPageCoinrequest : BaseModel

@property (nonatomic, copy) NSString *urlPath;

@property (nonatomic, strong) UCFMineIntoCoinPageParam *param;

@end

@interface UCFMineIntoCoinPageParam : BaseModel

@property (nonatomic, assign) NSInteger fromApp;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *encryptParam;

@end

NS_ASSUME_NONNULL_END
