//
//  UCFDirectCell.h
//  JRGC
//
//  Created by 秦 on 2016/9/19.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFDirectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lable_title;
@property (weak, nonatomic) IBOutlet UILabel *lable_direct;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)cellSelect:(BOOL)selected;
@end
