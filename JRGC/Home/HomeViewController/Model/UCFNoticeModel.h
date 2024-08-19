//
//  UCFNoticeModel.h
//  JRGC
//
//  Created by njw on 2017/10/9.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFNoticeModel : NSObject
@property (nonatomic, copy) NSString * noticeUrl;
@property (nonatomic, copy) NSString * siteNotice;

+ (instancetype)noticeWithDict:(NSDictionary *)dict;
@end
