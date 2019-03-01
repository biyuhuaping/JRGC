//
//  UCFCellDataModel.h
//  JRGC
//
//  Created by zrc on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UCFCellDataModel : NSObject
@property(nonatomic, copy)NSString *modelType;

@property(nonatomic, strong)id  data1;

@property(nonatomic, strong)id  data2;

@end

NS_ASSUME_NONNULL_END
