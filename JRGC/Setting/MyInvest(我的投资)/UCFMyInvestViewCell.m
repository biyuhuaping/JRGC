//
//  UCFMyInvestViewCell.m
//  JRGC
//
//  Created by biyuhuaping on 15/4/23.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFMyInvestViewCell.h"

@interface UCFMyInvestViewCell()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height5;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height6;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height7;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height8;
@end

@implementation UCFMyInvestViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _height1.constant = 0.5;
    _height2.constant = 0.5;
    _height3.constant = 0.5;
    _height4.constant = 0.5;
    _height5.constant = 0.5;
    _height6.constant = 0.5;
    _height7.constant = 0.5;
    _height8.constant = 0.5;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
