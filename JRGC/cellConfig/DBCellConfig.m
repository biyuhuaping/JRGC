
//
//  DBCellConfig.m
//  DUOBAO
//
//  Created by 战神归来 on 15/10/21.
//  Copyright © 2015年 战神归来. All rights reserved.
//

#import "DBCellConfig.h"

@implementation DBCellConfig
+ (instancetype)cellConfigWithClassName:(NSString *)className
                                  title:(NSString *)title
                         showInfoMethod:(SEL)showInfoMethod
                           heightOfCell:(CGFloat)heightOfCell
{
    DBCellConfig *cellConfig = [DBCellConfig new];
    
    cellConfig.className = className;
    cellConfig.title = title;
    cellConfig.showInfoMethod = showInfoMethod;
    cellConfig.heightOfCell = heightOfCell;
    
    return cellConfig;
}

/// 根据cellConfig生成cell，重用ID为cell类名
- (UITableViewCell *)cellOfCellConfigWithTableView:(UITableView *)tableView
                                         dataModel:(id)dataModel
{
    return [self cellOfCellConfigWithTableView:tableView dataModel:dataModel isNib:NO];
}

/// 根据cellConfig生成cell，重用ID为cell类名,可使用Nib
- (UITableViewCell *)cellOfCellConfigWithTableView:(UITableView *)tableView
                                         dataModel:(id)dataModel
                                             isNib:(BOOL)isNib
{
    Class cellClass = NSClassFromString(self.className);
    
    
    // 重用cell
    NSString *cellID = self.className;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // 加入使用nib的方法
    if (!cell) {
        
        if (isNib) {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:self.className owner:nil options:nil];
            cell = [nibs lastObject];
            
        } else {
            cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        }
    }
    
    // 设置cell
    if (self.showInfoMethod && [cell respondsToSelector:self.showInfoMethod]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cell performSelector:self.showInfoMethod withObject:dataModel];
#pragma clang diagnostic pop
        
    }
    
    return cell;
}

@end
