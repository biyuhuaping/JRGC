//
//  UCFWebViewJavascriptBridgeBanner.m
//  JRGC
//
//  Created by 狂战之巅 on 16/9/20.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWebViewJavascriptBridgeBanner.h"
#import "UCFHomeViewController.h"

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
    if (self.dicForShare) {
        [self subShar];          //添加导航右侧按钮的分享，目前只有banner图有
    }
//    if (![UserInfoSingle sharedManager].isSubmitTime) {
//        ((UCFHomeViewController *)self.rootVc).desVCStr = nil;
//    }
    [self gotoURL:self.url];
    
//    [self.KVOController observe:self.webView keyPaths:@[@"frame"] options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial  block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
//        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
//        if ([keyPath isEqualToString:@"frame"]) {
//            
//        }
//        
//    }];
//    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}

//只要是豆哥商城的都去掉导航栏，在此需要显示
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:self.isHideNativeNav animated:animated];
    if ([self.webView.request.URL.absoluteString containsString:@"dougemall"]){
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    
}

- (void)setIsHideNativeNav:(BOOL)isHideNativeNav
{

    [super setIsHideNativeNav:isHideNativeNav];
    
}


@end
