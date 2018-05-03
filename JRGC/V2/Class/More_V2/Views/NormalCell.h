//
//  NormalCell.h
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreViewModel.h"
#import "ColorTheme.h"
@interface NormalCell : UITableViewCell
@property(nonatomic,weak)NSIndexPath *indexPath;
@property(nonatomic,strong)MoreViewModel *vm;
- (void)layoutMoreView;
@end
