//
//  MoreViewModel.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "MoreViewModel.h"

#include "GlobalTextFile.h"

@interface MoreViewModel()
@property(strong, nonatomic)NSMutableArray  *listArray_one;
@property(strong, nonatomic)NSMutableArray  *listArray_two;
@property(strong, nonatomic)NSMutableArray  *totalArray;
@end

@implementation MoreViewModel
- (instancetype)init {
    if (self = [super init]) {
        [self configModelArr];
    }
    return self;
}
- (void)configModelArr
{
    self.totalArray = [NSMutableArray arrayWithCapacity:2];
    self.listArray_one = [NSMutableArray arrayWithCapacity:2];
    self.listArray_two = [NSMutableArray arrayWithCapacity:3];
    
    MoreModel *model1_1 = [[MoreModel alloc] initWithLeftTitle:@"关于我们" RightTitle:nil ShowAccess:YES TargetClassName:@""];
    MoreModel *model1_2 = [[MoreModel alloc] initWithLeftTitle:@"帮助中心" RightTitle:nil ShowAccess:YES TargetClassName:@""];
    [self.listArray_one addObject:model1_1];
    [self.listArray_one addObject:model1_2];

    MoreModel *model2_1 = [[MoreModel alloc] initWithLeftTitle:@"客服电话" RightTitle:SERVICE_PHONE ShowAccess:YES TargetClassName:@""];
    MoreModel *model2_2 = [[MoreModel alloc] initWithLeftTitle:@"微信公众号" RightTitle:GC_CENTER ShowAccess:YES TargetClassName:@""];
    MoreModel *model2_3 = [[MoreModel alloc] initWithLeftTitle:@"公司网址" RightTitle:GC_NET_ADDRESS ShowAccess:YES TargetClassName:@""];
    [self.listArray_two addObject:model2_1];
    [self.listArray_two addObject:model2_2];
    [self.listArray_two addObject:model2_3];
    [self.totalArray addObject:self.listArray_one];
    [self.totalArray addObject:self.listArray_two];

}
- (CGFloat) getSectionHeight{
    return 9;
}
- (NSInteger) getSectionCount{
    return self.totalArray.count;
}
- (NSInteger)getSectionCount:(NSInteger)section {
    NSArray *arr = [self.totalArray objectAtIndex:section];
    return arr.count;
}
- (MoreModel *)getSectionData:(NSIndexPath *)indexpath
{
    NSArray *arr = [self.totalArray objectAtIndex:indexpath.section];
    MoreModel *model = [arr objectAtIndex:indexpath.row];
    return model;
}
- (int)getCellPostion:(NSIndexPath *)indexPath
{
    NSArray *arr = [self.totalArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return -1;  //第一行
    } else if (indexPath.row == arr.count - 1) {
        return 1;   //第二行
    } else {
       return 0;    //中间行
    }
    
}
- (void)cellSelectedClicked:(MoreModel *)model
{
    
}
- (void)vmPraiseButtonClick:(UIButton *)button;
{
    
}
- (void)vmFeedBackButtonClick:(UIButton *)button
{
    
}
@end
