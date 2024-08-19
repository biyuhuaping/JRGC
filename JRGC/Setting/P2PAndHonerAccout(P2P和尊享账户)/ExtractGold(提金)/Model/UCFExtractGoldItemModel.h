//
//  UCFExtractGoldItemModel.h
//  JRGC
//
//  Created by njw on 2017/11/9.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFExtractGoldItemModel : NSObject
@property (strong, nonatomic) NSNumber *takeOrderId;
@property (strong, nonatomic) NSNumber *goldGoodsId;
@property (copy, nonatomic) NSString *goldGoodsName;
@property (strong, nonatomic) NSNumber *goldGoodsNum;
@property (copy, nonatomic) NSString *remark;

+ (instancetype)extractGoldItemWithDict:(NSDictionary *)dict;
@end
