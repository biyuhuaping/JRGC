//
//  UCFCommodityView.m
//  JRGC
//
//  Created by zrc on 2019/1/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCommodityView.h"
@interface UCFCommodityView ()

@property (nonatomic, strong) UIImageView *moneyCoinImageView;

@end
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
        beansLal.frame = CGRectMake(10, CGRectGetMaxY(nameLal.frame) + 3, frame.size.width -10, 13);
        beansLal.font = [Color gc_Font:12.0f];
        beansLal.textAlignment = NSTextAlignmentCenter;
        beansLal.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
        beansLal.text = @"8000工贝";
        self.shopValue = beansLal;
        [self addSubview:beansLal];
        
        self.moneyCoinImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"moneycoin"]];
        self.moneyCoinImageView.frame = CGRectMake(0, beansLal.center.y - 5, 10, 10);
        self.moneyCoinImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.moneyCoinImageView];
        
        
//        UILabel *orginBeansLal = [[UILabel alloc] init];
//        orginBeansLal.frame = CGRectMake(0, CGRectGetMaxY(beansLal.frame) + 3, frame.size.width, 13);
//        orginBeansLal.font = [Color gc_Font:10.0f];
//        orginBeansLal.textAlignment = NSTextAlignmentCenter;
//        orginBeansLal.textColor = [Color color:PGColorOptionTitleGray];
//        orginBeansLal.text = @"18000工贝";
//        self.shopOrginalValue = orginBeansLal;
//        [self addSubview:orginBeansLal];
    }
    return self;
}



- (void)setShopValueWithModel:(id )model
{
    
    if ([model isKindOfClass:[UCFHomeMallsale class]]) {
        
        UCFHomeMallsale *newModel = model;
        [self setMoneyPrice:newModel.price andScore:newModel.score andDiscount:newModel.discount];
        
    }
    else if ([model isKindOfClass:[UCFHomeMallrecommends class]])
    {
        UCFHomeMallrecommends *newModel = model;
        [self setMoneyPrice:newModel.price andScore:newModel.score andDiscount:newModel.discount];
    }
}

- (void)setMoneyPrice:(NSString *)price andScore:(NSString *)score andDiscount:(NSString *)discount
{
    NSMutableString *moneyStr = [[NSMutableString alloc] initWithCapacity:20];
    
    if (price.length <= 0 ||[price floatValue] <= 0) //工贝
    {
        self.moneyCoinImageView.hidden = YES;
    }
    else
    {
        [moneyStr appendString:price];
        self.moneyCoinImageView.hidden = NO;
    }
    
    if (score.length > 0 && [score floatValue] >= 0)//人民币
    {
        
        if (price.length <= 0 || [price floatValue] <= 0) {
            
            [moneyStr appendFormat:@"¥%@",score];
        }
        else
        {
            [moneyStr appendFormat:@"+¥%@",score];
        }
    }
    
    
    self.shopValue.text = moneyStr;
    [self.shopValue sizeToFit];
    
    if (!self.moneyCoinImageView.hidden) {
        CGFloat textWidth = self.shopValue.frame.size.width;
        if (textWidth + 10 > CGRectGetWidth(self.frame))
        {
//            self.moneyCoinImageView.frame = CGRectMake(0, CGRectGetMinY(self.moneyCoinImageView.frame), 10, 10);
            self.moneyCoinImageView.frame = CGRectMake(0, self.shopValue.center.y - 5, 10, 10);

            self.shopValue.frame = CGRectMake(CGRectGetMaxX(self.moneyCoinImageView.frame), CGRectGetMinY(self.shopValue.frame), CGRectGetWidth(self.frame) -10, CGRectGetHeight(self.shopValue.frame));
        }
        else
        {
            CGFloat xPos = (CGRectGetWidth(self.frame) - (textWidth + 10))/2;
//            self.moneyCoinImageView.frame = CGRectMake(xPos, CGRectGetMinY(self.moneyCoinImageView.frame), 10, 10);
            self.moneyCoinImageView.frame = CGRectMake(xPos, self.shopValue.center.y - 5, 10, 10);

            self.shopValue.frame = CGRectMake(CGRectGetMaxX(self.moneyCoinImageView.frame), CGRectGetMinY(self.shopValue.frame), textWidth, CGRectGetHeight(self.shopValue.frame));
        }
    }
    if (discount.length > 0) {
        self.discountLab.text = [NSString stringWithFormat:@"%@折",discount];
        self.discountLab.superview.hidden = NO;
    } else {
        self.discountLab.superview.hidden = YES;
    }
}
@end
