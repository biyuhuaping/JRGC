//
//  UCFInvestmentCouponInstructionsView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/27.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFInvestmentCouponInstructionsView.h"
@interface UCFInvestmentCouponInstructionsView()
@property (nonatomic, strong) UILabel *instructionsLabel;
@end
@implementation UCFInvestmentCouponInstructionsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self.rootLayout addSubview:self.instructionsLabel];
    }
    return self;
}
- (UILabel *)instructionsLabel
{
    if (nil == _instructionsLabel) {
        _instructionsLabel = [UILabel new];
        _instructionsLabel.leftPos.equalTo(@15);
        _instructionsLabel.rightPos.equalTo(@15);
        _instructionsLabel.topPos.equalTo(@10);
        _instructionsLabel.bottomPos.equalTo(@0);
        _instructionsLabel.textAlignment = NSTextAlignmentCenter;
        _instructionsLabel.font = [UIFont systemFontOfSize:12.0];
        _instructionsLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _instructionsLabel.text =@"出借按月/季等额还款项目，最终返息获得工豆需要乘以0.56。0.56为借款方占用出借方自己的使用率";
        _instructionsLabel.numberOfLines = 0;//表示label可以多行显示
        _instructionsLabel.lineBreakMode = NSLineBreakByCharWrapping ;//换行模式，与上面的计算保持一致。
        [_instructionsLabel sizeToFit];
    }
    return _instructionsLabel;
}
@end
