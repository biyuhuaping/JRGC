//
//  UCFGoldTransactionDetailViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldTransactionDetailViewController.h"

@interface UCFGoldTransactionDetailViewController ()

@end

@implementation UCFGoldTransactionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"交易详情";
}

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
