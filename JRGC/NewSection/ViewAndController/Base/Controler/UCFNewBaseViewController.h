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
#import "NetworkModule.h"
#import "JSONKit.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewBaseViewController : UIViewController<NetworkModuleDelegate>
@property(nonatomic, strong)MyRelativeLayout *rootLayout;

/**
 自定义导航烂
 */
@property(nonatomic, strong)UIView           *customNav;

/**
 添加自定义返回按钮
 */
- (void)addCustomBlueLeftButton;

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

/**
 返回按钮
 */
- (void)addWhiteLeftButton;

- (void)addBlueLeftButton;
/**
 设置标题

 @param text 标题文案
 */
- (void)setTitleViewText:(NSString *)text;

/**
 

 @param name <#name description#>
 */
- (void)addRightbuttonImageName:(NSString *)name;

/**
 绑定监听用户状态
 */
- (void)blindUserStatue;
/**
 监听用户登录注册
 */
- (void)monitorUserLogin;

/**
 监听用户退出登录
 */
- (void)monitorUserGetOut;

/**
 监听用户开户状态改变
 */
- (void)monitorOpenStatueChange;

/**
 监听用户风险评估状态
 */
- (void)monitorRiskStatueChange;

/**
 禁用返回手势

 @param setNavgationPopDisabled YES 为禁用
 */
- (void)setSetNavgationPopDisabled:(BOOL)setNavgationPopDisabled;

/**
 web页面关闭需要刷新某页面的数据
 */
- (void)refreshPageData;
@end

NS_ASSUME_NONNULL_END
