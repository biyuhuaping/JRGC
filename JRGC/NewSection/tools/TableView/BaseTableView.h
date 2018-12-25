//
//  BaseTableView.h
//  JIMEITicket
//
//  Created by kuangzhanzhidian on 2018/6/13.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTableViewPlaceHolder.h"
@protocol BaseTableViewDelegate <NSObject>
@optional
/**
 *  @author JX
 *
 *  自定义占位符（针对无网络||无数据的占位符）
 *
 *  @return 占位符视图
 */
- (UIView *)setupPlaceHolder;

/**
 *  下拉刷新完成的回调
 *
 */
- (void)refreshTableViewHeader;

/**
 *  上提刷新完成的回调
 *
 */
- (void)refreshTableViewFooter;

@end

@interface BaseTableView : UITableView

/**
 *  @author JX
 *
 *  声明下拉和上提加载的代理
 */

@property (nonatomic,weak) id <BaseTableViewDelegate> tableRefreshDelegate;


/**
 *  @author JX
 *
 *  是否显示占位符(默认为YES)
 */
@property (nonatomic) BOOL isShowDefaultPlaceHolder; //defaultHolderBool;

/**
 *  @author JX
 *
 *  是否禁止下拉刷新（默认为YES）
 */
@property (nonatomic) BOOL enableRefreshHeader;

/**
 *  @author JX
 *
 *  是否禁止上提加载 （默认为YES）
 */
@property (nonatomic) BOOL enableRefreshFooter;

/**
 *  @author JX
 *
 *  开始下拉刷新
 */

- (void)beginRefresh;

/**
 *  @author JX
 *
 *  结束上拉和下拉刷新
 */

- (void)endRefresh;

@end
