//
//  UCFP2POrHornerTabHeaderView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFP2POrHornerTabHeaderView.h"

@interface UCFP2POrHornerTabHeaderView ()
- (IBAction)CilckShowOrHideAccoutMoney:(UIButton *)sender;
- (IBAction)checkP2POrHonerAccout:(id)sender;

@end

@implementation UCFP2POrHornerTabHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)CilckShowOrHideAccoutMoney:(UIButton *)sender {
    [self.delegate cilckShowOrHideAccoutMoney:sender];
}
- (IBAction)checkP2POrHonerAccout:(id)sender {
    [self.delegate checkP2POrHonerAccout];
}
@end
