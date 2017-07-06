//
//  UCFGoldCashViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashViewController.h"

@interface UCFGoldCashViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;

@end

@implementation UCFGoldCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"黄金变现";
    // Do any additional setup after loading the view from its nib.
}
//- (void)updateViewConstraints
//{
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
