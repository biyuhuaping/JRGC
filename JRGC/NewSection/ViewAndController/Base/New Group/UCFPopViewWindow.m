//
//  UCFPopViewWindow.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPopViewWindow.h"

@implementation UCFPopViewWindow
- (void)startPopView
{
    [UCFPublicPopupWindowView loadPopupWindowWithType:self.type withContent:self.contentStr withTitle:self.titletStr withInController:self.controller withDelegate:self.delegate withPopViewTag:self.popViewTag];
}
@end
