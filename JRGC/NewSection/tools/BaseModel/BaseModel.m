//
//  BaseModel.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
#pragma mark - 实现copy和encode协议
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [self yy_modelEncodeWithCoder:aCoder];
}
    
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
    
- (id)copyWithZone:(NSZone *)zone {
    
    return [self yy_modelCopy];
}
    
- (NSString *)description {
    
    return [self yy_modelDescription];
}
@end
