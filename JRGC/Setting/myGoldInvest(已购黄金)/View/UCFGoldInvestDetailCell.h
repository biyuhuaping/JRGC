//
//  UCFGoldInvestDetailCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UCFGoldInvestDetailCellDelegate <NSObject>

@optional

-(void)gotoGoldDetialVC;

@end

@interface UCFGoldInvestDetailCell : UITableViewCell

@property(nonatomic,assign)id<UCFGoldInvestDetailCellDelegate> delegate;

- (IBAction)gotoGoldDetialVC:(id)sender;

@end


@interface UCFGoldInvestDetailSecondCell : UITableViewCell

@end


@interface UCFGoldInvestDetailFourCell : UITableViewCell

@end
