//
//  UCFShareBaseView.h
//  JRGC
//
//  Created by hanqiyuan on 2017/11/29.
//  Copyright © 2017年 JRGC. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol UCFShareBaseViewDelegate <NSObject>

- (void)gotoShareLinkBtn;
- (void)gotoSharePictureBtn;
@end


@interface UCFShareBaseView : UIView

@property (nonatomic,assign) id<UCFShareBaseViewDelegate> deleagate;

@end
