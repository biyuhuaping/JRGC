//
//  UCFSimpleNoticeTableViewCell.m
//  JRGC
//
//  Created by zrc on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFSimpleNoticeTableViewCell.h"
@interface UCFSimpleNoticeTableViewCell()
@property(nonatomic, strong)UILabel *titleLab;
@property(nonatomic, strong)UILabel *timeLabe;
@property(nonatomic, strong)UIImageView *accessView;
@property(nonatomic, strong)UIView  *endLineView;

@end


@implementation UCFSimpleNoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.rootLayout.topPadding = 5;
//        self.rootLayout.bottomPadding = 5;
        self.rootLayout.cacheEstimatedRect = YES; //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
        /*
         在UITableViewCell中使用MyLayout中的布局时请将布局视图作为contentView的子视图。如果我们的UITableViewCell的高度是动态的，请务必在将布局视图添加到contentView之前进行如下设置：
         _rootLayout.widthSize.equalTo(self.contentView.widthSize);
         _rootLayout.wrapContentHeight = YES;
         */
        self.rootLayout.widthSize.equalTo(self.contentView.widthSize);
        self.rootLayout.wrapContentHeight = YES;
        
        UILabel *titleLabe = [UILabel new];
        titleLabe.leftPos.equalTo(@15);
        titleLabe.topPos.equalTo(@20);
//        titleLabe.backgroundColor = [UIColor redColor];
        titleLabe.rightPos.equalTo(@87);
        titleLabe.bottomPos.equalTo(@42);
        titleLabe.wrapContentHeight = YES; //如果想让文本消息的高度是动态的，请在设置明确宽度的情况下将wrapContentHeight设置为YES。
        self.titleLab = titleLabe;
        titleLabe.font = [Color gc_Font:16];
        titleLabe.textColor = [Color color:PGColorOptionTitleBlack];
        [self.rootLayout addSubview:titleLabe];
        
        UILabel *timeLabe = [UILabel new];
        timeLabe.topPos.equalTo(titleLabe.bottomPos).offset(10);
        timeLabe.leftPos.equalTo(@15);
        timeLabe.bottomPos.equalTo(@20);
//        timeLabe.backgroundColor = [UIColor blueColor];
        [self.rootLayout addSubview:timeLabe];
        timeLabe.backgroundColor = [UIColor whiteColor];
        timeLabe.font = [Color gc_Font:13];
        timeLabe.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        self.timeLabe = timeLabe;
        
        UIImageView *aceesView = [UIImageView new];
        aceesView.image = [UIImage imageNamed:@"list_icon_arrow"];
        aceesView.mySize = CGSizeMake(8, 13);
        aceesView.centerYPos.equalTo(self.rootLayout.centerYPos);
        aceesView.rightPos.equalTo(@15);
        [self.rootLayout addSubview:aceesView];
        self.accessView = aceesView;
        
        UIView *lineView = [UIView new];
        lineView.heightSize.equalTo(@1);
        lineView.leftPos.equalTo(@15);
        lineView.bottomPos.equalTo(@0);
        lineView.rightPos.equalTo(@0);
        lineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        [self.rootLayout addSubview:lineView];
        self.endLineView = lineView;
        
    }
    return self;
}
-(void)setModel:(NoticeResult*)model isEndView:(BOOL)isEnd
{
    if (isEnd) {
        self.endLineView.leftPos.equalTo(@0);
    } else {
        self.endLineView.leftPos.equalTo(@15);
    }
    self.titleLab.text = model.title;
    [self.titleLab sizeToFit];
    self.timeLabe.text = model.sendTime;
    [self.timeLabe sizeToFit];
}

//如果您的最低支持是iOS8，那么你可以重载这个方法来动态的评估cell的高度，Autolayout内部是通过这个方法来评估高度的，因此如果用MyLayout实现的话就不需要调用基类的方法，而是调用根布局视图的sizeThatFits来评估获取动态的高度。
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    /*
     通过布局视图的sizeThatFits方法能够评估出UITableViewCell的动态高度。sizeThatFits并不会进行布局而只是评估布局的尺寸。
     因为cell的高度是自适应的，因此这里通过调用高度为wrap的布局视图的sizeThatFits来获取真实的高度。
     */
    
    if (@available(iOS 11.0, *)) {
        //如果你的界面要支持横屏的话，因为iPhoneX的横屏左右有44的安全区域，所以这里要减去左右的安全区域的值，来作为布局宽度尺寸的评估值。
        //如果您的界面不需要支持横屏，或者延伸到安全区域外则不需要做这个特殊处理，而直接使用else部分的代码即可。
        return [self.rootLayout sizeThatFits:CGSizeMake(targetSize.width - self.safeAreaInsets.left - self.safeAreaInsets.right, targetSize.height)];
    } else {
        return [self.rootLayout sizeThatFits:targetSize];  //如果使用系统自带的分割线，请记得将返回的高度height+1
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
}

@end
