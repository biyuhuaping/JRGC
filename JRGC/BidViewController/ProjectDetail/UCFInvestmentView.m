//
//  UCFInvestmentView.m
//  JRGC
//
//  Created by MAC on 14-9-20.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "UCFInvestmentView.h"
#import "AppDelegate.h"
@interface UCFInvestmentView ()
{
    NSString *_investmentState;
    NSString *_sourceVc;
}

@end

@implementation UCFInvestmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame target:(id) aTaget action:(SEL) action investmentState:(NSString*)state  souceVc:(NSString*)source isP2P:(BOOL)isP2P
{
    self = [self initWithFrame:frame];
    if(self)
    {
         _investmentState = [NSString stringWithFormat:@"%@",state];
        _sourceVc = source;
        self.backgroundColor = [UIColor clearColor];
        UIView *bkView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 57)];
        bkView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bkView];
        
        UIButton *investmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        investmentButton.frame = CGRectMake(XPOS, 20,ScreenWidth - XPOS*2, 37);
        investmentButton.titleLabel.font = [UIFont systemFontOfSize:16];
        investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
        investmentButton.layer.cornerRadius = 2.0;
        investmentButton.layer.masksToBounds = YES;
        [investmentButton addTarget:aTaget action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:investmentButton];
        
        UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 10)];
        UIImage *tabImag = [UIImage imageNamed:@"tabbar_shadow.png"];
        shadowView.tag = TABIMAGEVIEWTAG;
        shadowView.image = [tabImag resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeStretch];
        [self addSubview:shadowView];
        
        investmentButton.backgroundColor = UIColorWithRGB(0xd4d4d4);
        [investmentButton setUserInteractionEnabled:NO];
        
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"bidStatus"] isEqualToString:@""] && [[NSUserDefaults standardUserDefaults] valueForKey:@"bidStatus"]) {
            if ([_sourceVc isEqualToString:@"investmentDetail"]) {
                _investmentState = [[NSUserDefaults standardUserDefaults] valueForKey:@"bidStatus"];
                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"bidStatus"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        if ([_investmentState isEqualToString:@"2"] || [_investmentState isEqualToString:@"11"]) {
            if ([_sourceVc isEqualToString:@"investmentDetail"]) {
                [investmentButton setTitle:@"招标中" forState:UIControlStateNormal];
            } else {
                
                if ([_sourceVc isEqualToString:@"transiBid"]) {
        
                    NSString *buttonTitle = isP2P ? @"立即出借":@"立即购买";
                    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (app.isSubmitAppStoreTestTime)
                    {
                        buttonTitle = @"立即购买";
                    }
                    [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
                }else {
                    NSString *buttonTitle = isP2P ? @"立即出借":@"立即认购";
                    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (app.isSubmitAppStoreTestTime)
                    {
                        buttonTitle = isP2P ? @"立即购买":@"立即认购";
                    }
                    [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
                }
                investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
                [investmentButton setUserInteractionEnabled:YES];
            }
        } else if ([_investmentState isEqualToString:@"5"]) {
            [investmentButton setTitle:@"回款中" forState:UIControlStateNormal];
            
        } else if ([_investmentState isEqualToString:@"6"]) {
            [investmentButton setTitle:@"已回款" forState:UIControlStateNormal];

        } else if ([_investmentState isEqualToString:@"0"]) {
            [investmentButton setTitle:@"待回款" forState:UIControlStateNormal];

        } else if ([_investmentState isEqualToString:@"1"]) {
            [investmentButton setTitle:@"等待确认" forState:UIControlStateNormal];

        } else if ([_investmentState isEqualToString:@"3"]) {
            [investmentButton setTitle:@"流标" forState:UIControlStateNormal];

        } else if ([_investmentState isEqualToString:@"4"]) {
            [investmentButton setTitle:@"满标" forState:UIControlStateNormal];

        } else {
            if ([_sourceVc isEqualToString:@"transiBid"]) {
                NSString *buttonTitle = isP2P ? @"立即出借":@"立即购买";
                [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
            }else {
                NSString *buttonTitle = isP2P ? @"立即出借":@"立即认购";
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (app.isSubmitAppStoreTestTime)
                {
                    buttonTitle = isP2P ? @"立即购买":@"立即认购";
                }
                [investmentButton setTitle:buttonTitle forState:UIControlStateNormal];
            }
        }
        
//        if ([_investmentState isEqualToString:@"2"] || [_investmentState isEqualToString:@"11"]) {
//            investmentButton.backgroundColor = UIColorWithRGB(0xfd4d4c);
//            [investmentButton setUserInteractionEnabled:YES];
//        } else {
//            investmentButton.backgroundColor = UIColorWithRGB(0xd4d4d4);
//            [investmentButton setUserInteractionEnabled:NO];
//        }
    }
    return self;
}

@end
