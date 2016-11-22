//
//  UCFLatesProjectTableViewCell.m
//  JRGC
//
//  Created by 秦 on 2016/11/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFLatesProjectTableViewCell.h"

@implementation UCFLatesProjectTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
  
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}
- (IBAction)buttonPress:(id)sender {
    [self.delegate homeButtonPressed:sender withCelltypeSellWay:self.typeSellWay];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
//    switch (self.typeSellWay) {
//        case 0:
//        {
//            self.image_ahead.image = [UIImage imageNamed:@"zunxiang_special_icon.png"];
//            self.label_title.text = @"尊享计划";
//        }
//            break;
//        case 1:
//        {
//            self.image_ahead.image = [UIImage imageNamed:@"tabbar_icon_project_normal.png"];
//            self.label_title.text = @"P2P专区";
//        }
//            break;
//            
//        default:
//            break;
//    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
