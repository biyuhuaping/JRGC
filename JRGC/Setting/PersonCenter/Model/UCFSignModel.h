//
//  UCFSignModel.h
//  JRGC
//
//  Created by njw on 2017/4/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFSignModel : NSObject

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)signWithDict:(NSDictionary *)dict;
@end
