//
//  UCFUserInformationViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInformationViewController.h"
#import "UCFUserPresenter.h"

#define UserInfoViewHeight  327

@interface UCFUserInformationViewController () <UCFUserPresenterUserInfoCallBack>
@property (strong, nonatomic) UCFUserPresenter *presenter;

@property (copy, nonatomic) ViewControllerGenerator personInfoVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator messageVCGenerator;

@end

@implementation UCFUserInformationViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFUserPresenter *)presenter {
    return [[UCFUserInformationViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFUserPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.userInfoViewDelegate = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
    }
    return self;
}

#pragma mark - 计算用户信息页高度
+ (CGFloat)viewHeight
{
    CGFloat height = [UIScreen mainScreen].bounds.size.width / 3.2;
    return UserInfoViewHeight + height;
}

#pragma mark - 个人信息
- (IBAction)personInfo:(UIButton *)sender {
    if (self.personInfoVCGenerator) {
        
        UIViewController *targetVC = self.personInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)message:(UIButton *)sender {
    if (self.messageVCGenerator) {
        UIViewController *targetVC = self.messageVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

@end
