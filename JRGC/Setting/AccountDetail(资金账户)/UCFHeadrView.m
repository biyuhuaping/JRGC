//
//  UCFHeadrView.m
//  SectionDemo
//
//  Created by NJW on 15/4/23.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import "UCFHeadrView.h"
#import "FundAccountGroup.h"

@interface UCFHeadrView ()
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *dataLabel;
@property (nonatomic, weak) UIButton *bgButton;
@property (nonatomic, weak) UIImageView *rightImageView;
@end

@implementation UCFHeadrView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    UCFHeadrView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (nil == header) {
        header = [[[self class] alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加子控件
        UIButton *bgview = [UIButton buttonWithType:UIButtonTypeCustom];
        // 设置按钮内部的左边箭头图片
        [bgview setBackgroundColor:[UIColor whiteColor]];
//        [bgview setImage:[UIImage imageNamed:@"list_icon_arrow"] forState:UIControlStateNormal];
        bgview.imageEdgeInsets = UIEdgeInsetsMake(10, 285, 10, 20);
        [bgview addTarget:self action:@selector(bgViewClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:bgview];
        self.bgButton = bgview;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = UIColorWithRGB(0x555555);
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *dataLabel = [[UILabel alloc] init];
        dataLabel.textColor = UIColorWithRGB(0x555555);
        dataLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:dataLabel];
        self.dataLabel = dataLabel;
        
        UIImageView *right = [[UIImageView alloc] init];
        right.image = [UIImage imageNamed:@"list_icon_uparrow"];
        right.translatesAutoresizingMaskIntoConstraints=NO;
        [self.contentView addSubview:right];
        self.rightImageView = right;
        
        NSArray *constraints1H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:[right(==25)]-9-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(right)];
        NSArray *constraints1V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[right(==25)]-9.5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(right)];
        [self.contentView addConstraints:constraints1H];
        [self.contentView addConstraints:constraints1V];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.contentView addSubview:button];
//        [button setTitle:@"查看徽商银行存管账户" forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        [button setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
//        button.titleLabel.textAlignment = NSTextAlignmentRight;
//        button.hidden = YES;
//        self.button = button;
//        [button addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *linetop = [[UIView alloc] init];
        linetop.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self addSubview:linetop];
        self.topLine = linetop;
        
        UIView *linebottom = [[UIView alloc] init];
        linebottom.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [self addSubview:linebottom];
        self.bottomLine = linebottom;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置按钮的frame
    self.bgButton.frame = self.bounds;
    
    self.nameLabel.frame = CGRectMake(15, (CGRectGetHeight(self.frame)- 30)/2.0f, 80, 30);
    
    self.dataLabel.frame = CGRectMake(95, (CGRectGetHeight(self.frame)- 30)/2.0f, 195, 30);
    
    self.topLine.frame = CGRectMake(0, 0, ScreenWidth, 0.5);
    
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-0.5, ScreenWidth, 0.5);
    if (self.group.opened) {
        self.bottomLine.hidden = YES;
        self.rightImageView.transform = CGAffineTransformMakeRotation(0);
    } else {
        self.rightImageView.transform = CGAffineTransformMakeRotation(M_PI);
        self.bottomLine.hidden = NO;
    }
    
//    self.button.frame = CGRectMake(ScreenWidth-34-140, 0, 150, self.frame.size.height);
}

- (void)setGroup:(FundAccountGroup *)group
{
    _group = group;
//    if ([group.name isEqualToString:@"总计资产"]) {
//        [self.dataLabel setTextColor:[UIColor redColor]];
//    }
    
    [self.nameLabel setText:group.name];
    
    [self.dataLabel setText:[NSString stringWithFormat:@"¥%@", group.content]];
}


- (void)bgViewClick
{
    // 1.修改组模型的标记(状态取反)
    self.group.opened = !self.group.isOpened;
    
    // 2.刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedNameView:)]) {
        [self.delegate headerViewDidClickedNameView:self];
    }
}

//- (void)btnClicked
//{
//    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedCheckDetail:)]) {
//        [self.delegate headerViewDidClickedCheckDetail:self];
//    }
//}

@end
