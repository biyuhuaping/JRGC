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
    
    NSString *localImage = @"";
    NSString *productName = iconPresenter.productName;
    if ([productName isEqualToString:@"微金"]) {
        localImage = @"home_icon_weijin.png";
    } else if ([productName isEqualToString:@"尊享"]) {
        localImage = @"home_icon_zunxiang.png";
    } else if ([productName isEqualToString:@"黄金"] ) {
        localImage = @"home_icon_gold.png";
    } else if ([productName isEqualToString:@"预约"]) {
        localImage = @"home_icon_yuyue.png";
    } else if ([productName isEqualToString:@"债转"]) {
        localImage = @"home_icon_zhaizhuan.png";
    }
    UIImage *imageData = [UIImage imageNamed:localImage];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconPresenter.icon] placeholderImage:imageData];
    
}

@end
