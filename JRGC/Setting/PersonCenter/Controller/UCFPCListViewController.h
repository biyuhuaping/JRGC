//
//  UCFPCListViewController.h
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UCFPCListModel.h"
#import "UCFPCListViewPresenter.h"

@protocol UCFPCListViewControllerCallBack <NSObject>

- (void)pcListViewControllerdidSelectItem:(UCFPCListModel *)pcListModel;

@end

@interface UCFPCListViewController : NSObject<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<UCFPCListViewControllerCallBack> delegate;
+ (instancetype)instanceWithPresenter:(UCFPCListViewPresenter *)presenter;

- (UITableView *)tableView;
- (UCFPCListViewPresenter *)presenter;
@end
