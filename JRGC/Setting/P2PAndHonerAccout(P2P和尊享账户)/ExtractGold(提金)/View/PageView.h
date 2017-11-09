//
//  PageView.h
//  TestPageViewController
//
//  Created by njw on 2017/11/3.
//  Copyright © 2017年 njw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView
@property (nonatomic, assign) NSInteger selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withControllers:(NSArray *)controllers;
@end
