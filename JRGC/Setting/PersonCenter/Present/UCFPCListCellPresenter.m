//
//  UCFPCListCellPresenter.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPCListCellPresenter.h"

@interface UCFPCListCellPresenter ()
@property (strong, nonatomic) UCFPCListModel *item;
@end

@implementation UCFPCListCellPresenter
+ (instancetype)presenterWithItem:(UCFPCListModel *)item {//懒
    UCFPCListCellPresenter *presenter = [UCFPCListCellPresenter new];
    presenter.item = item;
    return presenter;
}


#pragma mark - Format

- (NSString *)itemTitle
{
    return self.item.title.length > 0 ? self.item.title : @"";
}
- (NSString *)itemSubtitle
{
    return self.item.subtitle.length > 0 ? self.item.subtitle : @"";
}
- (NSString *)itemDescribe
{
    return self.item.describeWord.length > 0 ? self.item.describeWord : @"";
}
- (NSString *)itemIcon {
    return self.item.icon;
}

@end
