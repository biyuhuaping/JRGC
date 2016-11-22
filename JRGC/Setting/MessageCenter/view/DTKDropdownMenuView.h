//
//  DTKDropdownMenuView.h
//  duiTiKu
//
//  Created by 韩启元 on 15/12/10.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropdownMenuViewDelegate <NSObject>

-(void)isShowMenuView;

@end

typedef void(^dropMenuCallBack)(NSUInteger index,id info);

typedef enum : NSUInteger {
    dropDownTypeTitle = 0,//navBar的titleView
    dropDownTypeLeftItem = 1,//leftBarItem
    dropDownTypeRightItem = 2,//rightBarItem
} DTKDropDownType;

@interface DTKDropdownButton : UIButton
@end

@interface DTKDropdownMenuView : UIView

+ (instancetype)dropdownMenuViewWithType:(DTKDropDownType)dropDownType frame:(CGRect)frame dropdownItems:(NSArray *)dropdownItems icon:(NSString *)icon;
+ (instancetype)dropdownMenuViewForNavbarTitleViewWithFrame:(CGRect )frame dropdownItems:(NSArray *)dropdownItems;

/// 当前Nav导航栏  
@property(weak ,nonatomic) UINavigationController *currentNav;

/// 当前选中index 默认是0
@property (assign ,nonatomic) NSUInteger selectedIndex;

@property (strong ,nonatomic) UITableView *tableView;
/**是否显示*/
@property (assign ,nonatomic) BOOL isMenuShow;

/// titleColor 标题字体颜色  默认 白色
@property (strong, nonatomic) UIColor *titleColor;
/// titleFont  标题字体  默认 system 17
@property (strong, nonatomic) UIFont  *titleFont;
/**按钮title*/
@property (strong ,nonatomic) DTKDropdownButton *titleButton;
/// 下拉菜单的宽度  默认80.f
@property (assign, nonatomic) CGFloat dropWidth;
/// 下拉菜单 cell 颜色  默认 白色
@property (strong, nonatomic) UIColor *cellColor;
/// 下拉菜单 cell 字体颜色 默认 白色
@property (strong, nonatomic) UIColor *textColor;
/// 下拉菜单 cell 字体大小 默认 system 17.f
@property (strong, nonatomic) UIFont  *textFont;
/// 下拉菜单 cell seprator color 默认 白色
@property (strong, nonatomic) UIColor *cellSeparatorColor;
/// 下拉菜单 cell accessory check mark color 默认 默认白色
@property (strong, nonatomic) UIColor *cellAccessoryCheckmarkColor;
/// 下拉菜单 cell 高度 默认 40.f
@property (assign, nonatomic) CGFloat cellHeight;
/// 下拉菜单 弹出动画执行时间 默认 0.4s
@property (assign, nonatomic) CGFloat animationDuration;
/// 下拉菜单 cell 是否显示选中按钮  默认 NO
@property (assign, nonatomic) BOOL    showAccessoryCheckmark;
/// 下拉菜单 第一个cell 是否可点
@property (assign, nonatomic) BOOL    isFirstClick;
/// 下拉菜单 第二个cell 是否可点
@property (assign, nonatomic) BOOL    isSecondClick;

/// 默认幕布透明度 opacity 默认 0.3f
@property (assign, nonatomic) CGFloat backgroundAlpha;

/// 默认幕布透明度 opacity 默认 0.5f
@property (assign, nonatomic) CGFloat cellBackgroundAlpha;

@property (assign,nonatomic) id<DropdownMenuViewDelegate> delegate;

//显示下拉菜单
- (void)showMenu;
//隐藏下拉菜单
- (void)hideMenu;
@end

@interface DTKDropdownItem : NSObject
/// 回调 callBack
@property (nonatomic, copy) dropMenuCallBack callBack;
/// title
@property (copy, nonatomic) NSString *title;
/// icon
@property (copy, nonatomic) NSString *iconName;
/// selected
@property (assign, nonatomic)  BOOL isSelected;
/// info 自定义参数
@property (strong, nonatomic) id info;

+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName callBack:(dropMenuCallBack)callBack;
+ (instancetype)itemWithTitle:(NSString *)title callBack:(dropMenuCallBack)callBack;
+ (instancetype)Item;

@end