//
//  BaseTableViewCell.m
//  JFTPay
//
//  Created by kuangzhanzhidian on 2018/6/26.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

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
        self.rootLayout = [MyRelativeLayout new];
        //        self.rootLayout.backgroundColor = [UIColor whiteColor];
        //        self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
        //        self.rootLayout.widthSize.equalTo(self.contentView.widthSize);
        //        self.rootLayout.heightSize.equalTo(self.contentView.heightSize);
        //        [self.contentView addSubview: self.rootLayout];
        self.rootLayout.backgroundColor = [UIColor clearColor];
        
        self.rootLayout.topPos.equalTo(@0);
        self.rootLayout.bottomPos.equalTo(@0);
        self.rootLayout.leftPos.equalTo(@0);
        self.rootLayout.rightPos.equalTo(@0);
        self.rootLayout.cacheEstimatedRect = YES;
        [self.contentView addSubview: self.rootLayout];
        
        //        self.rootLayout= [MyRelativeLayout new];
        //        //        rootLayout.myMargin = 0;   //四周边距是0表示布局视图的尺寸和contentView的尺寸一致。
        //        self.contentView.backgroundColor = [UIColor clearColor];
        //        self.rootLayout.myMargin = 0;
        //        [self.contentView addSubview: self.rootLayout];
    }
    return self;
}

- (void)getBassController:(id)bassController
{
    self.bc = bassController;
}

- (void)refreshCellData:(id)data
{
}


- (void)aaaaa
{
    //    UIView *v = [sender superview];//获取父类view
    //    UIView *v1 = [v superview];
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            //            UITableViewCell *cell = (UITableViewCell *)[self superview];//获取cell
            //            NSIndexPath *indexPathAll = [(UITableView *)nextResponder indexPathForCell:cell];//获取cell对应的section
            
        }
    }
}

@end
