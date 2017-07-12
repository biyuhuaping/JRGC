//
//  UCFGoldTransactionHeadView.h
//  JRGC
//
//  Created by 张瑞超 on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFGoldTransactionHeadView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIView *topSectionView;
@property (weak, nonatomic) IBOutlet UIView *bottomSectionView;

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *middleLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
