//
//  UCFQueryBannerByTypeModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "UCFHomeMallDataModel.h"
NS_ASSUME_NONNULL_BEGIN
@class UCFQueryBannerByTypeData;

@interface UCFQueryBannerByTypeModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFQueryBannerByTypeData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFQueryBannerByTypeData : BaseModel

@property (nonatomic, strong) NSArray *bannerList;

@end



NS_ASSUME_NONNULL_END
