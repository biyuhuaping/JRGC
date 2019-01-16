//
//  HomeFootView.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "HomeFootView.h"

@implementation HomeFootView


- (void)createSubviews
{
    UIImageView *view1 = [[UIImageView alloc] init];
    view1.heightSize.equalTo(@100);
    view1.topPos.equalTo(@17);
    view1.leftPos.equalTo(@15);
    view1.image = [UIImage imageNamed:@"home_pic_1"];
    view1.heightSize.equalTo(view1.widthSize);
    [self addSubview:view1];
    
    UIImageView *view2 = [[UIImageView alloc] init];
    view2.topPos.equalTo(view1.topPos);
    view2.heightSize.equalTo(view1.heightSize);
    view2.leftPos.equalTo(view1.rightPos).offset(10);
    view2.image = [UIImage imageNamed:@"home_pic_2"];

    [self addSubview:view2];
    
    UIImageView *view3 = [[UIImageView alloc] init];
    view3.heightSize.equalTo(view1.heightSize);
    view3.topPos.equalTo(view1.topPos);
    view3.leftPos.equalTo(view2.rightPos).offset(10);
    view3.rightPos.equalTo(@15);
    view3.image = [UIImage imageNamed:@"home_pic_3"];
    [self addSubview:view3];
    
    view1.widthSize.equalTo(@[view2.widthSize.add(-10),view3.widthSize.add(-10)]).add(-30);

    UILabel *lab = [[UILabel alloc] init];
    lab.font = [Color gc_Font:13.0f];
    lab.textColor = UIColorWithRGB(0xb1b5c2);
    lab.text = @"市场有风险  出借需谨慎";
    [lab sizeToFit];
    lab.topPos.equalTo(view1.bottomPos).offset(20);
    lab.centerXPos.equalTo(self.centerXPos);
    [self addSubview:lab];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
