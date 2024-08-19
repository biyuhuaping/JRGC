//
//  UCFCalculateTypeCell.m
//  JRGC
//
//  Created by njw on 2017/12/13.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFCalculateTypeCell.h"

@interface UCFCalculateTypeCell ()
@property (weak, nonatomic) IBOutlet UIView *downSegLineView;

@end

@implementation UCFCalculateTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
    [self.downSegLineView setBackgroundColor:UIColorWithRGB(0xe3e5ea)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
