//
//  GuideViewController.h
//  JRGC
//
//  Created by 张瑞超 on 14-11-5.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//
@class GuideViewController;
@protocol GuideViewContlerDelegate <NSObject>

- (void)changeRootView;

@end
#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController
@property (assign, nonatomic) id <GuideViewContlerDelegate>delegate;
@end
