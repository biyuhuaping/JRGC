//
//  UCFMineItemCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/15.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineItemCell.h"
#import "NZLabel.h"
#import "UCFMineCellAccountModel.h"
#import "UCFNewMineViewController.h"

@interface UCFMineItemCell()
@property (nonatomic, strong) UIImageView *itemImageView;//图片

@property (nonatomic, strong) NZLabel     *itemTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *itemContentLabel;//标题

@property (nonatomic, strong) UIImageView *itemArrawImageView;//图片

@property (nonatomic, strong) UIView *itemLineView;//下划线
@end

@implementation UCFMineItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化视图对象

        self.rootLayout.backgroundColor = [UIColor clearColor];
        
        [self.rootLayout addSubview:self.itemImageView];
        [self.rootLayout addSubview:self.itemTitleLabel];
        [self.rootLayout addSubview:self.itemContentLabel];
        [self.rootLayout addSubview:self.itemArrawImageView];
        [self.rootLayout addSubview:self.itemLineView];
//        [self cellLineMyVisibility];
        
    }
    return self;
}

- (UIImageView *)itemImageView
{
    if (nil == _itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        _itemImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _itemImageView.myLeft = 12;
        _itemImageView.myWidth = 25;
        _itemImageView.myHeight = 25;
    }
    return _itemImageView;
}
- (NZLabel *)itemTitleLabel
{
    if (nil == _itemTitleLabel) {
        _itemTitleLabel = [NZLabel new];
        _itemTitleLabel.centerYPos.equalTo(self.itemImageView.centerYPos);
        _itemTitleLabel.leftPos.equalTo(self.itemImageView.rightPos).offset(13);
        _itemTitleLabel.textAlignment = NSTextAlignmentCenter;
        _itemTitleLabel.font = [Color gc_Font:15.0];
        _itemTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];

    }
    return _itemTitleLabel;
}

- (NZLabel *)itemContentLabel
{
    if (nil == _itemContentLabel) {
        _itemContentLabel = [NZLabel new];
        _itemContentLabel.centerYPos.equalTo(self.itemImageView.centerYPos);
        _itemContentLabel.rightPos.equalTo(self.itemArrawImageView.leftPos).offset(6);
        _itemContentLabel.textAlignment = NSTextAlignmentRight;
        _itemContentLabel.font = [Color gc_Font:14.0];
        _itemContentLabel.textColor = [Color color:PGColorOptionCellContentBlue];
        _itemContentLabel.myVisibility = MyVisibility_Gone;
    }
    return _itemContentLabel;
}

- (UIImageView *)itemArrawImageView
{
    if (nil == _itemArrawImageView) {
        _itemArrawImageView = [[UIImageView alloc] init];
        _itemArrawImageView.centerYPos.equalTo(self.itemImageView.centerYPos);
        _itemArrawImageView.myRight = 15;
        _itemArrawImageView.myWidth = 8;
        _itemArrawImageView.myHeight = 13;
        _itemArrawImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
    }
    return _itemArrawImageView;
}

- (UIView *)itemLineView
{
    if (nil == _itemLineView) {
        _itemLineView = [UIView new];
        _itemLineView.myBottom = 1;
        _itemLineView.myHeight = 0.5;
        _itemLineView.myLeft = 50;
        _itemLineView.myRight = 0;
        _itemLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _itemLineView;
}
//- (void)cellLineMyVisibility
//{
//    UCFNewMineViewController *newMine = self.bc;
//    UITableView *tableView = newMine.tableView;
//    float Version=[[[UIDevice currentDevice] systemVersion] floatValue];//(设备判断)
//    if(Version>=7.0){
//        tableView = (UITableView *)self.superview.superview;
//    }else{
//        tableView=(UITableView *)self.superview;
//    }
//    if ([tableView isKindOfClass:[UITableView class]]) {
//
//        NSIndexPath *indexPath = [tableView indexPathForCell:self];
//        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
//            //      1.系统分割线,移到屏幕外
//            //      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
//            //      2.自定义Cell
//            self.itemLineView.myVisibility = MyVisibility_Visible;
//        }
//        else
//        {
//            // 1.系统分割线,移到屏幕外
//            // cell.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0) ;
//            // 2.自定义Cell
//            self.itemLineView.hidden = MyVisibility_Gone;
//        }
//    }
//    /**视图可见，等价于hidden = false*/
////    MyVisibility_Visible,
//    /**视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域*/
////    MyVisibility_Invisible,
//    /**视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域*/
////    MyVisibility_Gone
//}

#pragma mark - 数据重新加载
- (void)showInfo:(id)model
{
    UCFMineCellAccountModel *caModel = model;
    self.itemImageView.image = [UIImage imageNamed:caModel.cellAccountImage];
    self.itemTitleLabel.text = caModel.cellAccountTitle;
    [self.itemTitleLabel sizeToFit];
    if ([caModel.cellAccountTitle isEqualToString:@"客服热线"]) {
        self.itemContentLabel.text = @"400-032-2988";
        [self.itemContentLabel sizeToFit];
        self.itemContentLabel.myVisibility = MyVisibility_Visible;
    }
    else{
        self.itemContentLabel.myVisibility = MyVisibility_Gone;
    }
    if ([caModel.cellAccountTitle isEqualToString:@"客服热线"] || [caModel.cellAccountTitle isEqualToString:@"商城订单"]) {
        self.itemLineView.myVisibility = MyVisibility_Gone ;
    }
    else{
        self.itemLineView.myVisibility = MyVisibility_Visible;
    }
}
//- (void)layoutSubviews
//{
//    UITableView *tableView;
//    float Version=[[[UIDevice currentDevice] systemVersion] floatValue];//(设备判断)
//    if(Version>=7.0){
//        tableView = (UITableView *)self.superview.superview;
//    }else{
//        tableView=(UITableView *)self.superview;
//    }
//    if ([tableView isKindOfClass:[UITableView class]]) {
//
//        NSIndexPath *indexPath = [tableView indexPathForCell:self];
//        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
//            //      1.系统分割线,移到屏幕外
//            //      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
//            //      2.自定义Cell
//            self.itemLineView.myVisibility = MyVisibility_Visible;
//        }
//        else
//        {
//            // 1.系统分割线,移到屏幕外
//            // cell.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0) ;
//            // 2.自定义Cell
//            self.itemLineView.hidden = MyVisibility_Gone;
//        }
//    }
//
//}
@end
