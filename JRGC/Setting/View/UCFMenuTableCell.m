//
//  UCFMenuTableCell.m
//  JRGC
//
//  Created by NJW on 16/9/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFMenuTableCell.h"
#import "UCFMenuItemModel.h"
#import "SettingMainButton.h"

#define SEGLINE_WIDTH 0.5f
#define SEGLINE_COLOR UIColorWithRGB(0xe3e5ea)

@interface UCFMenuTableCell ()
@property (nonatomic, strong) NSArray *segLines_Hori;
@property (nonatomic, assign) NSInteger itemRows;
@property (nonatomic, weak) UIView *segLine_Verti_1;
@property (nonatomic, weak) UIView *segLine_Verti_2;
@property (weak, nonatomic) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *itemButtons;
@end

@implementation UCFMenuTableCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting_menu";
    UCFMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UCFMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.tableview = tableView;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setItems:(NSMutableArray *)items
{
    _items = items;
    _itemButtons = [NSMutableArray array];
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    for (int i=0; i<items.count; i++) {
        SettingMainButton *menuButton = [[[NSBundle mainBundle] loadNibNamed:@"SettingMainButton" owner:self options:nil] lastObject];
        UCFMenuItemModel *menuItemModel = [items objectAtIndex:i];
        menuButton.customImageView.image = [UIImage imageNamed:menuItemModel.image];
        menuButton.customTitleLabel.text = menuItemModel.name;
        
        [menuButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:menuButton];
        [_itemButtons addObject:menuButton];
    }
    if (items.count>0) {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
        view1.backgroundColor = SEGLINE_COLOR;
        [self addSubview:view1];
        self.segLine_Verti_1 = view1;
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
        view2.backgroundColor = SEGLINE_COLOR;
        [self addSubview:view2];
        self.segLine_Verti_2 = view2;
        
        self.itemRows = items.count%3 ? items.count/3 + 2 : items.count/3 + 1;
        NSMutableArray *lineArray = [NSMutableArray array];
        for (int i = 0; i<self.itemRows; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
            line.backgroundColor = SEGLINE_COLOR;
            if (i==0||i==self.itemRows) {
                line.backgroundColor = UIColorWithRGB(0xd8d8d8);
            }
            [self addSubview:line];
            [lineArray addObject:line];
        }
        self.segLines_Hori = lineArray;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat menuItemW = (SCREEN_WIDTH - SEGLINE_WIDTH * 2) / 3;
    CGFloat menuItemH = (self.frame.size.height - SEGLINE_WIDTH *self.itemRows)/(self.itemRows-1);
    DDLogDebug(@"%@", NSStringFromCGRect(self.frame));
    DDLogDebug(@"%@", NSStringFromCGRect(self.tableview.frame));
    // 设置分割线
    CGFloat segline1_x = menuItemW;
    self.segLine_Verti_1.frame = CGRectMake(segline1_x, 0, SEGLINE_WIDTH, self.frame.size.height);
    CGFloat segline2_x = menuItemW * 2 + SEGLINE_WIDTH;
    self.segLine_Verti_2.frame = CGRectMake(segline2_x, 0, SEGLINE_WIDTH, self.frame.size.height);
    
    for (int i=0; i<self.segLines_Hori.count; i++) {
        UIView *segline_hori = [self.segLines_Hori objectAtIndex:i];
        segline_hori.frame = CGRectMake(0, (menuItemH+SEGLINE_WIDTH)*i, self.frame.size.width, SEGLINE_WIDTH);
        segline_hori.backgroundColor = SEGLINE_COLOR;
    }
    
    for (int i = 0; i< self.itemButtons.count; i++) {
        SettingMainButton *button = [self.itemButtons objectAtIndex:i];
        CGFloat item_x = (i%3) * (menuItemW + SEGLINE_WIDTH);
        CGFloat item_y = i/3 * (menuItemH + SEGLINE_WIDTH) + SEGLINE_WIDTH;
        button.frame = CGRectMake(item_x, item_y, menuItemW, menuItemH);
    }
}

- (void)itemClicked:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(menuView:didClickedItems:)]) {
        [self.delegate menuView:self didClickedItems:button];
    }
}
@end
