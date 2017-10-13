//
//  DTKDropdownMenuView.m
//  duiTiKu
//
//  Created by 韩启元 on 15/12/10.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "DTKDropdownMenuView.h"
#import "UCFBaseViewController.h"
#import "Masonry.h"

/**__weak  */
#define menuWeakSelf(menuWeakSelf)  __weak __typeof(&*self)menuWeakSelf = self;
// 图片路径

/**
 *  获取最大允许的高度
 *
 *  @return
 */
static CGFloat DDPMAX_TABLEVIEW_HEIGHT(){
    return [UIScreen mainScreen].bounds.size.height * 0.6f;
}

static CGFloat DDP_TABLEVIEW_HEIGHT = 0.f;
static const CGFloat DDP_PADDING = 10.f;

@interface UIViewController (topest)
- (UIViewController *)topestViewController;
@end
@implementation UIViewController (topest)

- (UIViewController *)topestViewController
{
    if (self.presentedViewController)
    {
        return [self.presentedViewController topestViewController];
    }
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tab = (UITabBarController *)self;
        return [[tab selectedViewController] topestViewController];
    }
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)self;
        return [[nav visibleViewController] topestViewController];
    }
    
    return self;
}

@end


@implementation DTKDropdownButton
- (void)setHighlighted:(BOOL)highlighted{};
@end

@interface DTKDropdownMenuView()
<
UITableViewDelegate,
UITableViewDataSource
>

/**items*/
@property (strong, nonatomic) NSArray *items;

/**下拉指示箭头*/
@property (strong ,nonatomic) UIImageView *arrowImageView;
/**下拉列表头部箭头*/
@property (strong, nonatomic) UIImageView *tableViewTopArrow;
///**下拉列表*/
//@property (strong ,nonatomic) UITableView *tableView;
/**底色*/
@property (strong ,nonatomic) UIView *backgroundView;
/**nav下背景*/
@property (strong ,nonatomic) UIView *wrapperView;
/**下拉菜单类型*/
@property (assign, nonatomic) DTKDropDownType dropDownType;
/**按钮图标*/
@property (copy, nonatomic) NSString *icon;
@end

@implementation DTKDropdownMenuView
@synthesize textFont = _textFont;
@synthesize titleFont = _titleFont;
@synthesize textColor = _textColor;
@synthesize titleColor = _titleColor;
@synthesize cellColor = _cellColor;
@synthesize cellSeparatorColor = _cellSeparatorColor;
@synthesize dropWidth = _dropWidth;

+ (instancetype)dropdownMenuViewWithType:(DTKDropDownType)dropDownType frame:(CGRect)frame dropdownItems:(NSArray *)dropdownItems icon:(NSString *)icon
{
    DTKDropdownMenuView *menuView = [[DTKDropdownMenuView alloc] initWithFrame:frame];
    menuView.dropDownType = dropDownType;
    [menuView updateMainConstraints];
    menuView.items = dropdownItems;
    menuView.isMenuShow = NO;
    menuView.selectedIndex = 0;
    menuView.icon = icon;
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(frame.size.width, frame.size.height));

    }];
    return menuView;
}

+ (instancetype)dropdownMenuViewForNavbarTitleViewWithFrame:(CGRect )frame dropdownItems:(NSArray *)dropdownItems
{
    return [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeTitle frame:frame dropdownItems:dropdownItems icon:nil];
}

/**
 *  界面点击事件监测
 */
- (void)addTapGesture:(UIView *)view
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [view addGestureRecognizer:tapGesture];
}
- (void)onTap:(UITapGestureRecognizer *)gesture
{
    //点击视图 结束编辑状态
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        self.isMenuShow = NO;
    }
}
- (void)addArrowTapGesture:(UIView *)view
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onArrowTap:)];
    [view addGestureRecognizer:tapGesture];
}
- (void)onArrowTap:(UITapGestureRecognizer *)gesture
{
    //点击视图 结束编辑状态
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        self.isMenuShow = YES;
    }
}

