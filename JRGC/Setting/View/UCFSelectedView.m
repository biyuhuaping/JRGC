//
//  UCFSelectedView.m
//  JRGC
//
//  Created by NJW on 15/5/5.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//
#define BottomSignLineHeight 2.0
#define HorzenSideSpace 8

#import "UCFSelectedView.h"

@interface UCFSelectedView ()
@property (nonatomic, strong) NSArray *constraintsForSeg;
@property (nonatomic, weak) UIView *bottomSignView;
@property (nonatomic, weak) UIView *bottomLine;
@end

@implementation UCFSelectedView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    DBLOG(@"%@", NSStringFromCGSize(self.bounds.size));
    UIView *bottomSignView = [[UIView alloc] init];
    [self addSubview:bottomSignView];
//    bottomSignView.translatesAutoresizingMaskIntoConstraints=NO;
    [bottomSignView setBackgroundColor:UIColorWithRGB(0xebebee)];
    self.bottomSignView = bottomSignView;
    // 添加约束
//    NSArray *constraints1H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomSignView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomSignView)];
//    NSArray *constraints1V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomSignView(==2)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomSignView)];
//    [self addConstraints:constraints1H];
//    [self addConstraints:constraints1V];
    
    UIView *bottomLine = [[UIView alloc] init];
    [self addSubview:bottomLine];
//    bottomLine.translatesAutoresizingMaskIntoConstraints=NO;
    [bottomLine setBackgroundColor:UIColorWithRGB(0xd8d8d8)];
    self.bottomLine = bottomLine;
    
//    NSArray *constraints2H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bottomLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomLine)];
//    NSArray *constraints2V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLine(==0.5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(bottomLine)];
//    [self addConstraints:constraints2H];
//    [self addConstraints:constraints2V];
    
    HMSegmentedControl *seg = [[HMSegmentedControl alloc] init];
//    seg.translatesAutoresizingMaskIntoConstraints=NO;
    seg.selectionIndicatorHeight = 2.0f;
    seg.backgroundColor = [UIColor clearColor];
    seg.font = [UIFont systemFontOfSize:14];
    seg.textColor = UIColorWithRGB(0x3c3c3c);
//    seg.selectedTextColor = UIColorWithRGB(0xf03b43);
    seg.selectedTextColor = UIColorWithRGB(0xfd4d4c);
//    seg.selectionIndicatorColor = UIColorWithRGB(0xf03b43);
    seg.selectionIndicatorColor = UIColorWithRGB(0xfd4d4c);
    seg.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    seg.shouldAnimateUserSelection = YES;
    [self addSubview:seg];
    self.segmentedControl = seg;
    
//    NSArray *constraints3H=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[seg]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seg)];
//    self.constraintsForSeg = constraints3H;
//    NSArray *constraints3V=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[seg]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(seg)];
//    [self addConstraints:constraints3H];
//    [self addConstraints:constraints3V];
//    [seg addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSectionTitles:(NSArray *)sectionTitles
{
    _sectionTitles = sectionTitles;
    _segmentedControl.sectionTitles = sectionTitles;
    
    CGFloat centerY = CGRectGetHeight(self.frame)/2.0;
    if (sectionTitles.count >= 2) {
        for (int i=0; i<sectionTitles.count; i++) {
            if (i != 0) {
                CGFloat centerX = (ScreenWidth - HorzenSideSpace*2) / sectionTitles.count * i;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 12)];
                imageView.image = [UIImage imageNamed:@"particular_tabline"];
                [self.segmentedControl addSubview:imageView];
                imageView.center = CGPointMake(centerX, centerY);
            }
        }
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)sender
{
    if ([self.delegate respondsToSelector:@selector(SelectedView:didClickSelectedItemWithSeg:)]) {
        [self.delegate SelectedView:self didClickSelectedItemWithSeg:sender];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bottomSignView.frame = CGRectMake(-8, self.height - 2, ScreenWidth, 2);
    self.bottomLine.frame = CGRectMake(0, self.height - 0.5, ScreenWidth, 0.5);
    self.segmentedControl.frame = CGRectMake(0, 0, ScreenWidth, self.height);
}

@end
