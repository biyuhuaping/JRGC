//
//  UCFGoldAccountHeadView.h
//  JRGC
//
//  Created by 金融工场 on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

@protocol UCFGoldAccountHeadViewDelegate <NSObject>

- (void)notiAccountCenterUpdate;

@end

#import <UIKit/UIKit.h>

@interface UCFGoldAccountHeadView : UIView
@property(nonatomic, assign)id<UCFGoldAccountHeadViewDelegate> deleage;
//更新黄金账户UI
- (void)updateGoldAccount:(NSDictionary *)dataDic;
@end
