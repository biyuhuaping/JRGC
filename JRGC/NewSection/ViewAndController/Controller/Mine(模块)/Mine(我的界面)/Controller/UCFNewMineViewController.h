//
//  UCFNewMineViewController.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "BaseTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFNewMineViewController : UCFBaseViewController

@property (nonatomic, strong) BaseTableView *tableView;

- (void)signInButtonClick:(NSInteger )tag;
@end

NS_ASSUME_NONNULL_END
