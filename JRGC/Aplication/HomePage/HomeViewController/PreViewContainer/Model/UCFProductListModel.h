//
//  UCFProductListModel.h
//  JRGC
//
//  Created by hanqiyuan on 2017/5/5.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFProductListModel : NSObject
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productNum;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, copy) NSString *type;
+ (instancetype)productListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
