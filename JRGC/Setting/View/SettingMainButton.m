//
//  SettingMainButton.m
//  JRGC
//
//  Created by NJW on 15/4/14.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "SettingMainButton.h"

@implementation SettingMainButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SettingMainButton" owner:self options:nil] lastObject];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.customTitleLabel.highlightedTextColor = [UIColor grayColor];
    self.warnPoint.layer.cornerRadius = self.warnPoint.frame.size.height/2;
    self.warnPoint.clipsToBounds = YES;
    self.warnPoint.hidden = YES;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.customImageView.highlighted = YES;
    self.customTitleLabel.highlighted = YES;
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.customImageView.highlighted = NO;
    self.customTitleLabel.highlighted = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
