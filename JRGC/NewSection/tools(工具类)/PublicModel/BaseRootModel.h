//
//  BaseRootModel.h
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePageDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseRootModel : BaseModel
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) BasePageDataModel *data;

@property (nonatomic, assign) BOOL ret;
@end

NS_ASSUME_NONNULL_END
