//
//  UCFGoldDetailHeaderView.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFGoldModel.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "SDLoopProgressView.h"
#import "MDRadialProgressLabel.h"
@interface UCFGoldDetailHeaderView : UIView
@property (nonatomic,strong)UCFGoldModel *goldModel;
@property (nonatomic,strong)MDRadialProgressView *circleProgress;
- (void)setProcessViewProcess:(CGFloat)process;
@end
@interface UCFGoldCurrentDetailHeaderView : UIView
@property (nonatomic,strong)UCFGoldModel *goldModel;
@property (nonatomic,strong)MDRadialProgressView *circleProgress;
@end
