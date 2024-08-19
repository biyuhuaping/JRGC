//
//  NoticeCenterModel.h
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NoticeCenterModelData,NoticeCenterNoicepage,NoticePagination,NoticeResult;
@interface NoticeCenterModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) NoticeCenterModelData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface NoticeCenterModelData : NSObject

@property (nonatomic, strong) NoticeCenterNoicepage *pageData;

@end

@interface NoticeCenterNoicepage : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) NoticePagination *pagination;

@end

@interface NoticePagination : NSObject

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

@interface NoticeResult : NSObject

@property (nonatomic, copy) NSString *noviceUrl;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *sendTime;

@property (nonatomic, copy) NSString *summaryContent;

@end



NS_ASSUME_NONNULL_END