- (void)addBarItemTap:(UIView *)view
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barItemTap:)];
    [view addGestureRecognizer:tapGesture];
}
- (void)barItemTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
//        self.isMenuShow = !self.isMenuShow;
        if ([self.delegate respondsToSelector:@selector(isShowMenuView)]) {
            [self.delegate isShowMenuView];
        }
    }
}

- (void)updateMainConstraints
{
    //主按钮居中
    if (self.dropDownType == dropDownTypeTitle) {
        [self.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
    }else{
        [self.titleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            if (self.dropDownType == dropDownTypeLeftItem) {
                make.leading.equalTo(self.mas_leading);
            }else{
                make.trailing.equalTo(self.mas_trailing);
            }
        }];
        [self addBarItemTap:self];
    }
//    //下拉指示图
//    [self.arrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.titleButton.mas_right).offset(5.f);
//        make.centerY.equalTo(self.titleButton.mas_centerY);
//    }];
}


- (void)addWindowsSubviewsConstraints
{
    UINavigationController *nav = nil;
    if (self.currentNav) {
        nav = self.currentNav;
    }else{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        nav = [keyWindow.rootViewController topestViewController].navigationController;
    }
//    UINavigationBar *navBar = nav.navigationBar;
    [nav.view addSubview:self.wrapperView];
    [self.wrapperView addSubview:self.backgroundView];
    [self.wrapperView addSubview:self.tableViewTopArrow];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor blueColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = self.cellSeparatorColor;
    _tableView.alpha = self.cellBackgroundAlpha;
//#ifdef __IPHONE_11_0
//    if (@available(iOS 11.0, *)) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//    }
//#endif
    [self.wrapperView addSubview:self.tableView];
    menuWeakSelf(menuWeakSelf)
    
    [self.wrapperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(nav.view);
    }];
    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(menuWeakSelf.wrapperView);
    }];
    
    [self.tableViewTopArrow mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(navBar.mas_bottom);
        make.top.equalTo(self).with.offset(35);
        if (self.dropDownType == dropDownTypeTitle) {
            make.centerX.equalTo(self.mas_centerX);
        }else{
            make.centerX.equalTo(menuWeakSelf.titleButton.mas_centerX);
        }
    }];
    
    NSUInteger count = DDPMAX_TABLEVIEW_HEIGHT()/self.cellHeight;
    if (count > self.items.count) {
        DDP_TABLEVIEW_HEIGHT = self.cellHeight * self.items.count;
        self.tableView.scrollEnabled = NO;
    }else{
        DDP_TABLEVIEW_HEIGHT = self.cellHeight * count;
        self.tableView.scrollEnabled = YES;
    }
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.dropWidth);
        make.height.mas_equalTo(0.f);
//        make.
        make.top.equalTo(self.tableViewTopArrow.mas_bottom);
        switch (menuWeakSelf.dropDownType) {
            case dropDownTypeTitle:
            {
                make.centerX.equalTo(menuWeakSelf.tableViewTopArrow.mas_centerX);
            }
                break;
            case dropDownTypeLeftItem:
            {
                make.left.equalTo(menuWeakSelf.wrapperView.mas_left).offset(DDP_PADDING);
            }
                break;
            case dropDownTypeRightItem:
            {
                make.right.equalTo(menuWeakSelf.wrapperView.mas_right).offset(-DDP_PADDING);
            }
                break;
            default:
                break;
        }
    }];
    self.wrapperView.hidden = YES;
}

- (void)showMenu
{
    [self addWindowsSubviewsConstraints];
    
    self.titleButton.enabled = NO;
    [self.tableView layoutIfNeeded];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(DDP_TABLEVIEW_HEIGHT);
    }];
    self.wrapperView.hidden = NO;
    self.backgroundView.alpha = 0.0;
    menuWeakSelf(menuWeakSelf)
