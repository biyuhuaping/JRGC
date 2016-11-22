//
//  UCFProjectLabel.h
//  JRGC
//
//  Created by NJW on 2016/11/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFProjectLabel : NSObject
@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, strong) NSNumber *labelPriority;
@property (nonatomic, copy) NSString *labelPrompt;


+ (instancetype)projectLabelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
