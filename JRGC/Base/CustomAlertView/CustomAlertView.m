//
//  CustomAlertView.m
//  JRGC
//
//  Created by 张瑞超 on 14-11-17.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "CustomAlertView.h"
#import "AppDelegate.h"
@implementation CustomAlertView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame WithTitleString:(NSString *)title WithTips:(NSString *)tips WithIntroduceStr:(NSString *)introduceStr WithClickBtn:(NSArray *)btnArr WithDelegate:(id <CustomAlerViewDelegate>)delegate1
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate1;
        UILabel *headViewLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)] autorelease];
        headViewLabel.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        headViewLabel.font = [UIFont boldSystemFontOfSize:16];
        headViewLabel.text = [NSString stringWithFormat:@"    %@",title];
        [self addSubview:headViewLabel];
        
        UIImageView *logoView = [[[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 20, 20)] autorelease];
        logoView.image = [UIImage imageNamed:@"getCarSucess.png"];
        [self addSubview:logoView];
        
        UILabel *tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoView.frame) +5, 50, 18 * 7, 18)] autorelease];
        tipLabel.font = [UIFont systemFontOfSize:18];
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.text = tips;
        tipLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tipLabel];
        
        UILabel *introdLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 10, self.frame.size.width -20, 40)] autorelease];
        introdLabel.textColor =UIColorWithRGB(0x777777);
        CGSize size = [introduceStr sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(introdLabel.frame.size.width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        introdLabel.frame = CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 10, self.frame.size.width -20, size.height);
        introdLabel.numberOfLines = 0;
        introdLabel.font = [UIFont systemFontOfSize:15];
        introdLabel.backgroundColor = [UIColor clearColor];
        introdLabel.text = introduceStr;
        [self addSubview:introdLabel];
        
        NSInteger btnCount = btnArr.count;
        CGFloat btnWidth = ((self.frame.size.width - 20 - (btnCount - 1) * 20 )/btnCount);
        for (int i = 0; i<btnCount; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+(btnWidth+20) * i , CGRectGetMaxY(introdLabel.frame) +15, btnWidth, 35);
            btn.backgroundColor =UIColorWithRGB(0xf03b43);
            [btn setTitle:[btnArr objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            btn.tag = 100 + i;
            btn.layer.cornerRadius = 5;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(customViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(introdLabel.frame) +65);
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame WithTitleString:(NSString *)title WithTips:(NSString *)tips WithTipImage:(NSString *)imageStr WithIntroduceStr:(NSString *)introduceStr WithClickBtn:(NSArray *)btnArr WithDelegate:(id <CustomAlerViewDelegate>)delegate1
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate1;
        UILabel *headViewLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)] autorelease];
        headViewLabel.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        headViewLabel.font = [UIFont boldSystemFontOfSize:16];
        headViewLabel.text = [NSString stringWithFormat:@"    %@",title];
        headViewLabel.layer.masksToBounds = YES;
        headViewLabel.layer.cornerRadius = 5;
        [self addSubview:headViewLabel];
        
        UIImageView *logoView = [[[UIImageView alloc] initWithFrame:CGRectMake(60, 50, 20, 20)] autorelease];
        logoView.image = [UIImage imageNamed:imageStr];
        [self addSubview:logoView];
        
        UILabel *tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoView.frame) +5, 50, tips.length * 18, 18)] autorelease];
        tipLabel.font = [UIFont systemFontOfSize:18];
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.text = tips;
        tipLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:tipLabel];
        
        CGFloat totalLength = tips.length * 18 + 25;
        
        logoView.frame = CGRectMake((self.frame.size.width - totalLength)/2, 50, 20, 20);
        tipLabel.frame = CGRectMake(CGRectGetMaxX(logoView.frame) +5, 50, tips.length * 18, 18);
        
        UILabel *introdLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 10, self.frame.size.width -20, 40)] autorelease];
        introdLabel.textColor = UIColorWithRGB(0x777777);
        CGSize size = [introduceStr sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(introdLabel.frame.size.width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        introdLabel.frame = CGRectMake(10, CGRectGetMaxY(tipLabel.frame) + 10, self.frame.size.width -20, size.height);
        introdLabel.numberOfLines = 0;
        introdLabel.font = [UIFont systemFontOfSize:15];
        introdLabel.backgroundColor = [UIColor clearColor];
        introdLabel.text = introduceStr;
        [self addSubview:introdLabel];
        
        NSInteger btnCount = btnArr.count;
        CGFloat btnWidth = ((self.frame.size.width - 20 - (btnCount - 1) * 20 )/btnCount);
        for (int i = 0; i<btnCount; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+(btnWidth+20) * i , CGRectGetMaxY(introdLabel.frame) +15, btnWidth, 35);
            btn.backgroundColor = UIColorWithRGB(0xf03b43);
            [btn setTitle:[btnArr objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            btn.tag = 100 + i;
            //            [btn setTitleColor:[UIColor colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 5;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(customViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(introdLabel.frame) +65);
        self.layer.cornerRadius = 5;
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame WithHeadString:(NSString *)title WithTipString:(NSString *)string WithIntroduceStr:(NSString *)introduceStr WithNetIntroduce:(BOOL)netIntroduce WithFunctionBtnsTitle:(NSArray *)btnTitleArr WithDelegate:(id <CustomAlerViewDelegate>)delegate1
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate1;
        UILabel *headViewLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)] autorelease];
        headViewLabel.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
        headViewLabel.font = [UIFont boldSystemFontOfSize:16];
        headViewLabel.text = [NSString stringWithFormat:@"%@",title];
        headViewLabel.layer.masksToBounds = YES;
        
        headViewLabel.textColor = UIColorWithRGB(0xf03b43);;
        headViewLabel.textAlignment = NSTextAlignmentCenter;
        headViewLabel.layer.cornerRadius = 5;
        headViewLabel.tag = 333;
        [self addSubview:headViewLabel];
        
        UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headViewLabel.frame), self.frame.size.width, 0.5)]autorelease];
        lineView.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:218.0/255.0 alpha:1];
        [self addSubview:lineView];
        CGFloat height = CGRectGetMaxY(lineView.frame);
        if (string.length>0) {
            UILabel *tipLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) + 5, self.frame.size.width, 20)] autorelease];
            tipLabel.font = [UIFont systemFontOfSize:17];
            tipLabel.textColor = UIColorWithRGB(0xf03b43);
            tipLabel.text = string;
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:tipLabel];
            height += 20;
        }
        height += 10;
        
        UILabel *introdLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,height , self.frame.size.width -20, 40)] autorelease];
        introdLabel.textColor = UIColorWithRGB(0x777777);
        introduceStr = [introduceStr stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        CGSize size = [introduceStr sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(introdLabel.frame.size.width, 9999) lineBreakMode:NSLineBreakByWordWrapping];
        introdLabel.frame = CGRectMake(10, height, self.frame.size.width -20, size.height);
        introdLabel.numberOfLines = 0;
        if (!netIntroduce) {
            introdLabel.textAlignment = NSTextAlignmentCenter;
        }
        introdLabel.font = [UIFont systemFontOfSize:15];
        introdLabel.backgroundColor = [UIColor clearColor];
        introdLabel.text = introduceStr;
        [self addSubview:introdLabel];
        
        NSInteger btnCount = btnTitleArr.count;
        CGFloat btnWidth = ((self.frame.size.width - 20 - (btnCount - 1) * 20 )/btnCount);
        for (int i = 0; i<btnCount; i++) {
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10+(btnWidth+20) * i , CGRectGetMaxY(introdLabel.frame) +15, btnWidth, 35);
            [btn setTitle:[btnTitleArr objectAtIndex:i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            btn.tag = 100 + i;
            btn.layer.cornerRadius = 5;
            [btn addTarget:self action:@selector(customViewClick01:) forControlEvents:UIControlEventTouchUpInside];
            if (i==0) {
                if (btnCount == 1) {
                    btn.backgroundColor = UIColorWithRGB(0xf03b43);
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    btn.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:213.0/255.0 blue:215.0/255.0 alpha:1];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }else{
                btn.backgroundColor = UIColorWithRGB(0xf03b43);
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            }
            [self addSubview:btn];
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(introdLabel.frame) +65);
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)show
{
    blackBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    blackBtnView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    blackBtnView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [blackBtnView addSubview:self];
    AppDelegate * app  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:blackBtnView];
    [app.window bringSubviewToFront:blackBtnView];
    self.center = blackBtnView.center;
}
- (void)customViewClick:(UIButton *)btn
{
    if (delegate && [delegate respondsToSelector:@selector(customViewCliced:WithClickedIndex:)]) {
        [delegate customViewCliced:self WithClickedIndex:btn.tag -100];
    }
}
- (void)customViewClick01:(UIButton *)btn
{
    if (delegate && [delegate respondsToSelector:@selector(customViewCliced:WithClickedIndex:)]) {
        [delegate customViewCliced:self WithClickedIndex:btn.tag -100];
    }
    [blackBtnView removeFromSuperview];
    blackBtnView = nil;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
