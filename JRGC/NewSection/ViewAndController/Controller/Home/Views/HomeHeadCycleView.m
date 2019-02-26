//
//  HomeHeadCycleView.m
//  JRGC
//
//  Created by zrc on 2019/1/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "HomeHeadCycleView.h"

@interface HomeHeadCycleView()<RCFFlowViewDelegate>
@property(nonatomic, weak)UCFHomeViewModel *VM;
@end

@implementation HomeHeadCycleView

- (void)showView:(UCFHomeViewModel *)viewModel
{
    self.VM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"imagesArr"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"imagesArr"]) {
            NSArray *imgArr = [change objectSafeArrayForKey:NSKeyValueChangeNewKey];
            if (imgArr.count > 0) {
                selfWeak.adCycleScrollView.advArray = [NSMutableArray arrayWithArray:imgArr];
                [selfWeak.adCycleScrollView reloadCycleView];
            }
        }
    }];
}
- (void)createSubviews
{
    
    RCFFlowView *view = [[RCFFlowView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
    view.delegate = self;
    self.adCycleScrollView = view;
    [self addSubview:view];
    

}
- (void)didSelectRCCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    if (self.VM) {
        [self.VM cycleViewSelectIndex:subIndex];
    }
}


@end
