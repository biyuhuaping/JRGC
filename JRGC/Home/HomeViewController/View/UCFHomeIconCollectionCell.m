//
//  UCFHomeIconCollectionCell.m
//  JRGC
//
//  Created by njw on 2017/9/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeIconCollectionCell.h"
#import "UCFHomeIconPresenter.h"
#import "UIImageView+WebCache.h"

@interface UCFHomeIconCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iconTitleLabel;

@end

@implementation UCFHomeIconCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIconPresenter:(UCFHomeIconPresenter *)iconPresenter
{
    _iconPresenter = iconPresenter;
    self.iconTitleLabel.text = iconPresenter.productName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconPresenter.icon] placeholderImage:nil];
    
}

@end
