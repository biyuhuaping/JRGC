//
//  UCFHomeListCellPresenter.m
//  JRGC
//
//  Created by njw on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListCellPresenter.h"
#import "UCFHomeListCellModel.h"

@interface UCFHomeListCellPresenter ()
@property (strong, nonatomic) UCFHomeListCellModel *item;
@end

@implementation UCFHomeListCellPresenter
+ (instancetype)presenterWithItem:(UCFHomeListCellModel *)item {//懒
    UCFHomeListCellPresenter *presenter = [UCFHomeListCellPresenter new];
    presenter.item = item;
    return presenter;
}
@end
