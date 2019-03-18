//
//  BasePageDataModel.h
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "BasePagination.h"
NS_ASSUME_NONNULL_BEGIN

@interface BasePageDataModel : BaseModel

@property (nonatomic, copy)   NSString  *className;

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) BasePagination *pagination;

@end

NS_ASSUME_NONNULL_END
