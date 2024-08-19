//
//  UCFBidDetailTopBoardCell.m
//  JRGC
//
//  Created by zrc on 2019/1/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBidDetailTopBoardCell.h"
@interface UCFBidDetailTopBoardCell()
@property(nonatomic, strong)UILabel *leftLab;
@property(nonatomic, strong)UILabel *rightLab;
@end
@implementation UCFBidDetailTopBoardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.rootLayout.backgroundColor = [UIColor whiteColor];
//        
//        self.leftLab = [[UILabel alloc] init];
//        self.leftLab.leftPos.equalTo(@15);
//        self.leftLab.bottomPos.equalTo(@10);
//        self
//        self.leftLab.font = [Color gc_Font:14];
//        [self.rootLayout addSubview:self.leftLab];
//        
//        self.rightLab = [[UILabel alloc] init];
//        self.rightLab.rightPos.equalTo(@15);
//        self.rightLab.bottomPos.equalTo(@0);
//        self.rightLab.font = [Color gc_Font:14];
//        [self.rootLayout addSubview:self.rightLab];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
