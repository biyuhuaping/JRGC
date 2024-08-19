//
//  UCFCollectRootModel.h
//  JRGC
//
//  Created by zrc on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class UCFCollectionIDModel;
@interface UCFCollectRootModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFCollectionIDModel *data;

@property (nonatomic, assign) BOOL ret;

@end

@interface UCFCollectionIDModel : BaseModel

@property (nonatomic, strong) NSArray *orderIds;

@property (nonatomic, assign) CGFloat investAmount;

@property (nonatomic, assign) CGFloat applyAmount;

@end

NS_ASSUME_NONNULL_END
