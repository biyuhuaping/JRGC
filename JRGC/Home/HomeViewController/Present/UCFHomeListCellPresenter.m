//
//  UCFHomeListCellPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListCellPresenter.h"

#define CELLRATE (600/180)

@interface UCFHomeListCellPresenter ()
@property (strong, nonatomic) UCFHomeListCellModel *item;
@end

@implementation UCFHomeListCellPresenter
+ (instancetype)presenterWithItem:(UCFHomeListCellModel *)item {//懒
    UCFHomeListCellPresenter *presenter = [UCFHomeListCellPresenter new];
    presenter.item = item;
    return presenter;
}

- (NSString *)proTitle
{
    return self.item.prdName;
}

- (UCFHomeListCellModelType)modelType
{
    return self.item.moedelType ? self.item.moedelType : UCFHomeListCellModelTypeDefault;
}

- (NSString *)type
{
    return self.item.type ? self.item.type : @"";
}

- (CGFloat)cellHeight
{
    if (self.item.moedelType == UCFHomeListCellModelTypeDefault) {
        return 100.0;
    }
    else if (self.item.moedelType == UCFHomeListCellModelTypeOneImageBatchLending || self.item.moedelType == UCFHomeListCellModelTypeOneImageHonorTransfer || self.item.moedelType == UCFHomeListCellModelTypeOneImageBondTransfer || self.item.moedelType == UCFHomeListCellModelTypeOneImageBatchCycle) {
        return (ScreenWidth - 20) / CELLRATE + 20;
    }
    return 0;
}
@end
