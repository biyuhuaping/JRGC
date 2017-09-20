//
//  UCFMineHeaderView.h
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFMineHeaderView;
@protocol UCFMineHeaderViewDelegate <NSObject>

- (void)mineHeaderViewDidClikedUserInfoWithCurrentVC:(UCFMineHeaderView *)mineHeaderView;

@end

@interface UCFMineHeaderView : UIView
@property (weak, nonatomic) id<UCFMineHeaderViewDelegate> delegate;
+ (CGFloat)viewHeight;
@end
