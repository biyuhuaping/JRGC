//
//  UCFNoticeView.h
//  JRGC
//
//  Created by njw on 2017/5/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFNoticeView;
@protocol UCFNoticeViewDelegate <NSObject>

- (void)noticeView:(UCFNoticeView *)noticeView didClickedNotice:(NSString *)noticeStr;

@end

@interface UCFNoticeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *noticeLabell;
@property (strong, nonatomic) NSMutableArray *noticeArray;
@property (weak, nonatomic) id<UCFNoticeViewDelegate> delegate;
@end
