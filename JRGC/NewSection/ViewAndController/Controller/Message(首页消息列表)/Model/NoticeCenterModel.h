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

@property (nonatomic, assign) CGFloat code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) CGFloat ver;

@property (nonatomic, strong) NoticeCenterModelData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface NoticeCenterModelData : NSObject

@property (nonatomic, strong) NoticeCenterNoicepage *noicePage;

@end

@interface NoticeCenterNoicepage : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) NoticePagination *pagination;

@end

@interface NoticePagination : NSObject

@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, assign) CGFloat totalCount;

@property (nonatomic, assign) CGFloat totalPage;

@property (nonatomic, assign) BOOL hasPrev5Page;

@property (nonatomic, assign) CGFloat prevPage;

@property (nonatomic, assign) CGFloat nextPage;

@property (nonatomic, assign) CGFloat currentlyPageFirstResoultIndex;

@property (nonatomic, assign) BOOL readTotalCount;

@property (nonatomic, assign) BOOL hasPrevPage;

@property (nonatomic, assign) BOOL hasNext5Page;

@property (nonatomic, assign) CGFloat pageNo;

@property (nonatomic, assign) CGFloat pageSize;

@end

@interface NoticeResult : NSObject

@property (nonatomic, copy) NSString *noviceUrl;

@property (nonatomic, assign) CGFloat ID;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *sendTime;

@property (nonatomic, copy) NSString *summaryContent;

@end



NS_ASSUME_NONNULL_END
