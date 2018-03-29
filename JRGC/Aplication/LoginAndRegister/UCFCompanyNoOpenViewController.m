//
//  UCFCompanyNoOpenViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/6/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCompanyNoOpenViewController.h"

@interface UCFCompanyNoOpenViewController ()
- (IBAction)clickOutLoginBtn:(id)sender;

@end

@implementation UCFCompanyNoOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWithRGB(0x282D47);
    self.view.alpha = 0.95;
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)clickOutLoginBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}
@end
