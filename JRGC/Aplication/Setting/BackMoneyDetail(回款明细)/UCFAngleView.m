//
//  UCFAngleView.m
//  JRGC
//
//  Created by biyuhuaping on 15/4/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFAngleView.h"

@implementation UCFAngleView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSString *tempStr = _angleString;
    if (tempStr.length == 0) {
        return;
    }else if (tempStr.length <= 3){
        DBLOG(@"111111111111111111111111111");
        tempStr = [NSString stringWithFormat:@"  %@  ",tempStr];
    }
    UIImageView *imaView = [[UIImageView alloc]initWithFrame:self.bounds];
    if ([_angleStatus isEqualToString:@"2"]) {
        imaView.image = [UIImage imageNamed:@"invest_bg_label"];
    }else
        imaView.image = [UIImage imageNamed:@"invest_bg_label_gary"];
    [self addSubview:imaView];
    
    imaView.image = [imaView.image stretchableImageWithLeftCapWidth:18 topCapHeight:10];
//    imaView.image = [imaView.image resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 10, 16) resizingMode:UIImageResizingModeTile];
//    CGSize constraint = [tempStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(150, MAXFLOAT) lineBreakMode:NSLineBreakByClipping];
    CGSize constraint = [tempStr boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    float x = CGRectGetMinX(imaView.frame) - constraint.width/2;
    imaView.frame = CGRectMake(x, 0, constraint.width + 10, 17);
//    imaView.center = CGPointMake(x, 8.5);
    
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, CGRectGetWidth(imaView.frame), 17)];
//    lab1.backgroundColor = [UIColor redColor];
    lab1.textColor = [UIColor whiteColor];
    lab1.font = [UIFont systemFontOfSize:12];
    lab1.text = tempStr;
    [imaView addSubview:lab1];
}

@end
