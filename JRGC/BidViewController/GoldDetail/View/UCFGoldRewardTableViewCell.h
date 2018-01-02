//
//  UCFGoldRewardTableViewCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/12/29.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UCFGoldRewardTableViewCellDelegate <NSObject>

@optional

-(void)clickGoldRewardCellWithButton:(NSInteger)tag;

@end
@interface UCFGoldRewardTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *rewardsArray;
@property (nonatomic, assign)id<UCFGoldRewardTableViewCellDelegate> delegate;
@end
