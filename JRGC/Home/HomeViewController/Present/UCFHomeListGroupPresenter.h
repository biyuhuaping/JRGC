//
//  UCFHomeListGroupPresenter.h
//  JRGC
//
//  Created by njw on 2017/5/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeListGroup.h"

@interface UCFHomeListGroupPresenter : NSObject
+ (instancetype)presenterWithGroup:(UCFHomeListGroup *)group;
- (UCFHomeListGroup *)group;

- (NSString *)headerTitle;
- (NSString *)footerTitle;
- (NSString *)iconUrl;
- (BOOL)showMore;
- (int)type;
- (NSString *)desc;
- (NSArray *)attach;
@end
