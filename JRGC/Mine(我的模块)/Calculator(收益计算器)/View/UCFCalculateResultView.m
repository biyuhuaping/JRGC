//
//  UCFCalculateResultView.m
//  JRGC
//
//  Created by njw on 2017/12/8.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFCalculateResultView.h"

@interface UCFCalculateResultView ()

@property (weak, nonatomic) IBOutlet UILabel *labelThird;
@property (weak, nonatomic) IBOutlet UILabel *labelLast;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdSpace;
@property (weak, nonatomic) IBOutlet UILabel *valueFirst;
@property (weak, nonatomic) IBOutlet UILabel *valueSecond;
@property (weak, nonatomic) IBOutlet UILabel *valueThird;
@property (weak, nonatomic) IBOutlet UILabel *valueFourth;

@end

@implementation UCFCalculateResultView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end
