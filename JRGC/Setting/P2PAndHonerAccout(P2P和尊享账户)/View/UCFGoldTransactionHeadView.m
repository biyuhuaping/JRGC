//
//  UCFGoldTransactionHeadView.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldTransactionHeadView.h"

@implementation UCFGoldTransactionHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    self.middleLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    self.topSectionView.backgroundColor = [UIColor colorWithRed:231/255.0 green:230.0/255.0f blue:235.0f/255.0f alpha:1];
//    self.bottomSectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0f blue:247/255.0f alpha:1];
    self.middleLineView.hidden = YES;
    self.topSectionView.backgroundColor =  UIColorWithRGB(0xf5f5f5);
    self.bottomSectionView.backgroundColor = UIColorWithRGB(0xf5f5f5);

}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
