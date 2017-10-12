//
//  UCFCycleImageViewController.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@class UCFHomeListPresenter, UCFCycleImageViewController, UCFHomeIconPresenter;

@protocol UCFCycleImageViewControllerDelegate <NSObject>

- (void)cycleImageVC:(UCFCycleImageViewController *)cycleImageVC didClickedIconWithIconPresenter:(UCFHomeIconPresenter *)iconPresenter;

- (void)proInvestAlert:(UIAlertView *)alertView didClickedWithTag:(NSInteger)tag withIndex:(NSInteger)index;

@end

@interface UCFCycleImageViewController : UIViewController
@property (weak, nonatomic) id<UCFCycleImageViewControllerDelegate> delegate;

@property (copy, nonatomic) NSString *noticeStr;

#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFHomeListPresenter *)presenter;
#pragma mark - 计算轮播图模块的高度
+ (CGFloat)viewHeight;
#pragma mark - 返回当前controller的presenter
- (UCFHomeListPresenter *)presenter;
#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData;

#pragma mark - 刷新公告
- (void)refreshNotice;
@end
