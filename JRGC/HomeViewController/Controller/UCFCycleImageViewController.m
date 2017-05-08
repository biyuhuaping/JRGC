//
//  UCFCycleImageViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCycleImageViewController.h"
#import "UCFUserPresenter.h"

@interface UCFCycleImageViewController () <UCFUserPresenterCyceleImageCallBack>
@property (strong, nonatomic) UCFUserPresenter *presenter;
@end

@implementation UCFCycleImageViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 计算轮播图模块的高度
+ (CGFloat)viewHeight
{
    return [UIScreen mainScreen].bounds.size.width * 0.5 + 10;
}


#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFUserPresenter *)presenter {
    return [[UCFCycleImageViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFUserPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.cycleImageViewDelegate = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
    }
    return self;
}


@end
