//
//  UCFDirectCell.m
//  JRGC
//
//  Created by 秦 on 2016/9/19.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFDirectCell.h"

@implementation UCFDirectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFDirectCell" owner:self options:nil] lastObject];
        
    }
   

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellSelect:(BOOL)selected
{
    
    if(selected==NO){
        self.userInteractionEnabled = NO;
        self.lable_direct.textColor = UIColorWithRGB(0x999999);
    }else{
        self.userInteractionEnabled = YES;
        self.lable_title.textColor = UIColorWithRGB(0x555555);
    }
    
}

@end
