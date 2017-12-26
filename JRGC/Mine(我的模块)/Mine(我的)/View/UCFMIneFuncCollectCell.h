//
//  UCFMIneFuncCollectCell.h
//  JRGC
//
//  Created by njw on 2017/12/21.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFSettingArrowItem;
@interface UCFMIneFuncCollectCell : UICollectionViewCell
@property (strong, nonatomic) UCFSettingArrowItem *setItem;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UICollectionView *collectView;
@end
