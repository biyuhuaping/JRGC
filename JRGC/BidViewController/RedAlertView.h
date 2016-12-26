//
//  RedAlertView.h
//  JRGC
//
//  Created by 金融工场 on 15/6/5.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//
@protocol RedAlertViewDelegate <NSObject>

- (void)shareRedBag:(NSInteger)index;

@end
#import <UIKit/UIKit.h>

@interface RedAlertView : UIView
@property(nonatomic, assign)id<RedAlertViewDelegate> delegate;
- (void)reloadViews:(NSDictionary *)dict;
@end
