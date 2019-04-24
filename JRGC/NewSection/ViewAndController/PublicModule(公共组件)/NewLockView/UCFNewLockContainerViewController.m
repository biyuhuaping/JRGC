//
//  UCFNewLockContainerViewController.m
//  JRGC
//
//  Created by zrc on 2019/4/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewLockContainerViewController.h"
#import "UCFLockConfig.h"
@interface UCFNewLockContainerViewController ()

@end

@implementation UCFNewLockContainerViewController
- (id)initWithType:(RCLockViewType)type
{
    if (self = [super init]) {
        if (RCLockViewTypeCheck) {
            
        } else if (RCLockViewTypeCreate) {
            
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
