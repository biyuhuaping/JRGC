//
//  UCFHomeUserInfoCell.m
//  JRGC
//
//  Created by njw on 2017/5/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeUserInfoCell.h"
#import "UCFUserInfoListItem.h"

@interface UCFHomeUserInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemValueLabel;
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

@end

@implementation UCFHomeUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(UCFUserInfoListItem *)item
{
    _item = item;
    
    self.itemTitleLabel.text = item.title;
    self.itemDescribeLabel.hidden = !item.isShow;
    if (item.isShow) {
        if ([_item.title isEqualToString:@"黄金账户"]) {
            self.itemValueLabel.textColor = UIColorWithRGB(0xfc8f0e);
            self.itemDescribeLabel.text = @"可用黄金";
        } else {
            self.itemValueLabel.textColor = UIColorWithRGB(0xfd4d4c);
            self.itemDescribeLabel.text = @"可用余额";

        }
    }
    else {
        self.itemValueLabel.textColor = UIColorWithRGB(0x999999);
    }
    self.itemValueLabel.text = item.subtitle;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    if (totalRows == 1) { // 这组只有1行
        self.downLine.hidden = NO;
        self.upLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upLine.hidden = NO;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 15;
    }
}

@end
