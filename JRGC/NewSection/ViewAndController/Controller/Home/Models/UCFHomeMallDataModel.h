//
//  UCFHomeMallDataModel.h
//  JRGC
//
//  Created by zrc on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFMallDataModel,UCFHomeMalldiscounts,UCFHomeMallrecommends,UCFhomeMallbannerlist;
@interface UCFHomeMallDataModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMallDataModel *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMallDataModel : BaseModel

@property (nonatomic, strong) NSArray *mallDiscounts;

@property (nonatomic, strong) NSArray *mallRecommends;

@property (nonatomic, strong) NSArray *mallBannerList;

@end

@interface UCFHomeMalldiscounts : BaseModel

@property (nonatomic, copy) NSString *bizUrl;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *sales;

@property (nonatomic, copy) NSString *bizNo;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tags;

@property (nonatomic, copy) NSString *pid;

@end

@interface UCFHomeMallrecommends : BaseModel

@property (nonatomic, copy) NSString *bizUrl;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *sales;

@property (nonatomic, copy) NSString *bizNo;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *tags;

@property (nonatomic, copy) NSString *pid;

@end

@interface UCFhomeMallbannerlist : BaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *activityType;

@property (nonatomic, copy) NSString *switchFlag;

@end

NS_ASSUME_NONNULL_END
