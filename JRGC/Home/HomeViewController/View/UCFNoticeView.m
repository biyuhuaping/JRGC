//
//  UCFNoticeView.m
//  JRGC
//
//  Created by njw on 2017/5/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFNoticeView.h"
#import "YFRollingLabel.h"

@interface UCFNoticeView ()
@property (weak, nonatomic) YFRollingLabel *noticeLabel;
@end

@implementation UCFNoticeView

- (NSMutableArray *)noticeArray
{
    if (!_noticeArray) {
        _noticeArray = [[NSMutableArray alloc] init];
    }
    return _noticeArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

//- (void)layoutSubviews
//{
//    self.noticeLabel.frame = CGRectMake(15, 0, ScreenWidth - 30, self.height);
//    [self.noticeLabel setInternalWidth:self.noticeLabel.width / 3];
//    if (self.noticeArray.count > 0) {
//        if (!self.noticeLabel) {
//            YFRollingLabel *noticeLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-45, self.height)  textArray:self.noticeArray font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
//            [self addSubview:noticeLabel];
//            
//            noticeLabel.speed = 1;
//            [noticeLabel setOrientation:RollingOrientationLeft];
//            self.noticeLabel = noticeLabel;
//        }
//    }
//    [super layoutSubviews];
//}

- (IBAction)notice:(UIButton *)sender {
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowNotice"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self.noticeLabel stopTimer];
//    [self.noticeLabel removeFromSuperview];
//    self.noticeLabel = nil;
//    [self.noticeArray removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(noticeView:didClickedNotice:)]) {
        [self.delegate noticeView:self didClickedNotice:self.noticeLabell.text];
    }
}


@end
