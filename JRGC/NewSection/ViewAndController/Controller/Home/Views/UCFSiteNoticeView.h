//
//  UCFSiteNoticeView.h
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//
@class UCFSiteNoticeView;
@protocol UCFSiteNoticeViewDelegate <NSObject>

- (void)noticeSiteClick;

@end

#import "BaseView.h"


NS_ASSUME_NONNULL_BEGIN

@interface UCFSiteNoticeView : MyRelativeLayout
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, weak)id<UCFSiteNoticeViewDelegate>deleage;
@end

NS_ASSUME_NONNULL_END
