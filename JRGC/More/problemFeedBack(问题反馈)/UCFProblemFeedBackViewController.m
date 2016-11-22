//
//  UCFProblemFeedBackViewController.m
//  JRGC
//
//  Created by NJW on 15/4/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFProblemFeedBackViewController.h"
#import "UMFeedback.h"//反馈界面
#import "UMFeedbackViewController.h"

@interface UCFProblemFeedBackViewController ()

@end

@implementation UCFProblemFeedBackViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UCFMoreViewController" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"problemfeedback"];
        self = (UCFProblemFeedBackViewController *)[UMFeedback feedbackViewController];
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(0, 0, 60, 30)];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -50, 0.0, 0.0)];
        [leftButton setImage:[UIImage imageNamed:@"icon_back.png"]forState:UIControlStateNormal];
        [[UMFeedback sharedInstance] setBackButton:leftButton];
    }
    return self;
}

@end
