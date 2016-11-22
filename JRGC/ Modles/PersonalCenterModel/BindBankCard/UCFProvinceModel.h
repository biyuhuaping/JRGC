//
//  UCFProvinceModel.h
//  JRGC
//
//  Created by NJW on 15/5/25.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFProvinceModel : NSObject
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *firstLetter;

-(id)initWithDictionary:(NSDictionary *)dicJson;
+ (instancetype)provinceWithDict:(NSDictionary *)dict;
@end
