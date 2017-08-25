//
//  UCFGoldRaiseView.h
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldIncreaseAccountInfoModel;

@protocol UCFGoldRaiseViewDelegate <NSObject>

- (void)floatDetailClicedButton:(UIButton *)button;
- (void)averagePriceDetailClicedButton:(UIButton *)button;

@end

@interface UCFGoldRaiseView : UIView
@property (nonatomic, strong) UCFGoldIncreaseAccountInfoModel *goldIncreModel;
@property (nonatomic, weak) id<UCFGoldRaiseViewDelegate> delegate;

+ (CGFloat)viewHeight;
@end
