//
//  UCFNewBannerModel.h
//  JRGC
//
//  Created by zrc on 2019/1/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class Data,Sitenoticemap,Giftbanner,Banner;
@interface UCFNewBannerModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) Data *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface Data : BaseModel

@property (nonatomic, strong) NSArray *giftBanner;

@property (nonatomic, strong) NSArray *banner;

@property (nonatomic, strong) Sitenoticemap *siteNoticeMap;

@end

@interface Sitenoticemap : BaseModel

@property (nonatomic, copy) NSString *noticeUrl;

@property (nonatomic, copy) NSString *siteNotice;

@end

@interface Giftbanner : BaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *activityType;

@property (nonatomic, copy) NSString *switchFlag;

@end

@interface Banner : BaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *thumb;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *activityType;

@property (nonatomic, copy) NSString *switchFlag;

@end


NS_ASSUME_NONNULL_END




