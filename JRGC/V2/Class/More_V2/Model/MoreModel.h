//
//  MoreModel.h
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreModel : NSObject
- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle ShowAccess:(BOOL)access TargetClassName:(NSString *)name;
@end
