//
//  UCFHuiShangChooseBankViewController.h
//  JRGC
//
//  Created by 狂战之巅 on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
@protocol UCFHuiShangChooseBankViewControllerDelegate <NSObject>

@optional
-(void) chooseBankData:(NSDictionary *)data;//bankCode;bankName;logoUrl

@end
@interface UCFHuiShangChooseBankViewController : UCFBaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) id<UCFHuiShangChooseBankViewControllerDelegate> bankDelegate;

@property (nonatomic, copy) NSString *site;
@end
