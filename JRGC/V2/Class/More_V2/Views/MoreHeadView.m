//
//  MoreHeadView.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "MoreHeadView.h"

@interface MoreHeadView()
@property(nonatomic, strong)MoreViewModel *vm;
@end

@implementation MoreHeadView

+ (MoreHeadView *)getView
{
    MoreHeadView * headView = (MoreHeadView *)[[[NSBundle mainBundle] loadNibNamed:@"MoreHeadView" owner:self options:nil] firstObject];
    return headView;
}
- (void)blindViewModel:(MoreViewModel *)viewModel
{
    self.vm = viewModel;
}
- (IBAction)praiseButtonClick:(UIButton *)sender {
    [self.vm vmPraiseButtonClick:sender];
}
- (IBAction)feedBackButtonClick:(UIButton *)sender {
    [self.vm vmFeedBackButtonClick:sender];
}

@end
