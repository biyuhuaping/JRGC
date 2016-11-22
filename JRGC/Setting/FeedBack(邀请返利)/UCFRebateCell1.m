//
//  UCFRebateCell1.m
//  JRGC
//
//  Created by biyuhuaping on 15/5/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFRebateCell1.h"

@interface UCFRebateCell1()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height3;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height4;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height5;

@end

@implementation UCFRebateCell1

- (void)awakeFromNib {
    // Initialization code
    _height1.constant = 0.5;
    _height2.constant = 0.5;
    _height3.constant = 0.5;
    _height4.constant = 0.5;
    _height5.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end