//    [UIView animateWithDuration:self.animationDuration * 1.5f
//                     animations:^{
//                         menuWeakSelf.arrowImageView.transform = CGAffineTransformRotate(menuWeakSelf.arrowImageView.transform, M_PI);
//                     }];
    [UIView animateWithDuration:self.animationDuration * 1.5f
                          delay:0
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [menuWeakSelf.tableView layoutIfNeeded];
                         [menuWeakSelf.tableView reloadData];
                         CGRect bound = CGRectMake(0.f, 0.f, menuWeakSelf.dropWidth,DDP_TABLEVIEW_HEIGHT - 1.f );
                         UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bound byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6.f, 6.f)];
                         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                         maskLayer.frame = bound;
                         maskLayer.path = maskPath.CGPath;
                         menuWeakSelf.tableView.layer.mask = maskLayer;
                         menuWeakSelf.backgroundView.alpha = self.backgroundAlpha;
                     } completion:^(BOOL finished) {
                         menuWeakSelf.titleButton.enabled = YES;
                     }];
}
- (void)hideMenu
{
    if (!_wrapperView) {
        return;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.f);
    }];
    [self.tableViewTopArrow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.f);
    }];
//    self.titleButton.alpha = 1.f;
    menuWeakSelf(menuWeakSelf)
//    [UIView animateWithDuration:self.animationDuration * 1.5f
//                     animations:^{
//                         menuWeakSelf.arrowImageView.transform = CGAffineTransformIdentity;
//                     }];
    [UIView animateWithDuration:self.animationDuration * 1.5f
                          delay:0
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [menuWeakSelf.tableView layoutIfNeeded];
                         [menuWeakSelf.tableViewTopArrow layoutIfNeeded];
                         menuWeakSelf.backgroundView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         menuWeakSelf.wrapperView.hidden = YES;
                         [_tableView removeFromSuperview];
                         [_tableViewTopArrow removeFromSuperview];
                         [_backgroundView removeFromSuperview];
                         [_wrapperView removeFromSuperview];
                         _tableView = nil;
                         _tableViewTopArrow = nil;
                         _backgroundView = nil;
                         _wrapperView = nil;
                     }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DTKDropdownMenuViewCell"];
    UILabel * titleLabel = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"DTKDropdownMenuViewCell"];
        //添加cell的 分割线
        UIView *cellSeparatorView = [[UIView alloc]initWithFrame:CGRectMake(10, self.cellHeight-0.5, 87 , 0.5)];
        cellSeparatorView.backgroundColor = self.cellSeparatorColor;
        [cell addSubview:cellSeparatorView];
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,11,87,16)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font =  self.textFont;
        titleLabel.textColor  = self.textColor;
        [cell addSubview:titleLabel];
    }
    DTKDropdownItem *item = self.items[indexPath.row];
    titleLabel.text = item.title;
//    if (item.iconName.length) {
//        [cell.imageView setImage:[UIImage imageNamed:item.iconName]];
//    }
//    if (self.selectedIndex == indexPath.row&&self.showAccessoryCheckmark) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
//    cell.tintColor = self.cellAccessoryCheckmarkColor;
    cell.backgroundColor = self.cellColor;
//    cell.textLabel.font = self.textFont;
    cell.alpha = self.cellBackgroundAlpha ;
//    cell.textLabel.textColor = self.textColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.dropDownType == dropDownTypeRightItem) {
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    }
    if(self.isFirstClick && indexPath.row == 0){
        titleLabel.textColor = UIColorWithRGB(0x7c8ab0);
    }
    if(self.isSecondClick && indexPath.row == 1){
         titleLabel.textColor = UIColorWithRGB(0x7c8ab0);
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DTKDropdownItem *item = self.items[indexPath.row];
//    self.selectedIndex = indexPath.row;
    if (!self.isFirstClick && indexPath.row == 0) {
        if (item.callBack) {
            item.callBack(indexPath.row,item.info);
        }
    }
    if (!self.isSecondClick && indexPath.row == 1) {
        if (item.callBack) {
            item.callBack(indexPath.row,item.info);
        }
    }
    if (item.callBack && indexPath.row == 2)  {
        item.callBack(indexPath.row,item.info);
    }
    self.isMenuShow = NO;
}
//设置cell的分割线居左
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}


