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
        self.backgroundColor = [Color color:PGColorOptionThemeWhite];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(0, 0, height, height);
        imageView.backgroundColor = [UIColor clearColor];
        self.shopImageView = imageView;
        [self addSubview:imageView];
        
        UIImageView *sacleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_discount"]];
        sacleImage.frame = CGRectMake(CGRectGetWidth(imageView.frame) - 32, CGRectGetHeight(imageView.frame) - 37, 32, 37);
        sacleImage.backgroundColor = [UIColor clearColor];
        [imageView addSubview:sacleImage];
        
        UILabel *discountLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 35)];
        discountLab.textColor = [Color color:PGColorOptionThemeWhite];
        discountLab.textAlignment = NSTextAlignmentCenter;
        discountLab.font = [Color gc_Font:15];
        discountLab.text = @"9折";
        [sacleImage addSubview:discountLab];
        self.discountLab = discountLab;
        
        UILabel *nameLal = [[UILabel alloc] init];
        nameLal.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 8, frame.size.width, 13);
        nameLal.font = [Color gc_Font:12.0f];
        nameLal.textColor = [Color color:PGColorOptionTitleBlack];
        nameLal.textAlignment = NSTextAlignmentCenter;
        nameLal.text = @"iphone3";
        self.shopName = nameLal;
        [self addSubview:nameLal];
        
        UILabel *beansLal = [[UILabel alloc] init];
        beansLal.frame = CGRectMake(0, CGRectGetMaxY(nameLal.frame) + 3, frame.size.width, 13);
        beansLal.font = [Color gc_Font:12.0f];
        beansLal.textAlignment = NSTextAlignmentCenter;
        beansLal.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
        beansLal.text = @"8000工贝";
        self.shopValue = beansLal;
        [self addSubview:beansLal];
        
        UILabel *orginBeansLal = [[UILabel alloc] init];
        orginBeansLal.frame = CGRectMake(0, CGRectGetMaxY(beansLal.frame) + 3, frame.size.width, 13);
        orginBeansLal.font = [Color gc_Font:10.0f];
        orginBeansLal.textAlignment = NSTextAlignmentCenter;
        orginBeansLal.textColor = [Color color:PGColorOptionTitleGray];
        orginBeansLal.text = @"18000工贝";
        self.shopOrginalValue = orginBeansLal;
        [self addSubview:orginBeansLal];
    }
    return self;
}

@end
