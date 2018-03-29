//
//  UCFMineFuncView.h
//  JRGC
//
//  Created by njw on 2017/12/21.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFMineFuncView, UCFUserBenefitModel;
@protocol UCFMineFuncViewDelegate <NSObject>
- (void)mineFuncView:(UCFMineFuncView *)funcView didClickItemWithTitle:(NSString *)title;
@end

@interface UCFMineFuncView : UIView
@property (strong, nonatomic) UCFUserBenefitModel *benefit;
@property (weak, nonatomic) id<UCFMineFuncViewDelegate> delegate;
- (CGFloat)height;
- (void)clearData;
@end
