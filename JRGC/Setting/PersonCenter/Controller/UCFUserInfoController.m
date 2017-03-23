//
//  UCFUserInfoController.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInfoController.h"

@interface UCFUserInfoController ()
@property (weak, nonatomic) IBOutlet UIView *userIconBackView;
@property (copy, nonatomic) ViewControllerGenerator userInfoVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator messageVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator beansVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator couponVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator workPointInfoVCGenerator;
@property (strong, nonatomic) UCFPCListViewPresenter *presenter;
@end

@implementation UCFUserInfoController

+ (instancetype)instanceWithPresenter:(UCFPCListViewPresenter *)presenter {
    return [[UCFUserInfoController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFPCListViewPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
//        self.presenter.view = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
        
    }
    return self;
}

+ (CGFloat)viewHeight {
    return 177;
}

- (UCFPCListViewPresenter *)presenter
{
    return self.presenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserIcon:)];
    [self.userIconBackView addGestureRecognizer:tap];
    
}

- (void)tapUserIcon:(UIGestureRecognizer *)gesture
{
    if (self.userInfoVCGenerator) {
        
        UIViewController *targetVC = self.userInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)messageClicked:(UIButton *)sender {
    if (self.messageVCGenerator) {
        
        UIViewController *targetVC = self.messageVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)factoryBeanClicked:(UIButton *)sender {
    if (self.beansVCGenerator) {
        
        UIViewController *targetVC = self.beansVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)couponClicked:(UIButton *)sender {
    if (self.couponVCGenerator) {
        
        UIViewController *targetVC = self.couponVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)workPoint:(UIButton *)sender {
    if (self.workPointInfoVCGenerator) {
        
        UIViewController *targetVC = self.workPointInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

@end
