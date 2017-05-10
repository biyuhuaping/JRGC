//
//  UCFHomeListCell.m
//  JRGC
//
//  Created by njw on 2017/5/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListCell.h"

@implementation UCFHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
