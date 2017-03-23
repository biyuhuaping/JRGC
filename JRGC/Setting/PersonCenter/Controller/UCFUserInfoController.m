//
//  UCFUserInfoController.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInfoController.h"

@interface UCFUserInfoController ()
@property (copy, nonatomic) ViewControllerGenerator userInfoVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator messageVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator beansVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator couponVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator workPointInfoVCGenerator;
@end

@implementation UCFUserInfoController

+ (instancetype)userInfo {
    return [[UCFUserInfoController alloc] init];
}

+ (CGFloat)viewHeight {
    return 177;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



@end
