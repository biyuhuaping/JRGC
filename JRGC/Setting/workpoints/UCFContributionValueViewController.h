//
//  UCFContributionValueViewController.h
//  JRGC
//
//  Created by 秦 on 16/6/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBaseViewController.h"
@interface UCFContributionValueViewController : UCFBaseViewController
@property (copy, nonatomic) void(^totalCountBlock)(id);

// 选项的点击事件
- (void)didClickSelectedItemWithSeg:(NSInteger)sender;

@end
