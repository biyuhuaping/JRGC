//
//  NormalCell.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "NormalCell.h"

@implementation NormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    
}
- (void)setModel:(MoreModel *)model
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
