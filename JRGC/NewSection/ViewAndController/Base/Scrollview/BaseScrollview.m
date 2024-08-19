//
//  BaseScrollview.m
//  JFTPay
//
//  Created by kuangzhanzhidian on 2018/6/26.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseScrollview.h"

@implementation BaseScrollview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self = [super init]) {
        adjustsScrollViewInsets(self);
    }
    return self;
}
@end
