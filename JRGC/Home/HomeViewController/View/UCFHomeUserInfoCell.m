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
        self.itemValueLabel.textColor = UIColorWithRGB(0xfd4d4c);
    }
    else {
        self.itemValueLabel.textColor = UIColorWithRGB(0x999999);
    }
    self.itemValueLabel.text = item.subtitle;
}

@end
