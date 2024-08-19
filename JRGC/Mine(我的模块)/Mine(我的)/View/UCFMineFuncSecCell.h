//
//  UCFMineFuncSecCell.h
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFMineFuncSecCell;
@protocol UCFMineFuncSecCellDelegate <NSObject>

- (void)mineFuncSecCell:(UCFMineFuncSecCell *)funcSecCell didClickedButtonWithTitle:(NSString *)title;

@end

@interface UCFMineFuncSecCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *title2DesLabel;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UIView *sign2View;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) id<UCFMineFuncSecCellDelegate> delegate;

@property (weak, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
