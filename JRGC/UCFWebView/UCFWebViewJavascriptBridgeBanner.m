//
//  UCFWebViewJavascriptBridgeBanner.m
//  JRGC
//
//  Created by 狂战之巅 on 16/9/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWebViewJavascriptBridgeBanner.h"

@interface UCFWebViewJavascriptBridgeBanner ()

@end

@implementation UCFWebViewJavascriptBridgeBanner

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  
    [self subShar];          //添加导航右侧按钮的分享，目前只有banner图有

    [self gotoURL:self.url];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

//只要是豆哥商城的都去掉导航栏，在此需要显示
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
