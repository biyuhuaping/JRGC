//
//  UCFGoldenHeaderView.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldenHeaderView.h"

@implementation UCFGoldenHeaderView
+ (CGFloat)viewHeight
{
    return 236;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height = self.goldValueBackView.bottom + 10;
}

@end
