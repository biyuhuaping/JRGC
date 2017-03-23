//
//  UCFPCListCellPresenter.h
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UCFPCListModel.h"

@interface UCFPCListCellPresenter : NSObject
+ (instancetype)presenterWithItem:(UCFPCListModel *)item;

- (UCFPCListModel *)item;

- (NSString *)itemTitle;
- (NSString *)itemSubtitle;
- (NSString *)itemDescribe;
- (NSString *)itemIcon;
//- (NSIndexPath *)indexPath;
@end
