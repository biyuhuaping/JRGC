//
//  UCFGoldCashTwoCell.h
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol UCFGoldCashTwoCellDelegate <NSObject>
//- (void)cashCellDidClickedCashAllButton:(UIButton *)button;
//@end

@interface UCFGoldCashTwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
//@property (weak, nonatomic) id<UCFGoldCashTwoCellDelegate> delegate;
@property (copy, nonatomic) NSString *avavilableMoney;
@end
