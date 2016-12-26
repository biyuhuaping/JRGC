//
//  UCFModifyBankCardViewController.m
//  JRGC
//
//  Created by NJW on 15/5/8.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFModifyBankCardViewController.h"
#import "UCFProvinceModel.h"

@interface UCFModifyBankCardViewController () 

@end

@implementation UCFModifyBankCardViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"modifybankcard"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}


@end
