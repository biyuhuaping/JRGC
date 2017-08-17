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
    return self.group.title.length > 0 ? self.group.title : @"";
}

- (NSString *)footerTitle {
    return self.group.footerTitle.length > 0 ? self.group.footerTitle : @"";
}

- (NSString *)iconUrl {
    return self.group.iconUrl.length > 0 ? self.group.iconUrl : @"";
}

- (BOOL)showMore {
    return self.group.showMore;
}

- (int)type {
    return  [self.group.type intValue];
}

- (NSString *)desc {
    return self.group.desc;
}
@end
