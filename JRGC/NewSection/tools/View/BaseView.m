//
//  BaseView.m
//  JIMEITicket
//
//  Created by kuangzhanzhidian on 2018/5/23.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootLayout = [MyRelativeLayout new];
        //        self.rootLayout.backgroundColor = [UIColor whiteColor];
        //        self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        self.rootLayout.widthSize.equalTo(@(frame.size.width));
        self.rootLayout.heightSize.equalTo(@(frame.size.height));
        [self addSubview: self.rootLayout];
    }
    return self;
}
@end
