//
//  UCFHomeIconPresenter.m
//  JRGC
//
//  Created by njw on 2017/9/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeIconPresenter.h"
#import "UCFHomeIconModel.h"

@interface UCFHomeIconPresenter ()
@property (strong, nonatomic) UCFHomeIconModel *item;
@end

@implementation UCFHomeIconPresenter
+ (instancetype)presenterWithItem:(UCFHomeIconModel *)item {//懒
    UCFHomeIconPresenter *presenter = [UCFHomeIconPresenter new];
    presenter.item = item;
    return presenter;
}

- (NSString *)description
{
    return self.item.description.length > 0 ? self.item.description : @"";
}

- (NSString *)icon {
    return self.item.icon.length > 0 ? self.item.icon : @"";
}

- (NSString *)productName {
    return self.item.productName.length > 0 ? self.item.productName : @"";
}

- (NSString *)productNum {
    return self.item.productNum.length > 0 ? self.item.productNum : @"";
}

- (int)type {
    return self.item.type.intValue;
}

- (NSString *)url {
    return self.item.url.length > 0 ? self.item.url : @"";
}

@end