#pragma mark -- handle actions --

- (void)handleTapOnTitleButton:(DTKDropdownButton *)button
{
    if ([self.delegate respondsToSelector:@selector(isShowMenuView)]) {
        [self.delegate isShowMenuView];
    }
//    self.isMenuShow = !self.isMenuShow;
}

#pragma mark - setter
- (void)setCellColor:(UIColor *)cellColor
{
    if (_tableViewTopArrow) {
       [_tableViewTopArrow setTintColor:cellColor];
    }
    _cellColor = cellColor;
}
- (void)setCellSeparatorColor:(UIColor *)cellSeparatorColor
{
    if (_tableView)
    {
        _tableView.separatorColor = cellSeparatorColor;
    }
    _cellSeparatorColor = cellSeparatorColor;
}
- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleButton) {
        [_titleButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
    _titleColor = titleColor;
    
}
- (void)setTitleFont:(UIFont *)titleFont
{
    if (_titleButton) {
        [_titleButton.titleLabel setFont:titleFont];
    }
    _titleFont = titleFont;
}
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}
- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
}

- (void)setDropWidth:(CGFloat)dropWidth
{
    if (_dropWidth!=dropWidth) {
        _dropWidth = dropWidth;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_dropWidth);
        }];
    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    if (self.dropDownType == dropDownTypeTitle) {
        DTKDropdownItem *item = self.items[_selectedIndex];
        [self.titleButton setTitle:item.title forState:UIControlStateNormal];
        CGFloat titleWidth = [item.title sizeWithAttributes:@{NSFontAttributeName:self.titleFont}].width;
        if (titleWidth > self.frame.size.width) {
            [self.titleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.mas_equalTo(self.frame.size.width);
            }];
        }else{
            [self.titleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
            }];
        }
    }
    self.isMenuShow = NO;
}

- (void)setIcon:(NSString *)icon
{
    if (![_icon isEqualToString:icon]) {
        _icon = icon;
        if (self.dropDownType != dropDownTypeTitle) {
            [self.titleButton setImage:[UIImage imageNamed:_icon] forState:UIControlStateNormal];
//            [self.titleButton setImage:[UIImage imageNamed:_icon] forState:UIControlStateSelected];
        }
    }
}
- (void)setDropDownType:(DTKDropDownType)dropDownType
{
    _dropDownType = dropDownType;
    self.arrowImageView.hidden = (_dropDownType != dropDownTypeTitle);
}
- (void)setIsMenuShow:(BOOL)isMenuShow
{
    if (_isMenuShow != isMenuShow) {
        _isMenuShow = isMenuShow;
        if (_isMenuShow) {
            //展开
            [self showMenu];
            
        }else{
            //隐藏
            [self hideMenu];
            
        }
    }
}


#pragma mark - getter

- (DTKDropdownButton *)titleButton
{
    if (!_titleButton)
    {
        _titleButton = [DTKDropdownButton buttonWithType:UIButtonTypeCustom];
//        if (self.items.count) {
////            DTKDropdownItem *item = self.items[0];
////            [_titleButton setTitle:item.title forState:UIControlStateNormal];
//        }
        [_titleButton addTarget:self action:@selector(handleTapOnTitleButton:) forControlEvents:UIControlEventTouchUpInside];
//        [_titleButton.titleLabel setFont:self.titleFont];
////        [_titleButton setTitleColor:self.titleColor forState:UIControlStateNormal];
//        _titleButton.titleLabel.lineBreakMode =NSLineBreakByTruncatingTail;
        [self addSubview:_titleButton];
    }
    return _titleButton;
}

//- (UIImageView *)arrowImageView
//{
//    if (!_arrowImageView)
//    {
//        UIImage *image = [UIImage imageNamed:DTKMenuSrcName(@"arrow_down_icon.png")]?:[UIImage imageNamed:DTKMenuFrameworkSrcName(@"arrow_down_icon.png")];
//        _arrowImageView = [[UIImageView alloc] initWithImage:image];
//        [self addSubview:_arrowImageView];
//        _arrowImageView.userInteractionEnabled = YES;
//        _arrowImageView.hidden = YES;
//        [self addArrowTapGesture:_arrowImageView];
//    }
//    return _arrowImageView;
//}

