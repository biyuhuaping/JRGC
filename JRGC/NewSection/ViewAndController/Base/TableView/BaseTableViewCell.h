//
//  BaseTableViewCell.h
//  JFTPay
//
//  Created by kuangzhanzhidian on 2018/6/26.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
@property (nonatomic, strong) MyRelativeLayout *rootLayout;
@property (nonatomic, weak) id bc;
- (void)refreshCellData:(id)data;

- (void)getBassController:(id)bassController;
@end
