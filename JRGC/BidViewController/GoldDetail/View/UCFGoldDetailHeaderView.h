//
//  UCFGoldDetailHeaderView.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFGoldModel.h"
@interface UCFGoldDetailHeaderView : UIView
@property (nonatomic,strong)UCFGoldModel *goldModel;

- (void)setProcessViewProcess:(CGFloat)process;
@end
