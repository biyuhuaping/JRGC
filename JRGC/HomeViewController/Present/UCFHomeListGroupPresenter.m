//
//  UCFHomeListGroupPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListGroupPresenter.h"

@interface UCFHomeListGroupPresenter ()
@property (strong, nonatomic) UCFHomeListGroup *group;
@end

@implementation UCFHomeListGroupPresenter
+ (instancetype)presenterWithGroup:(UCFHomeListGroup *)group {//懒
    UCFHomeListGroupPresenter *presenter = [UCFHomeListGroupPresenter new];
    presenter.group = group;
    return presenter;
}

#pragma mark - Format

- (NSString *)headerTitle {
    return self.group.headTitle.length > 0 ? self.group.headTitle : @"";
}

- (NSString *)footerTitle {
    return self.group.footerTitle.length > 0 ? self.group.footerTitle : @"";
}

- (UIImage *)headerImage {
    return [UIImage imageNamed:self.group.headerImage];
}

- (BOOL)showMore {
    return self.group.showMore;
}
@end
