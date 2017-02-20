//
//  UCFSelectItemView.h
//  JRGC
//
//  Created by njw on 2017/2/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFSelectItemView;
@protocol UCFSelectItemViewDelegate <NSObject>
@optional;
- (void)selectItemView:(UCFSelectItemView *)selectItemView selectedButton:(UIButton *)button;

@end

@interface UCFSelectItemView : UIView
@property (nonatomic,weak) id<UCFSelectItemViewDelegate> delegate;
@end
