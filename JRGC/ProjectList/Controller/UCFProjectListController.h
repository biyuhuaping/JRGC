//
//  UCFProjectListController.h
//  JRGC
//
//  Created by NJW on 2016/11/16.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@class UCFP2PViewController;
@interface UCFProjectListController : UCFBaseViewController
@property (nonatomic, copy) NSString *strStyle;
@property (nonatomic, copy) NSString *viewType;


- (void)changeViewWithConfigure:(NSString *)config;
@end
