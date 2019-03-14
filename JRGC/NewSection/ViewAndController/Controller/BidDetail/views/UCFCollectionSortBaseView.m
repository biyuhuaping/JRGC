//
//  UCFCollectionSortBaseView.m
//  JRGC
//
//  Created by zrc on 2019/3/14.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFCollectionSortBaseView.h"

@implementation UCFCollectionSortBaseView


- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.leftPos.equalTo(@20);
        label.text = @"项目列表";
        label.textColor = [Color color:PGColorOptionTitleBlack];
        label.font = [Color gc_Font:16];
        label.centerYPos.equalTo(self.centerYPos);
        [label sizeToFit];
        [self addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"排序" forState:UIControlStateNormal];
        [button setTitleColor:[Color color:PGColorOptionCellContentBlue] forState:UIControlStateNormal];
        button.titleLabel.font = [Color gc_Font:16];
        button.rightPos.equalTo(@20);
        button.heightSize.equalTo(@45);
        button.widthSize.equalTo(@44);
        button.centerYPos.equalTo(label.centerYPos);
        [self addSubview:button];
        self.sortButton = button;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
