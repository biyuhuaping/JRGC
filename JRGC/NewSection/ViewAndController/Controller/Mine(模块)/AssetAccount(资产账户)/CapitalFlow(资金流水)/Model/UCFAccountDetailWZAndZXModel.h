//
//  UCFAccountDetailWZAndZXModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/9.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFAccountDetailWZAndZXPagedata,UCFAccountDetailWZAndZXPagination,UCFAccountDetailWZAndZXResult;
NS_ASSUME_NONNULL_BEGIN

@interface UCFAccountDetailWZAndZXModel : BaseModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) UCFAccountDetailWZAndZXPagedata *pageData;

@end
@interface UCFAccountDetailWZAndZXPagedata : BaseModel

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) UCFAccountDetailWZAndZXPagination *pagination;

@end

@interface UCFAccountDetailWZAndZXPagination : BaseModel

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

@interface UCFAccountDetailWZAndZXResult : BaseModel

@property (nonatomic, copy) NSString *frozen;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *yearMonth;

@property (nonatomic, copy) NSString *waterTypeName;

@property (nonatomic, copy) NSString *cashValue;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *actType;

@end

NS_ASSUME_NONNULL_END
