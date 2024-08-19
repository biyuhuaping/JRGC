//
//  UCFPicADModel.h
//  JRGC
//
//  Created by njw on 2017/9/26.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFPicADModel : NSObject
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *pic;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *url;

+ (instancetype)picADWithDict:(NSDictionary *)dict;
@end
