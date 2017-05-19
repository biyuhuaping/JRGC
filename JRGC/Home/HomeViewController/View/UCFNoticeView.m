//
//  UCFNoticeView.m
//  JRGC
//
//  Created by njw on 2017/5/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFNoticeView.h"

@interface UCFNoticeView ()

@end

@implementation UCFNoticeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (IBAction)noticeClose:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowNotice"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([self.delegate respondsToSelector:@selector(noticeView:didClickedCloseButton:)]) {
        [self.delegate noticeView:self didClickedCloseButton:sender];
    }
}


@end
