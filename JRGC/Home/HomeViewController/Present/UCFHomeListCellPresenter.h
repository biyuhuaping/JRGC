//
//  UCFHomeListCellPresenter.h
//  JRGC
//
//  Created by njw on 2017/5/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeListCellModel.h"

@interface UCFHomeListCellPresenter : NSObject
+ (instancetype)presenterWithItem:(UCFHomeListCellModel *)item;

- (UCFHomeListCellModel *)item;

- (NSString *)proTitle;
- (UCFHomeListCellModelType)modelType;
- (NSString *)type;

- (CGFloat)cellHeight;
@end
