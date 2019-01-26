//
//  UCFNewBaseViewController.h
//  JRGC
//
//  Created by zrc on 2019/1/10.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewBaseViewController : UIViewController
@property(nonatomic, strong)MyRelativeLayout *rootLayout;
@property(assign,nonatomic) SelectAccoutType accoutType;

/**
 导航栏左侧按钮为文字

 @param title 文字内容
 */
- (void)addLeftButtonTitle:(NSString *)title;

/**
 右侧导航添加多个按钮，

 @param imageArray 按钮图片名称数组
 */
- (void)addrightButtonWithImageArray:(NSArray *)imageArray;

/**
 右侧按钮点击

 @param button 点击的button
 */
- (void)rightBarClicked:(UIButton *)button;
@end

NS_ASSUME_NONNULL_END
