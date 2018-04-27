//
//  MoreModel.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "MoreModel.h"

@interface MoreModel()
@property(nonatomic, copy)NSString  *leftTitle;
@property(nonatomic, copy)NSString  *rightDesText;
@property(nonatomic, assign)BOOL    isShowAccess;
@property(nonatomic, copy)NSString  *targetClassName;

@end

@implementation MoreModel

- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle ShowAccess:(BOOL)access TargetClassName:(NSString *)name
{
    if (self = [super init]) {
        self.leftTitle = leftTitle;
        self.rightDesText = rightTitle;
        _isShowAccess = access;
        self.targetClassName = name;
    }
    return self;
}

@end
