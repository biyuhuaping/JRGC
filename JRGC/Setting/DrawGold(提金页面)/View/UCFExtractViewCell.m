//
//  UCFExtractViewCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/6.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFExtractViewCell.h"

#import "UIImageView+WebCache.h"
@interface UCFExtractViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *goldGoodsPicImageView;
@property (strong, nonatomic) IBOutlet UILabel *goldGoodsNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *subtractBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *numberBgBtn;

- (IBAction)clickSubtractBtn:(UIButton *)sender;
- (IBAction)clickAddBtn:(UIButton *)sender;
@end
@implementation UCFExtractViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setGoldModel:(UCFDrawGoldModel *)goldModel
{
    _goldModel = goldModel;
    [self.goldGoodsPicImageView  sd_setImageWithURL:[NSURL URLWithString:goldModel.picUrl] placeholderImage:[UIImage imageNamed:@"bank_default"]];
    self.goldGoodsNameLabel.text = goldModel.goldGoodsName;
    [self.addBtn setUserInteractionEnabled:goldModel.addBtnStatus];
    [self.subtractBtn setUserInteractionEnabled:goldModel.subtractBtnStatus];
    [self.numberBgBtn setUserInteractionEnabled:NO];
    [self.goldGoodsNumberLabel sendSubviewToBack:self.numberBgBtn];
    self.goldGoodsNumberLabel.text  = goldModel.goodsNumber;
    [self.addBtn setImage:[UIImage imageNamed:goldModel.addBtnStatus ? @"btn_add" :@"btn_add_disabled"] forState:UIControlStateNormal];
    [self.subtractBtn setImage:[UIImage imageNamed:goldModel.subtractBtnStatus ? @"btn_subtract": @"btn_subtract_disabled"] forState:UIControlStateNormal];
    [self.numberBgBtn setImage:[UIImage imageNamed:goldModel.numberBtnStatus ? @"bg_number": @"bg_number_disabled"] forState:UIControlStateNormal];
    
}
- (IBAction)clickSubtractBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickSubtractBtnCell:withgoldModel:)]) {
        [self.delegate clickSubtractBtnCell:self withgoldModel:self.goldModel];
    }
}
- (IBAction)clickAddBtn:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickAddBtnCell:withgoldModel:)]) {
        [self.delegate clickAddBtnCell:self withgoldModel:self.goldModel];
    }
}

@end
