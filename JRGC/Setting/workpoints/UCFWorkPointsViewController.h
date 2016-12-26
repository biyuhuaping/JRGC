//
//  UCFWorkPointsViewController.h
//  JRGC
//
//  Created by 狂战之巅 on 16/4/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFCompleteBidViewCtrl.h"

@interface UCFWorkPointsViewController : UCFBaseViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak,   nonatomic) UCFCompleteBidViewCtrl *superView; //投标成功页
@end
