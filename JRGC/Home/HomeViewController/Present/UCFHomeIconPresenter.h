//
//  UCFHomeIconPresenter.h
//  JRGC
//
//  Created by njw on 2017/9/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UCFHomeIconModel;
@interface UCFHomeIconPresenter : NSObject
+ (instancetype)presenterWithItem:(UCFHomeIconModel *)item;

- (NSString *)description;
- (NSString *)icon;
- (NSString *)productName;
- (NSString *)productNum;
- (int)type;
- (NSString *)url;
@end
