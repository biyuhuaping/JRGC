//
//  MoreHeadView.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "MoreHeadView.h"
#import "FBKVOController.h"
#import "NSObject+FBKVOController.h"
@interface MoreHeadView()
@property(nonatomic, strong)MoreViewModel *vm;
@property (weak, nonatomic) IBOutlet UILabel *buildVersionLab;
@end

@implementation MoreHeadView

+ (MoreHeadView *)getView
{
    MoreHeadView * headView = (MoreHeadView *)[[[NSBundle mainBundle] loadNibNamed:@"MoreHeadView" owner:self options:nil] firstObject];
    
    return headView;
}
- (void)blindViewModel:(MoreViewModel *)viewModel
{
    self.vm = viewModel;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    _buildVersionLab.text = [NSString stringWithFormat:@"当前版本V%@",currentVersion];
}
- (IBAction)praiseButtonClick:(UIButton *)sender {
    [self.vm vmPraiseButtonClick:sender];
}
- (IBAction)feedBackButtonClick:(UIButton *)sender {
    [self.vm vmFeedBackButtonClick:sender];
}

@end
