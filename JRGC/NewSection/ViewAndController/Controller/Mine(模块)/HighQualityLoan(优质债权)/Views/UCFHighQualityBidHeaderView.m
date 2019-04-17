//
//  UCFHighQualityBidHeaderView.m
//  JRGC
//
//  Created by zrc on 2019/3/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFHighQualityBidHeaderView.h"
#import "UIImage+Compression.h"
@implementation UCFHighQualityBidHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        
        UIImageView *baseMapView = [[UIImageView alloc] init];
        baseMapView.myVertMargin = 0;
        baseMapView.myHorzMargin = 0;
        [self addSubview:baseMapView];
        UIImage *image = [UIImage gc_styleImageSize:CGSizeMake(ScreenWidth, 130)];
        baseMapView.image = image;
        
        UILabel *principalMarkLab = [UILabel new];
        principalMarkLab.text = @"待收本金";
        principalMarkLab.textColor = [Color color:PGColorOptionThemeWhite];
        principalMarkLab.font = [Color gc_Font:12];
        principalMarkLab.leftPos.equalTo(@15);
        principalMarkLab.topPos.equalTo(@25);
        [self addSubview:principalMarkLab];
        [principalMarkLab sizeToFit];
        
        UILabel *principalValueLab = [UILabel new];
        principalValueLab.text = @"";
        principalValueLab.textColor = [Color color:PGColorOptionThemeWhite];
        principalValueLab.font = [Color gc_Font:32];
        principalValueLab.leftPos.equalTo(@15);
        principalValueLab.topPos.equalTo(@48);
        [self addSubview:principalValueLab];
        [principalValueLab sizeToFit];
        self.principalValueLab = principalValueLab;
        
        UILabel *interestMarkLab = [UILabel new];
        interestMarkLab.text = @"待收利息";
        interestMarkLab.textColor = [Color color:PGColorOptionThemeWhite];
        interestMarkLab.font = [Color gc_Font:12];
        interestMarkLab.leftPos.equalTo(@15);
        interestMarkLab.topPos.equalTo(@93);
        [self addSubview:interestMarkLab];
        [interestMarkLab sizeToFit];

        UILabel *interestValueLab = [UILabel new];
        interestValueLab.text = @"";
        interestValueLab.textColor = [Color color:PGColorOptionThemeWhite];
        interestValueLab.font = [Color gc_Font:15];
        interestValueLab.leftPos.equalTo(interestMarkLab.rightPos).offset(10);
        interestValueLab.centerYPos.equalTo(interestMarkLab.centerYPos);
        [self addSubview:interestValueLab];
        [interestValueLab sizeToFit];
        self.interestValueLab = interestValueLab;
    }
    return self;
}

@end
