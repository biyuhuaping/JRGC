//
//  BasePagination.h
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePagination : BaseModel
@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, assign) NSInteger totalCount;

@property (nonatomic, assign) NSInteger totalPage;

@property (nonatomic, assign) BOOL hasPrev5Page;

@property (nonatomic, assign) NSInteger prevPage;

@property (nonatomic, assign) NSInteger nextPage;

@property (nonatomic, assign) NSInteger currentlyPageFirstResoultIndex;

@property (nonatomic, assign) BOOL readTotalCount;

@property (nonatomic, assign) BOOL hasPrevPage;

@property (nonatomic, assign) BOOL hasNext5Page;

@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, assign) NSInteger pageSize;
@end

NS_ASSUME_NONNULL_END
