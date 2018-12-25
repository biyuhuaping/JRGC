//
//  MJLogoHeader.m
//  JIEMO
//
//  Created by 狂战之巅 on 2017/2/20.
//  Copyright © 2017年 狂战之巅. All rights reserved.
//

#import "MJLogoHeader.h"

@implementation MJLogoHeader

#pragma mark - 重写方法
#pragma mark 基本设置
//- (void)prepare
//{
//    [super prepare];
//
//    // 设置普通状态的动画图片
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i <= 36; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%zd", i]];
//        if (image != nil) {
//            [idleImages addObject:image];
//        }
//    }
//    [self setImages:idleImages forState:MJRefreshStateIdle];
//
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i <= 36; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%zd", i]];
//        if (image != nil) {
//            [refreshingImages addObject:image];
//
//        }
//
//    }
//    [self setImages:refreshingImages forState:MJRefreshStatePulling];
//
//    // 设置正在刷新状态的动画图片
//    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
//
//
//
//    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderIdleText] forState:MJRefreshStateIdle];
//    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderPullingText] forState:MJRefreshStatePulling];
//    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderRefreshingText] forState:MJRefreshStateRefreshing];
//    // 初始化间距
//    self.labelLeftInset = 20;
//    self.stateLabel.autoresizingMask = UIViewAutoresizingNone;
//    self.stateLabel.font = [Color font:12.0];
//    self.stateLabel.textColor = [Color color:PGColorOptionLoadingTitleColor];
//    self.lastUpdatedTimeLabel.font = [Color font:10.0];
//    self.lastUpdatedTimeLabel.textColor = [Color color:PGColorOptionLoadingTitleColor];
//
//}
//- (void)placeSubviews
//{
//    [super placeSubviews];
//
//    self.stateLabel.mj_y = 7;
//    self.stateLabel.mj_h = self.stateLabel.mj_h -3;
////    self.lastUpdatedTimeLabel.mj_y = CGRectGetMaxY(self.stateLabel.frame) - 3;
//}


@end
