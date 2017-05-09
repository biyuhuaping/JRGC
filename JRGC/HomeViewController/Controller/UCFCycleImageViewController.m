//
//  UCFCycleImageViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCycleImageViewController.h"
#import "UCFUserPresenter.h"
#import "SDCycleScrollView.h"

@interface UCFCycleImageViewController () <UCFUserPresenterCyceleImageCallBack, SDCycleScrollViewDelegate>
@property (strong, nonatomic) UCFUserPresenter *presenter;
@property (weak, nonatomic) SDCycleScrollView *cycleImageView;
@end

@implementation UCFCycleImageViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    
    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
                        [UIImage imageNamed:@"h2.jpg"],
                        [UIImage imageNamed:@"h3.jpg"],
                        [UIImage imageNamed:@"h4.jpg"]
                        ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
        cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 2.0;
    [self.view addSubview:cycleScrollView];
    self.cycleImageView = cycleScrollView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect cycleFrame = self.view.bounds;
    cycleFrame.size.height -= 10;
    self.cycleImageView.frame = cycleFrame;
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

#pragma mark - 计算轮播图模块的高度
+ (CGFloat)viewHeight
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (width == 320) {
        return 170;
    }
    else if (width == 375) {
        return 197.5;
    }
    else
        return 320.5;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

@end
