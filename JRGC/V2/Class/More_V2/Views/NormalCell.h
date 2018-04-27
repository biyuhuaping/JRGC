//
//  NormalCell.h
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreModel.h"
@interface NormalCell : UITableViewCell
@property(nonatomic,strong)MoreModel *model;
- (void)setModel:(MoreModel *)model;
@end
