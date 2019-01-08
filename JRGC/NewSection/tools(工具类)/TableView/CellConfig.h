//
//  CellConfig.h
//  JIEMO
//
//  Created by 狂战之巅 on 2017/1/4.
//  Copyright © 2017年 狂战之巅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellConfig : NSObject

/// cell类名
@property (nonatomic, strong) NSString *className;

/// 标题 - 如“我的订单”，对不同种cell进行不同设置时，可以通过 其对应的 cellConfig.title 进行判断
@property (nonatomic, strong) NSString *title;

/// 显示数据模型的方法
@property (nonatomic, assign) SEL showInfoMethod;

/// cell高度(固定高度)
@property (nonatomic, assign) CGFloat heightOfCell;

/// 预留属性detail
@property (nonatomic, strong) NSString *detail;

/// 预留属性remark
@property (nonatomic, strong) NSString *remark;

/// 指定重用ID，不赋值则使用类名
@property (nonatomic, strong) NSString *reuseID;


#pragma mark - Core
/**
 * @brief 便利构造器
 *
 * @param className 类名
 * @param title 标题，可用做cell直观的区分
 * @param showInfoMethod 此类cell用来显示数据模型的方法， 如@selector(showInfo:)
 * @param heightOfCell 此类cell的高度
 *
 *
 */
+ (instancetype)cellConfigWithClassName:(NSString *)className
                                  title:(NSString *)title
                         showInfoMethod:(SEL)showInfoMethod
                           heightOfCell:(CGFloat)heightOfCell;


/// 根据cellConfig生成cell，重用ID为cell类名
- (UITableViewCell *)cellOfCellConfigWithTableView:(UITableView *)tableView
                                         dataModel:(id)dataModel;

/// 根据cellConfig生成cell，重用ID为cell类名,可使用Nib
- (UITableViewCell *)cellOfCellConfigWithTableView:(UITableView *)tableView
                                         dataModel:(id)dataModel
                                             isNib:(BOOL)isNib;

#pragma mark - Dynamic Height
/// cell动态高度(计算后缓存到这个字段,避免重复计算,损耗性能)
@property (nonatomic, assign) CGFloat dynamicHeightOfCell;

/// 缓存高度
- (CGFloat)heightCachedWithCalculateBlock:(CGFloat (^)(void) )block;

#pragma mark - Assist
/// 根据类名，快捷注册cell
- (void)registerForTableView:(UITableView *)tableView;


@end
