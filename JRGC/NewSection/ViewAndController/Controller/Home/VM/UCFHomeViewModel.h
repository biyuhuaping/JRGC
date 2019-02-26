//
//  UCFHomeViewModel.h
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCFHomeListRequest.h"
#import "UCFUserAllStatueRequest.h"
#import "CellConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFHomeViewModel : NSObject

@property(nonatomic, weak)UIView    *loaingSuperView;

@property(nonatomic, strong)NSArray *modelListArray;

@property(nonatomic, strong)NSArray *imagesArr;

@property(nonatomic, copy)  NSString    *siteNoticeStr;

@property(nonatomic, weak) UIViewController *rootViewController;

- (void)fetchNetData;

- (void)cycleViewSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
