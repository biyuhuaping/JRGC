//
//  UCFTelAlertView.h
//  JRGC
//
//  Created by zrc on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UCFTelAlertView : UIView
- (instancetype)initWithNotiMessage:(NSString *)message;
- (void)show;
@end

NS_ASSUME_NONNULL_END