- (UIImageView *)tableViewTopArrow
{
    if (!_tableViewTopArrow) {
        UIImage *tempImage = [UIImage imageNamed:@"message_option_arrow"];
//        UIImage *image=[tempImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _tableViewTopArrow = [[UIImageView alloc] initWithImage:tempImage];
    }
    return _tableViewTopArrow;
}

//- (UITableView *)tableView
//{
//    if (!_tableView)
//    {
//        _tableView = [[UITableView alloc] init];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor blueColor];
//        _tableView.tableFooterView = [[UIView alloc] init];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.separatorColor = self.cellSeparatorColor;
//        _tableView.alpha = self.cellBackgroundAlpha;
//    }
//    
//    return _tableView;
//}

- (UIView *)wrapperView
{
    if (!_wrapperView)
    {
        _wrapperView = [[UIView alloc]init];
        _wrapperView.clipsToBounds = YES;
    }
    return _wrapperView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = self.backgroundAlpha;
        [self addTapGesture:_backgroundView];
    }
    
    return _backgroundView;
}

#pragma mark - getter 初始化属性
- (CGFloat)cellBackgroundAlpha
{
    if (!_backgroundAlpha * 10) {
        return 1.0f;
    }
    return _backgroundAlpha;
}
//默认背景透明度
- (CGFloat)backgroundAlpha
{
    if (!_backgroundAlpha * 10) {
        return 0.05f;
    }
    return _backgroundAlpha;
}
//默认字体大小 system 17
- (UIFont *)textFont
{
    if (!_textFont) {
        return [UIFont systemFontOfSize:17.f];
    }
    return _textFont;
}
//默认字体颜色 白色
- (UIColor *)textColor
{
    if (!_textColor) {
        return [UIColor whiteColor];
    }
    return _textColor;
}
//默认动画时间0.4s
- (CGFloat)animationDuration
{
    if (!_animationDuration * 100) {
        return 0.4f;
    }
    return _animationDuration;
}
//默认cell高度44.f
- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        return 40.f;
    }
    return _cellHeight;
}
//默认
- (UIColor *)cellAccessoryCheckmarkColor
{
    if (!_cellAccessoryCheckmarkColor) {
        return [UIColor whiteColor];
    }
    return _cellAccessoryCheckmarkColor;
}
//默认
- (UIColor *)cellSeparatorColor
{
    if (!_cellSeparatorColor) {
        return [UIColor whiteColor];
    }
    return _cellSeparatorColor;
}
//默认白色
- (UIColor *)cellColor
{
    if (!_cellColor) {
        return [UIColor whiteColor];
    }
    return _cellColor;
}
//默认title字体 system 17
- (UIFont *)titleFont
{
    if (!_titleFont) {
        return [UIFont systemFontOfSize:17.f];
    }
    return _titleFont;
}
//默认白色
- (UIColor *)titleColor
{
    if (!_titleColor) {
        return [UIColor redColor];
    }
    return _titleColor;
}
//默认设置80.f
- (CGFloat)dropWidth
{
    if (_dropWidth < 80.f) {
        return 80.f;
    }
    return _dropWidth;
}

@end

@implementation DTKDropdownItem

+ (instancetype)Item
{
    return [[self alloc]init];
}
+ (instancetype)itemWithTitle:(NSString *)title callBack:(dropMenuCallBack)callBack
{
    return [self itemWithTitle:title iconName:nil callBack:callBack];
}
+ (instancetype)itemWithTitle:(NSString *)title iconName:(NSString *)iconName callBack:(dropMenuCallBack)callBack
{
    DTKDropdownItem *item = [DTKDropdownItem Item];
    item.title = title;
    item.iconName = iconName;
    item.callBack = callBack;
    return item;
}


@end


