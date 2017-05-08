//
//  UCFCycleImageViewController.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@class UCFUserPresenter;
@interface UCFCycleImageViewController : UIViewController
#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFUserPresenter *)presenter;
#pragma mark - 计算轮播图模块的高度
+ (CGFloat)viewHeight;
#pragma mark - 返回当前controller的presenter
- (UCFUserPresenter *)presenter;
@end
