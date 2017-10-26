//
//  UCFTransferHeaderView.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTransferHeaderView.h"
#import "SDCycleScrollView.h"
#import "UCFCycleModel.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"

@interface UCFTransferHeaderView ()
@property (weak, nonatomic) SDCycleScrollView *cycleView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIButton *rateOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *limitOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *sumOrderButton;
@property (weak, nonatomic) IBOutlet UIView *buttonBaseView;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;
@property (assign, nonatomic) BOOL rateState;
@property (assign, nonatomic) BOOL limitState;
@property (assign, nonatomic) BOOL sumState;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSMutableArray *iconArray;
@end

@implementation UCFTransferHeaderView

- (NSMutableArray *)iconArray
{
    if (nil == _iconArray) {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    //    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self addSubview:cycleScrollView];
    self.cycleView = cycleScrollView;
    
    self.backgroundColor = UIColorWithRGB(0xebebee);
    
//    self.index = 3;
    self.rateState = YES;
    self.limitState = YES;
    self.sumState = YES;
    self.backgroundColor = UIColorWithRGB(0xebebee);
    self.bottomBaseView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:self.buttonBaseView isTop:NO];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:self.bottomBaseView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xe3e5ea) With:self.bottomBaseView isTop:NO];
    [_rateOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    
    [self.rateOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [self.rateOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    
    [self.limitOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 120.0f )/320.0f - ScreenWidth / 3.0 - 7, 0, 0)];
    [self.limitOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 120.0f )/320.0f - ScreenWidth / 3.0 -7 + 43, 0, 0)];
    
    [self.sumOrderButton setTitleEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 215.0f )/320.0f - ScreenWidth / 3.0 *2 - 7, 0, 0)];
    [self.sumOrderButton setImageEdgeInsets:UIEdgeInsetsMake(0, (ScreenWidth * 215.0f )/320.0f - ScreenWidth / 3.0 *2 - 7 + 43, 0, 0)];
    
    [self getNormalBannerData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleView.frame = CGRectMake(0, 0, ScreenWidth, self.height-105);
    if (self.iconArray.count>0) {
        for (UIView *view in self.buttonBaseView.subviews) {
            NSInteger index = view.tag - 100;
            if (index >= 0) {
                UCFCycleModel *model = [self.iconArray objectAtIndex:index];
                for (UIView *view1 in view.subviews) {
                    if ([view1 isKindOfClass:[UIImageView class]]) {
                        UIImageView *image = (UIImageView *)view1;
                        [image sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
                    }
                    else if ([view1 isKindOfClass:[UILabel class]]) {
                        UILabel *label = (UILabel *)view1;
                        label.text = model.title;
                    }
                }
            }
        }
    }
    
}
- (void)initData
{
//    [self rateOrder:_rateOrderButton];
    [self calcueAllStateButton];
    [_rateOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
}
#pragma mark - button点击事件
- (IBAction)rateOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.rateState = !self.rateState;
    }
    self.index = sender.tag -100;
    [self calcueAllStateButton];
    if (self.rateState) {
        DBLOG(@"利率  升序");
        [self.rateOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_up"] forState:UIControlStateNormal];
    }
    else {
        DBLOG(@"利率  降序");
      [self.rateOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_dnow"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.rateState];
    }
    [self changeButtonTitleColor:sender];

}

- (IBAction)limitOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.limitState = !self.limitState;
    }
    self.index = sender.tag -100;
    [self calcueAllStateButton];
    if (self.limitState) {
        DBLOG(@"期限  升序");
        [self.limitOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_up"] forState:UIControlStateNormal];
    }
    else {
        DBLOG(@"期限  降序");
        [self.limitOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_dnow"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.limitState];
    }
    [self changeButtonTitleColor:sender];

}

- (IBAction)sumOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.sumState = !self.sumState;
    }
    self.index = sender.tag -100;
    [self calcueAllStateButton];
    // 期限 YES 升序 NO 降序
    if (self.sumState) {
        DBLOG(@"金额  降序");
        [self.sumOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_dnow"] forState:UIControlStateNormal];
    }
    else {
        DBLOG(@"金额  升序");
        [self.sumOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_up"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.sumState];
    }
    [self changeButtonTitleColor:sender];
}
- (void)changeButtonTitleColor:(UIButton *)button
{
    [_rateOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0xf5343c) forState:UIControlStateNormal];
}

- (void)calcueAllStateButton
{
    [self.rateOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_normal"] forState:UIControlStateNormal];
    [self.limitOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_normal"] forState:UIControlStateNormal];
    [self.sumOrderButton setImage:[UIImage imageNamed:@"transfer_screen_icon_normal"] forState:UIControlStateNormal];
}

#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanner_obj.php?key=0ca175b9c0f726a831d895e&bid=51&iid=50"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!recervedData) {
                return ;
            }
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
            if (nil == dic) {
                return;
            }
            self.contentMode = UIViewContentModeScaleToFill;
            
            NSArray *bannerArr = [dic objectForKey:@"banner"];
            NSMutableArray *tempBanner = [NSMutableArray array];
            for (NSDictionary *dic in bannerArr) {
                UCFCycleModel *model = [UCFCycleModel getCycleModelByDataDict:dic];
                [tempBanner addObject:model];
            }
            weakSelf.cycleView.imagesGroup = tempBanner;
            [weakSelf.cycleView refreshImage];
            
            [weakSelf.iconArray removeAllObjects];
            NSArray *iconArr = [dic objectForKey:@"icon"];
            for (NSDictionary *dict in iconArr) {
                UCFCycleModel *model = [UCFCycleModel getCycleModelByDataDict:dict];
                [weakSelf.iconArray addObject:model];
            }
            
        });
    });
}


@end
