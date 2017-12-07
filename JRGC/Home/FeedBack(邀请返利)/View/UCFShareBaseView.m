//
//  UCFShareBaseView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/29.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFShareBaseView.h"
@interface UCFShareBaseView()

- (IBAction)gotoShareLinkBtn:(id)sender;
- (IBAction)gotoSharePictureBtn:(id)sender;
@end

@implementation UCFShareBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)gotoShareLinkBtn:(id)sender
{
    if ([self.deleagate respondsToSelector:@selector(gotoShareLinkBtn)]) {
        [self.deleagate gotoShareLinkBtn];
    }
}

- (IBAction)gotoSharePictureBtn:(id)sender
{
    if ([self.deleagate respondsToSelector:@selector(gotoSharePictureBtn)])
    {
        [self.deleagate gotoSharePictureBtn];
    }
}
@end
