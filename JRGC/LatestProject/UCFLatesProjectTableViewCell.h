//
//  UCFLatesProjectTableViewCell.h
//  JRGC
//
//  Created by 秦 on 2016/11/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol homeButtonPressedCellDelegate <NSObject>

- (void)homeButtonPressed:(UIButton *)button withCelltypeSellWay:(NSString*)strSellWay;
- (void)homeButtonPressedP2PButton:(UIButton *)button;
- (void)homeButtonPressedHornorButton:(UIButton *)button;
@end

@interface UCFLatesProjectTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image_ahead;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIImageView *image_arrow;

@property (weak, nonatomic) IBOutlet UIButton *but_press;
@property (strong, nonatomic) NSString * typeSellWay;
@property (assign, nonatomic)id<homeButtonPressedCellDelegate> delegate;
@end
