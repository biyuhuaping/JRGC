//
//  UCFLanchViewController.h
//  JRGC
//
//  Created by zrc on 2018/8/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

@class UCFLanchViewController;

@protocol LanchViewControllerrDelegate <NSObject>

- (void)switchRootView;



@end

#import "UCFBaseViewController.h"

@interface UCFLanchViewController : UCFBaseViewController

@property (weak, nonatomic) id<LanchViewControllerrDelegate>delegate;

@end
