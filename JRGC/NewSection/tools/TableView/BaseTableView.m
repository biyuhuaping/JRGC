//
//  BaseTableView.m
//  JIMEITicket
//
//  Created by kuangzhanzhidian on 2018/6/13.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseTableView.h"
#import "XTNetReloader.h"
#import "WeChatStylePlaceHolder.h"
#import "MJRefresh.h"
#import "ToolSingleTon.h"
@interface BaseTableView()<CYLTableViewPlaceHolderDelegate,WeChatStylePlaceHolderDelegate>


@end

@implementation BaseTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.backgroundColor = [Color color:TTColorOptionPageBackgroundColor];
//        self.frame = CGRectMake(0, 0, 360, 547);
        self.isShowDefaultPlaceHolder = YES;
        self.enableRefreshHeader = YES;
        self.enableRefreshFooter = YES;
        adjustsScrollViewInsets(self);
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //        self.backgroundColor = [Color color:TTColorOptionPageBackgroundColor];
        //        self.frame = CGRectMake(0, 0, 360, 547);
        self.isShowDefaultPlaceHolder = YES;
        self.enableRefreshHeader = YES;
        self.enableRefreshFooter = YES;
        adjustsScrollViewInsets(self);
    }
    return self;
}
#pragma mark ---- 占位符
- (void)setIsShowDefaultPlaceHolder:(BOOL)isShowDefaultPlaceHolder
{
    _isShowDefaultPlaceHolder = isShowDefaultPlaceHolder;
    [self makePlaceHolderView];
}

#pragma mark - 下拉刷新数据

- (void)setEnableRefreshFooter:(BOOL)enableRefreshFooter
{
    @PGWeakObj(self);
    
    _enableRefreshFooter = enableRefreshFooter;
    
    if (_enableRefreshFooter) {
        
        if (!self.footer)
        {
            [self addLegendFooterWithRefreshingBlock:^{
                if ([selfWeak.tableRefreshDelegate respondsToSelector:@selector(refreshTableViewFooter)])
                {
                    [selfWeak.tableRefreshDelegate refreshTableViewFooter];
                }
            }];
            
        }
    }
    else{
        [self removeFooter];
    }
}

- (void)setEnableRefreshHeader:(BOOL)enableRefreshHeader
{
    @PGWeakObj(self);
    _enableRefreshHeader = enableRefreshHeader;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    if (_enableRefreshHeader)
    {
        if (!self.header)
        {
            [selfWeak addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(myGifHeaderWithRefreshing)];

        }
    }
    else
    {
        [self removeHeader];
    }
}

- (void)myGifHeaderWithRefreshing
{
    if ([self.tableRefreshDelegate respondsToSelector:@selector(refreshTableViewHeader)])
    {
        [self.tableRefreshDelegate refreshTableViewHeader];
    }
}


#pragma mark ----- 开始 && 结束 刷新
- (void)beginRefresh
{
    [self closeRefresh];
    [self.header beginRefreshing];
}

- (void)endRefresh
{
    [self closeRefresh];
}

- (void)closeRefresh
{
    if (self.header.isRefreshing)
    {
        [self.header endRefreshing];
    }
    if (self.footer.isRefreshing)
    {
        [self.footer endRefreshing];
    }
}

#pragma mark - CYLTableViewPlaceHolderDelegate Method

- (UIView *)makePlaceHolderView {
    
    if (_isShowDefaultPlaceHolder) {
        //  遵守代理自定义占位符视图
        if ([_tableRefreshDelegate respondsToSelector:@selector(setupPlaceHolder)])
        {
            UIView *placeHoldView = [_tableRefreshDelegate setupPlaceHolder];
            return placeHoldView;
        }
        else
        {
            if ([ToolSingleTon sharedManager].netWorkStatus == RealStatusNotReachable) {
                UIView *taobaoStyle = [self taoBaoStylePlaceHolder];
                return taobaoStyle;
            }
            UIView *weChatStyle = [self weChatStylePlaceHolder];
            return weChatStyle;
        }
    }
    return nil;
}

- (UIView *)taoBaoStylePlaceHolder {
     @PGWeakObj(self)
    __block XTNetReloader *netReloader = [[XTNetReloader alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                  reloadBlock:^{
                                                                      [selfWeak.header beginRefreshing];
                                                                  }] ;
    return netReloader;
}

- (UIView *)weChatStylePlaceHolder {
    WeChatStylePlaceHolder *weChatStylePlaceHolder = [[WeChatStylePlaceHolder alloc] initWithFrame:self.frame];
    weChatStylePlaceHolder.delegate = self;
    return weChatStylePlaceHolder;
}

#pragma mark - WeChatStylePlaceHolderDelegate Method

- (void)emptyOverlayClicked:(id)sender {
    [self beginRefresh];
}
/**
 *  下拉刷新完成的回调
 *
 */
- (void)refreshTableViewHeader{
    
}

/**
 *  上提刷新完成的回调
 *
 */
- (void)refreshTableViewFooter{
    
}
@end
