//
//  MyViewController.h
//  JRGC
//
//  Created by biyuhuaping on 16/4/6.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface MyViewController : UCFBaseViewController
//@property (strong, nonatomic) UISegmentedControl *segmentedCtrl;
//@property (nonatomic, copy) void(^setHeaderInfoBlock)(NSDictionary *);

@property(nonatomic,assign) NSUInteger selectedSegmentIndex;
- (void)segmentedValueChanged:(UISegmentedControl *)sender;
@end
