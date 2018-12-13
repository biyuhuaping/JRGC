//
//  UCFRemindFlowView.m
//  JRGC
//
//  Created by zrc on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFRemindFlowView.h"
@interface UCFRemindFlowView()

@end
@implementation UCFRemindFlowView
- (instancetype)init
{
    if (self = [super init]) {


    }
    return self;
}

- (void)reloadViewContentWithTextArr:(NSArray *)textArr
{
    
    for (NSString *showStr in textArr) {
        [self createTagButton:showStr];
    }
    [self layoutAnimationWithDuration:0];
    self.leftPadding = 15.0f;
    self.topPadding = 12.0f;
    self.rightPadding = 15.0f;
    

}
- (void)createTagButton:(NSString *)text
{
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    [tagButton setTitleColor:UIColorWithRGB(0x5b7aa4) forState:UIControlStateNormal];
    tagButton.layer.borderWidth = 1;
    tagButton.layer.cornerRadius = 2.0;
    tagButton.titleLabel.font = [UIFont systemFontOfSize:12];
    tagButton.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    tagButton.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    //这里可以看到尺寸宽度等于自己的尺寸宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
    //如果没有这个设置，而是直接调用了sizeToFit则按钮的宽度就是内容的宽度。
    tagButton.widthSize.equalTo(tagButton.widthSize).add(10);
    tagButton.heightSize.equalTo(tagButton.heightSize).add(4).max(14); //高度根据自身的内容再增加10
    [tagButton sizeToFit];
    [self addSubview:tagButton];
}

@end
