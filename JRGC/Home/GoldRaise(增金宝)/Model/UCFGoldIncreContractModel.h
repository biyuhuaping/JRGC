//
//  UCFGoldIncreContractModel.h
//  JRGC
//
//  Created by njw on 2017/8/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldIncreContractModel : NSObject
@property (nonatomic, copy) NSString *contractName;
@property (nonatomic, copy) NSString *contractType;
@property (nonatomic, copy) NSString *orderId;

+ (instancetype)goldIncreseContractModelWithDict:(NSDictionary *)dict;
@end
