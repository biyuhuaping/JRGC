//
//  UCFCommodityView.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCommodityView.h"

@implementation UCFCommodityView

- (instancetype)initWithFrame:(CGRect)frame withHeightOfCommodity:(CGFloat)height
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, frame.size.width, height);
        imageView.backgroundColor = [UIColor yellowColor];
        self.shopImageView = imageView;
        [self addSubview:imageView];
        
        UILabel *nameLal = [[UILabel alloc] init];
        nameLal.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, frame.size.width, 13);
        nameLal.font = [Color gc_Font:12.0f];
        nameLal.textColor = [UIColor blackColor];
        nameLal.textAlignment = NSTextAlignmentCenter;
        nameLal.text = @"iphone3";
        self.shopName = nameLal;
        [self addSubview:nameLal];
        
        UILabel *beansLal = [[UILabel alloc] init];
        beansLal.frame = CGRectMake(0, CGRectGetMaxY(nameLal.frame) + 5, frame.size.width, 13);
        beansLal.font = [Color gc_Font:12.0f];
        beansLal.textAlignment = NSTextAlignmentCenter;
        beansLal.textColor = UIColorWithRGB(0xff4133);
        beansLal.text = @"8000工贝";
        self.shopValue = beansLal;
        [self addSubview:beansLal];
    }
    return self;
}

@end
