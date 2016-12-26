//
//  UCFLatestProjectViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/8.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "BJGridItem.h"

@interface UCFLatestProjectViewController : UCFBaseViewController<BJGridItemDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
