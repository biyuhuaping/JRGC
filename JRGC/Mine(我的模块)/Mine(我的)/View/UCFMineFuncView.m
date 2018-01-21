//
//  UCFMineFuncView.m
//  JRGC
//
//  Created by njw on 2017/12/21.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFMineFuncView.h"
#import "UCFMIneFuncCollectCell.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingGroup.h"
#import "UCFUserBenefitModel.h"

@interface UCFMineFuncView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation UCFMineFuncView

- (NSMutableArray *)dataArray
{
    UCFSettingItem *facBean = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_bean" title:@"工豆" destVcClass:nil];
    facBean.subtitle = self.benefit.beanAmount ? [NSString stringWithFormat:@"¥%@", self.benefit.beanAmount] : @"¥0.00";
    NSString *beanExpiring = [NSString stringWithFormat:@"%.2f", [self.benefit.beanExpiring doubleValue]];
    if ([beanExpiring compare:@"0.00"] > 0) {
        facBean.isShowOrHide = YES;
    }
    else {
        facBean.isShowOrHide = NO;
    }
    
    UCFSettingItem *coupon = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_coupon" title:@"优惠券" destVcClass:nil];
    NSString *couponExpringNum = [NSString stringWithFormat:@"%.2f", [self.benefit.couponExpringNum doubleValue]];
    if ([couponExpringNum compare:@"0.00"] > 0) {
        coupon.isShowOrHide = YES;
    }
    else {
        coupon.isShowOrHide = NO;
    }
    coupon.subtitle = self.benefit.couponNumber ? [NSString stringWithFormat:@"%@张可用", self.benefit.couponNumber] : @"0张可用";
    
    UCFSettingItem *facPoint = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_score" title:@"工分" destVcClass:nil];
    facPoint.subtitle = self.benefit.score ? [NSString stringWithFormat:@"%@分", self.benefit.score] : @"0分";
    UCFSettingItem *profitInvest = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_rebate" title:@"邀请返利" destVcClass:nil];
    profitInvest.subtitle = [UserInfoSingle sharedManager].gcm_code.length > 0 ? [NSString stringWithFormat:@"工场码%@", [UserInfoSingle sharedManager].gcm_code] : @"";
    
    UCFSettingItem *sign = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_checkin" title:@"签到" destVcClass:nil];
    sign.subtitle = @"签到送工分";
    UCFSettingItem *addProfitCalculator = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_calculator" title:@"投资计算器" destVcClass:nil];
    addProfitCalculator.subtitle = @"一键计算收益";
    
    UCFSettingItem *assetProof = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_assets" title:@"资产证明" destVcClass:nil];
    assetProof.subtitle = @"随时申请开具";
    UCFSettingItem *contactUs = [UCFSettingArrowItem itemWithIcon:@"uesr_icon_contact" title:@"联系我们" destVcClass:nil];
    contactUs.subtitle = @"400-0322-988";
    
    _dataArray = [[NSMutableArray alloc] initWithArray:@[facBean, coupon, facPoint, profitInvest, sign, addProfitCalculator, assetProof, contactUs]];
    
     
    return _dataArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 注册cell、sectionHeader、sectionFooter
    static NSString *const cellId = @"cellId";
    [_collectionView registerNib:[UINib nibWithNibName:@"UCFMIneFuncCollectCell" bundle:nil] forCellWithReuseIdentifier:cellId];
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellId = @"cellId";
    UCFMIneFuncCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.collectView = collectionView;
    cell.indexPath = indexPath;
    cell.setItem = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){ScreenWidth * 0.5, 60};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark ---- UICollectionViewDelegate

//// 点击高亮
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
//}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(mineFuncView:didClickItemWithTitle:)]) {
        UCFSettingArrowItem *item = [self.dataArray objectAtIndex:indexPath.row];
        [self.delegate mineFuncView:self didClickItemWithTitle:item.title];
    }
}

- (CGFloat)height
{
    return (self.dataArray.count / 2 + self.dataArray.count % 2) * 60;
}

- (void)setBenefit:(UCFUserBenefitModel *)benefit
{
    _benefit = benefit;
    [_collectionView reloadData];
}

- (void)clearData {
    self.benefit = nil;
    [self.collectionView reloadData];
}

@end
