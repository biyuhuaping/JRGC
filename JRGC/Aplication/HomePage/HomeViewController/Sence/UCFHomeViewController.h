//
//  UCFHomeViewController.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFHomeListViewController.h"

@interface UCFHomeViewController : UCFBaseViewController
- (void)skipToOtherPage:(UCFHomeListType)type;
@property (copy, nonatomic) NSString *desVCStr;
@end
