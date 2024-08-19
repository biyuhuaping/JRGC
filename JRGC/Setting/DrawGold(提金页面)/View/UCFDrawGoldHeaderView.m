//
//  UCFDrawGoldHeaderView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFDrawGoldHeaderView.h"
@interface UCFDrawGoldHeaderView()
- (IBAction)clickGoldGoodsDetail:(id)sender;
@end

@implementation UCFDrawGoldHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clickGoldGoodsDetail:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clickGoldGoodsDetail)]) {
        [self.delegate clickGoldGoodsDetail];
    }
}
@end
