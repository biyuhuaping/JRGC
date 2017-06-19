//
//  UCFLoadingView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFLoadingView.h"
@interface UCFLoadingView()
@property (strong, nonatomic) IBOutlet UILabel *loadingLabel1;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel2;

@end

@implementation UCFLoadingView

-(void)setAccoutType:(SelectAccoutType)accoutType{
    _accoutType =accoutType;
    self.loadingLabel1.text = accoutType == SelectAccoutTypeHoner ? @"即将跳转工场尊享":@"即将跳转工场微金";
    self.loadingLabel2.text = accoutType == SelectAccoutTypeHoner ? @"可直接访问www.gongchangzx.com":@"可直接访问www.gongchangp2p.cn";
}
-(void)removeLoadingView
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
