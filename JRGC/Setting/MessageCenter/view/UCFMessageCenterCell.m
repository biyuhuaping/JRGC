//
//  UCFMessageCenterCell.m
//  JRGC
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UCFMessageCenterCell.h"
#import "UIDic+Safe.h"

@interface UCFMessageCenterCell()

@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLab;
@property (weak, nonatomic) IBOutlet UILabel *messageDetailLab;
@property (weak, nonatomic) IBOutlet UIView *unreadOrReadVIew;

@property (weak,nonatomic) UITableView * tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bkViewTrailing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageDetailTrilingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageDateTrilingSpace;

@end

@implementation UCFMessageCenterCell
- (void)setFrame:(CGRect)frame{
//    frame.origin.y += 11;
//    frame.size.height -= 11;
    [super setFrame:frame];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"messageCenterCell";
    UCFMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UCFMessageCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [Color  color:PGColorOpttonTabeleViewBackgroundColor];
//        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, ScreenWidth+32, 0.5)];
//        topLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        [cell.middleView addSubview:topLine];
//        
//        UIView *midLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.middleView.frame)-1, ScreenWidth+32, 0.5)];
//        midLine.backgroundColor = UIColorWithRGB(0xeff0f3);
//        [cell.middleView addSubview:midLine];
//        
//        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.downView.frame)-0.5, ScreenWidth+32, 0.5)];
//        bottomLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        [cell.downView addSubview:bottomLine];
//        cell.messageDateTrilingSpace.constant = 15;
//        cell.messageDetailTrilingSpace.constant = 15;
    }
    cell.tableView = tableView;
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFMessageCenterCell" owner:self options:nil] lastObject];
        self.selectionStyle = 0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-22,63, 22,22);
        [button setImage:[UIImage imageNamed:@"coupon_btn_unselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"coupon_btn_selected"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
        _editButton = button;
        [self addSubview:_editButton];
        
    }
    return self;
}
-(void)setMessageCenterModel:(UCFMessageCenterModel *)messageCenterModel{
    _messageCenterModel = messageCenterModel;
    if ([messageCenterModel.isUse isEqualToString:@"Y"]) {
        self.unreadOrReadVIew.hidden = YES;
    }else {
        self.unreadOrReadVIew.hidden = NO;
    }
    self.messageTitleLab.text =messageCenterModel.title;
    self.messageDetailLab.text = messageCenterModel.delHTMLTagContent;
    self.messageDateLab.text =messageCenterModel.createTime;
}
#pragma mark -点击编辑状态按钮
- (void)clickEditButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_chooseCell && sender.selected == YES) {
        _chooseCell();
    }else if (_cancelChooseCell && sender.selected == NO) {
        _cancelChooseCell();
    }
}
#pragma mark -cell开始处于编辑状态
- (void)starEditCell {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.contentView.frame;
        rect.origin.x = 30;
        self.contentView.frame = rect;
        CGRect editButtonRect = _editButton.frame;
        editButtonRect.origin.x = 11;
        _editButton.frame = editButtonRect;
        self.messageDateTrilingSpace.constant = 47;
        self.messageDetailTrilingSpace.constant = 47;
        self.bkViewTrailing.constant = 45;
    }];
}
#pragma mark -cell结束编辑状态，恢复原来状态
- (void)endEditCell {
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect rect = self.contentView.frame;
        rect.origin.x = 0;
        self.contentView.frame = rect;
        CGRect editButtonRect = _editButton.frame;
        editButtonRect.origin.x = -21;
        _editButton.frame = editButtonRect;
        _editButton.selected = NO;
        self.messageDateTrilingSpace.constant = 15;
        self.messageDetailTrilingSpace.constant = 15;
        self.bkViewTrailing.constant = 15;
    }];
    
}
#pragma mark -选择cell 与取消cell block回调
- (void)chooseCell:(void(^)())chooseCell cancelChooseCell:(void(^)())cancelChooseCell {
    _chooseCell = chooseCell;
    _cancelChooseCell = cancelChooseCell;
}
#pragma mark -重写Cell的layoutSubviews的方法
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.contentView.frame;
    CGRect editButtonRect = _editButton.frame;
    if (_isCellEdit) {
        rect.origin.x = 32;
        editButtonRect.origin.x = 11;
        self.messageDateTrilingSpace.constant = 47;
        self.messageDetailTrilingSpace.constant = 47;
    }else {
        rect.origin.x = 0;
        editButtonRect.origin.x = -32;
        self.messageDateTrilingSpace.constant = 15;
        self.messageDetailTrilingSpace.constant = 15;
    }
    self.contentView.frame = rect;
    _editButton.frame = editButtonRect;
}
@end
