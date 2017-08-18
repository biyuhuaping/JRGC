//
//  UCFGoldRaiseView.h
//  JRGC
//
//  Created by njw on 2017/8/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFGoldIncreaseAccountInfoModel;
@interface UCFGoldRaiseView : UIView
@property (nonatomic, strong) UCFGoldIncreaseAccountInfoModel *goldIncreModel;

+ (CGFloat)viewHeight;
@end
