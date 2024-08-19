//
//  BaseTableViewCell.h
//  JFTPay
//
//  Created by kuangzhanzhidian on 2018/6/26.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseTableViewCell;
@protocol BaseTableViewCellDelegate <NSObject>

- (void)baseTableViewCell:(BaseTableViewCell *)cell buttonClick:(UIButton *)button withModel:(id)model;

@end

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) MyRelativeLayout *rootLayout;
@property (nonatomic, weak) id bc;
@property (nonatomic, weak) id <BaseTableViewCellDelegate>deleage;
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;
//@property (nonatomic, copy) NSString *cellTitleString;

- (void)refreshCellData:(id)data;

- (void)getBassController:(id)bassController;

- (void)cellLineHidden:(BOOL)isCellLineHidden;

@end
