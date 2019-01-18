//
//  UCFBannerViewModel.h
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"
#import "UCFNewBannerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFBannerViewModel : BaseViewModel
- (void)fetchNetData;
@property(nonatomic, strong)NSArray     *imagesArr;
@property(nonatomic, copy)  NSString    *siteNoticeStr;
@property(nonatomic, copy)  NSString    *giftimageUrl;
@property(nonatomic, weak)  UIViewController *rootViewController;
@property(nonatomic, strong) UCFNewBannerModel  *model;

- (void)cycleViewSelectIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
