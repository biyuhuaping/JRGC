//
//  UCFJYRouteTableViewCell.m
//  JRGC
//
//  Created by 金融工场 on 2019/5/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFJYRouteTableViewCell.h"

@implementation UCFJYRouteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        [self.rootLayout addSubview:self.jyImageBaseView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (UIButton *)jyImageBaseView
{
    if (!_jyImageBaseBtn) {
        _jyImageBaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jyImageBaseBtn.leftPos.equalTo(@15);
        _jyImageBaseBtn.rightPos.equalTo(@15);
        _jyImageBaseBtn.topPos.equalTo(@0);
        _jyImageBaseBtn.bottomPos.equalTo(@15);
        [_jyImageBaseBtn setBackgroundImage:[UIImage imageNamed:@"jy_bottom_pic"] forState:UIControlStateNormal];
        [_jyImageBaseBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _jyImageBaseBtn;
}
- (void)click:(UIButton *)button
{
    if (self.deleage && [self.deleage respondsToSelector:@selector(baseTableViewCell:buttonClick:withModel:)]) {
        [self.deleage baseTableViewCell:self buttonClick:button withModel:@"京元"];
    }
}
@end
