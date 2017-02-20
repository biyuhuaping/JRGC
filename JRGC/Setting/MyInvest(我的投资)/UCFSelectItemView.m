//
//  UCFSelectItemView.m
//  JRGC
//
//  Created by njw on 2017/2/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFSelectItemView.h"

@interface UCFSelectItemView ()
@property (nonatomic, strong) NSMutableArray *butArray;
@property (nonatomic, weak) UIView *signView;
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation UCFSelectItemView

- (NSMutableArray *)butArray
{
    if (!_butArray) {
        _butArray = [NSMutableArray array];
    }
    return _butArray;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.butArray addObject:btn];
        }
        else {
            self.signView = view;
        }
    }
    UIButton *firstBtn = [self.butArray firstObject];
    self.selectedButton = firstBtn;
    firstBtn.selected = YES;
}

- (void)btnClicked:(UIButton *)sender
{
    NSUInteger index = sender.tag - 110;
    CGRect frame = self.signView.frame;
    CGFloat offSet = ScreenWidth /3;
    frame.origin.x = index * offSet;
    [UIView animateWithDuration:0.25 animations:^{
        [self.signView setFrame:frame];
    }];
    if ([self.delegate respondsToSelector:@selector(selectItemView:selectedButton:)]) {
        [self.delegate selectItemView:self selectedButton:sender];
    }
    
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
}

@end
