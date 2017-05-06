//
//  UCFProductListCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/5/5.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFProductListCell.h"

@interface UCFProductListCell ()
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end
@implementation UCFProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setModel:(UCFProductListModel *)model{
    _model = model;
    self.productNumLabel.text = model.productNum;
    self.productNameLabel.text = model.productName;
    self.descriptionLabel.text = model.descriptionStr;
}

@end
