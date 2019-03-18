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
    DDLogDebug(@"%@", NSStringFromCGSize(self.bounds.size));
//    UIView *bottomSignView = [[UIView alloc] init];
//    [self addSubview:bottomSignView];
//    [bottomSignView setBackgroundColor:[Color ]];
//    self.bottomSignView = bottomSignView;

    
    UIView *bottomLine = [[UIView alloc] init];
    [self addSubview:bottomLine];
    [bottomLine setBackgroundColor:[Color color:PGColorOptionCellSeparatorGray]];
    self.bottomLine = bottomLine;
    

    
    HMSegmentedControl *seg = [[HMSegmentedControl alloc] init];
    seg.selectionIndicatorHeight = 2.0f;
    seg.backgroundColor = [UIColor clearColor];
    seg.font = [UIFont systemFontOfSize:14];
    seg.textColor = [Color color:PGColorOptionTitleBlack];
    seg.selectedTextColor = [Color color:PGColorOpttonRateNoramlTextColor];
    seg.selectionIndicatorColor = [Color color:PGColorOpttonRateNoramlTextColor];
    seg.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    seg.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    seg.shouldAnimateUserSelection = YES;
    [self addSubview:seg];
    self.segmentedControl = seg;
    
    [seg addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
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
//    self.bottomSignView.frame = CGRectMake(-8, self.height - 1, ScreenWidth, 1);
    self.bottomLine.frame = CGRectMake(0, self.height - 0.5, ScreenWidth, 0.5);
    self.segmentedControl.frame = CGRectMake(0, 0, ScreenWidth, self.height);
}

@end
