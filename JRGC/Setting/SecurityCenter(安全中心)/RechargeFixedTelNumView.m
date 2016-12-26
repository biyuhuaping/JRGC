//
//  RechargeFixedTelNumView.m
//  JRGC
//
//  Created by AppGroup on 16/9/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "RechargeFixedTelNumView.h"
@interface RechargeFixedTelNumView()

@property (weak, nonatomic) IBOutlet UIView *topBaseView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
- (IBAction)closeView:(id)sender;

@end
@implementation RechargeFixedTelNumView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    self.backgroundColor = [UIColor clearColor];
    _topBaseView.layer.cornerRadius = 4.0f;
    
    
    _topLabel.textColor = UIColorWithRGB(0x333333);
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)closeView:(id)sender {
    
    
}
@end
