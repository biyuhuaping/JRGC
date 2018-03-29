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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proNumLabelWidth;
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

-(void)layoutSubviews{
    self.productNumLabel.backgroundColor = UIColorWithRGB(0xFA4F4C);
    self.productNumLabel.layer.cornerRadius = 9.f;
    self.productNumLabel.layer.masksToBounds = YES;
    if ( [_model.productNum intValue] <= 10) {//一位数时
        self.proNumLabelWidth.constant = 18;
    }else if([_model.productNum intValue]< 99){//两位数时
        self.proNumLabelWidth.constant = 24;
    }else{
        self.proNumLabelWidth.constant = 30;//99+时
    }
}

@end
