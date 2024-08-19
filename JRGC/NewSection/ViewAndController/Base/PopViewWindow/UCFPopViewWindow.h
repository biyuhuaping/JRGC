//
//  UCFPopViewWindow.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFPublicPopupWindowView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFPopViewWindow : NSObject

@property (nonatomic ,assign) POPWINDOWS type;

@property (nonatomic, copy)   NSString *contentStr;

@property (nonatomic, copy)   NSString *titletStr;

@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, weak) id delegate;

@property (nonatomic ,assign) NSInteger popViewTag;

- (void)startPopView;
@end

NS_ASSUME_NONNULL_END
