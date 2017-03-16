//
//  UCFNoPermissionViewController.h
//  JRGC
//
//  Created by HeJing on 15/5/18.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFNoPermissionViewController : UCFBaseViewController

@property (nonatomic,strong) NSString *souceVC;//从哪个页面过来的

- (id)initWithTitle:(NSString*)title noPermissionTitle:(NSString *)infoStr;

@end
