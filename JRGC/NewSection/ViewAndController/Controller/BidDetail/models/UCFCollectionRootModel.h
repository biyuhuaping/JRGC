//
//  UCFCollectionRootModel.h
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
#import "BasePagination.h"
NS_ASSUME_NONNULL_BEGIN

@class UCFCollectionDataModel,UCFCollectionPagedataModel,UCFCollcetionResult;
@interface UCFCollectionRootModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFCollectionDataModel *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFCollectionDataModel : NSObject

@property (nonatomic, strong) UCFCollectionPagedataModel *pageData;

@end

@interface UCFCollectionPagedataModel : NSObject

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) BasePagination *pagination;

@end



@interface UCFCollcetionResult : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *childPrdClaimName;

@property (nonatomic, assign) NSInteger totalAmt;

@property (nonatomic, assign) CGFloat canBuyAmt;

@property (nonatomic, assign) NSInteger childPrdClaimId;

@property (nonatomic, assign) NSInteger isOrder;

@end

NS_ASSUME_NONNULL_END
