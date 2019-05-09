//
//  UCFCalendarHeaderView.m
//  TestCalenar
//
//  Created by njw on 2017/6/23.
//  Copyright © 2017年 njw. All rights reserved.
//

#import "UCFCalendarHeaderView.h"
#import "UCFCalendarCollectionViewCell.h"
#import "UIDic+Safe.h"
#import <Foundation/Foundation.h>
#import "UCFToolsMehod.h"
#import "NetworkModule.h"
#import "JSONKit.h"
#import "UCFCalendarDayInfo.h"
#import "UIImage+Compression.h"
@interface UCFCalendarHeaderView () <UICollectionViewDataSource, UICollectionViewDelegate, NetworkModuleDelegate, UCFCalendarCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UIImageView *baseImageView;

@property (weak, nonatomic) IBOutlet UILabel *myPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitPrincipalLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitInterestLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *moneyBaseView;


@property (strong, nonatomic) NSMutableArray *months;
//@property (weak, nonatomic) IBOutlet UIView *currentDayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarH;
@property (strong, nonatomic) NSMutableArray *days;

@property (weak, nonatomic) UIButton *preButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (weak, nonatomic) UIButton *headerButton;
@property (weak, nonatomic) UIView *upLine;
@property (weak, nonatomic) UIView *downLine1;
@property (weak, nonatomic) UIView *downLine2;
@property (weak, nonatomic) UIView *downLine;
@property (strong, nonatomic) UIView *weekView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;

@property (weak, nonatomic) IBOutlet UIView *dateLineView;

@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation UCFCalendarHeaderView

- (NSMutableArray *)months
{
    if (nil == _months) {
        _months = [NSMutableArray array];
    }
    return _months;
}

- (NSMutableArray *)days
{
    if (nil == _days) {
        _days = [NSMutableArray array];
    }
    return _days;
}

- (NSDateFormatter *)dateFormatter
{
    if (nil == _dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (NSDateFormatter *)dateFormatter1
{
    if (nil == _dateFormatter1) {
        _dateFormatter1 = [[NSDateFormatter alloc] init];
        [_dateFormatter1 setDateFormat:@"yyyy-MM"];
    }
    return _dateFormatter1;
}

- (UIView *)weekView
{
    if (nil == _weekView) {
        _weekView = [[UIView alloc] initWithFrame:CGRectZero];
        _weekView.backgroundColor = [UIColor whiteColor];
        for (int i=0; i<7; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
            label.font = [UIFont systemFontOfSize:15];
            label.tag = i;
            label.textAlignment = NSTextAlignmentCenter;
            [_weekView addSubview:label];
        }
    }
    return _weekView;
}

static NSString *const cellId = @"cellId";

+ (CGFloat)viewHeight
{
    if (SingleUserInfo.loginData.userInfo.zxIsNew) {
        return 610 ;
    }
    return 634;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dateLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
    CGRect frame1 = self.dateLineView.frame;
    frame1.size.height = 0.5;
    self.dateLineView.frame = frame1;
    self.dateLineView.hidden = YES;
    self.redView.backgroundColor = [Color color:PGColorOptionTitlerRead];
    self.blueView.backgroundColor = [Color color:PGColorOptionCellContentBlue];
    UIImage *image = [UIImage gc_styleImageSize:CGSizeMake(_baseImageView.frame.size.width, _baseImageView.frame.size.height)];
    _baseImageView.image = image;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 0;
    //最小两行之间的间距
    layout.minimumLineSpacing = 0;
    
    UICollectionView * collectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor=[UIColor whiteColor];
    collectionView.delegate=self;
    collectionView.dataSource=self;
    collectionView.pagingEnabled = YES;
    //这个是横向滑动
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    [self.calendarView addSubview:collectionView];
    self.calendar = collectionView;
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    monthLabel.textColor = [Color color:PGColorOptionTitleBlack];
    monthLabel.font = [UIFont systemFontOfSize:17];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:monthLabel];
    self.monthLabel = monthLabel;
    
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:headerButton];
    [headerButton setImageEdgeInsets:UIEdgeInsetsMake(0, 95, 0, 0)];
    [headerButton setImage:[UIImage imageNamed:@"fanli_loadown"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(headerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.headerButton = headerButton;
    
    
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setImage:[UIImage imageNamed:@"list_icon_arrow_left"] forState:UIControlStateNormal];
    [preButton addTarget:self action:@selector(preButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [preButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:preButton];
    self.preButton = preButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"list_icon_arrow"] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:nextButton];
    self.nextButton = nextButton;
    
//    UIView *upLine = [[UIView alloc] initWithFrame:CGRectZero];
//    upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//    [self addSubview:upLine];
//    self.upLine = upLine;
    
    UIView *downLine1 = [[UIView alloc] initWithFrame:CGRectZero];
    [downLine1 setBackgroundColor:[Color color:PGColorOptionCellSeparatorGray]];
    [self addSubview:downLine1];
    self.downLine1 = downLine1;
    
    UIView *downLine2 = [[UIView alloc] initWithFrame:CGRectZero];
    [downLine2 setBackgroundColor:[Color color:PGColorOptionCellSeparatorGray]];
    [self addSubview:downLine2];
    self.downLine2 = downLine2;
    
//    UIView *downLine = [[UIView alloc] initWithFrame:CGRectZero];
//    [downLine setBackgroundColor:[Color color:PGColorOptionCellSeparatorGray]];
//    [self addSubview:downLine];
//    self.downLine = downLine;
    
    [self addSubview:self.weekView];
    
    [collectionView registerClass:[UCFCalendarCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    self.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
}

#pragma mark - 按钮的点击方法
- (void)preButtonClicked:(UIButton *)button
{
    if (self.calendar.contentOffset.x <=0) {
        return;
    }
    CGPoint currentOffSet = self.calendar.contentOffset;
    [self.calendar setContentOffset:CGPointMake(currentOffSet.x - ScreenWidth, 0)];
    self.monthLabel.text = [self setCurrentMonthWithMonth:[self.months objectAtIndex:(int)((currentOffSet.x - ScreenWidth) / ScreenWidth)]];
    [self getClendarInfoWithMonth:[self.months objectAtIndex:(int)(currentOffSet.x/ ScreenWidth)-1]];
}

- (void)nextButtonClicked:(UIButton *)button
{
    if (self.calendar.contentOffset.x/ScreenWidth >= self.months.count-1) {
        return;
    }
    CGPoint currentOffSet = self.calendar.contentOffset;
    [self.calendar setContentOffset:CGPointMake(currentOffSet.x + ScreenWidth, 0)];
    self.monthLabel.text = [self setCurrentMonthWithMonth:[self.months objectAtIndex:(int)((currentOffSet.x + ScreenWidth) / ScreenWidth)]];
    [self getClendarInfoWithMonth:[self.months objectAtIndex:(int)(currentOffSet.x/ ScreenWidth)+1]];
}

- (void)headerButtonClicked:(UIButton *)button
{
//    if (self.headerButton.selected) {
//        self.headerButton.imageView.transform = CGAffineTransformMakeRotation(0);
//    } else {
//        self.headerButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
//    }
    button.selected = !button.selected;
    
    if ([self.delegate respondsToSelector:@selector(calendar:didClickedHeader:)]) {
        [self.delegate calendar:self didClickedHeader:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.calendar.frame = self.calendarView.bounds;
//    CGRect frame = self.frame;
//    frame.size.height = CGRectGetMaxY(_currentDayView.frame);
//    self.frame = frame;
//
    CGFloat offY = CGRectGetMaxY(self.moneyBaseView.frame) + 10;
    self.preButton.frame = CGRectMake(0,offY , 80, 51);
    [self.preButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, _preButton.width - 20- _preButton.imageView.width)];
    self.nextButton.frame = CGRectMake(self.width - 80, offY, 80, 51);
    [self.nextButton setImageEdgeInsets:UIEdgeInsetsMake(0, _nextButton.width - 20 - _nextButton.imageView.width, 0, 20)];
    self.monthLabel.frame = CGRectMake(0, offY, ScreenWidth, 51);
    
    self.downLine1.frame = CGRectMake(0, offY + 50.5, ScreenWidth, 0.5);
    [self bringSubviewToFront:self.downLine1];


    
    self.weekView.frame = CGRectMake(0, offY + 51, ScreenWidth, 51);
    
    self.downLine2.frame = CGRectMake(0, CGRectGetMaxY(self.weekView.frame) - 0.3, ScreenWidth, 0.3);
    self.downLine2.hidden = YES;
    [self bringSubviewToFront:self.downLine2];
    
    self.headerButton.frame = CGRectMake(0, offY + 0.5, ScreenWidth, 51);
    
    self.calendar.frame = CGRectMake(0, 0, ScreenWidth, 276);
    
    CGFloat weekLabelWidth = ScreenWidth / 7.0;
    for (UILabel *label in _weekView.subviews) {
        label.frame = CGRectMake(weekLabelWidth * label.tag, 0, weekLabelWidth, 51);
        switch (label.tag) {
            case 0:
                label.text = @"日";
                break;
                
            case 1:
                label.text = @"一";
                break;
                
            case 2:
                label.text = @"二";
                break;
                
            case 3:
                label.text = @"三";
                break;
                
            case 4:
                label.text = @"四";
                break;
                
            case 5:
                label.text = @"五";
                break;
                
            case 6:
                label.text = @"六";
                break;
        }
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.months.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UCFCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.delegate = self;
    cell.currentDay = self.currentDay;
    cell.month = [self.months objectAtIndex:indexPath.item];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth, 275);
}

#pragma mark - 接受数据
- (void)setCalendarHeaderInfo:(NSDictionary *)calendarHeaderInfo
{
    _calendarHeaderInfo = calendarHeaderInfo;
    
    self.myPaymentLabel.text = [calendarHeaderInfo objectSafeForKey:@"myPayment"];
    self.waitPrincipalLabel.text = [NSString stringWithFormat:@"待收本金 %@",[calendarHeaderInfo objectSafeForKey:@"waitPrincipal"]];
    self.waitInterestLabel.text = [NSString stringWithFormat:@"待收利息 %@",[calendarHeaderInfo objectSafeForKey:@"waitInterest"]];
    self.currentDay = [calendarHeaderInfo objectSafeForKey:@"today"];
    [self setCurrentDayWithDate:self.currentDay];
    [self.months removeAllObjects];
    [self.months addObjectsFromArray:[calendarHeaderInfo objectSafeForKey:@"months"]];
    [self.calendar reloadData];
    if (_months.count > 0) {
        [self setNeedsDisplay];
    }

}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.months.count > 0) {
        BOOL isEnd = YES;
        NSString *currentMonth = [self.currentDay substringToIndex:7];
        for (NSString *month in _months) {
            if (([currentMonth compare:month options:NSLiteralSearch] == NSOrderedSame) || ([currentMonth compare:month options:NSLiteralSearch] == NSOrderedAscending)) {
                NSInteger integer = [_months indexOfObject:month];
                [_calendar scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:integer inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                isEnd = NO;
                self.monthLabel.text = [self setCurrentMonthWithMonth: month];
                [self getClendarInfoWithMonth:month];
                break;
            }
        }
        if (isEnd) {
            [_calendar scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.months.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            self.monthLabel.text = [self setCurrentMonthWithMonth: [self.months lastObject]];
            [self getClendarInfoWithMonth:[self.months lastObject]];
        }
    }
}

- (void)getClendarInfoWithMonth:(NSString *)month {
    self.calendar.pagingEnabled = NO;
    self.calendar.scrollEnabled = NO;
    self.calendar.userInteractionEnabled = NO;
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:SingleUserInfo.loginData.userInfo.userId];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", month, @"month", nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagCalendarInfo owner:self signature:YES Type:self.accoutType];
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSDictionary *dictotal = [result objectFromJSONString];
    NSString *rstcode = [dictotal objectSafeForKey:@"ret"];
//    NSString *rsttext = [dictotal objectSafeForKey:@"message"];
    
    if ([rstcode intValue] == 1) {
        if (tag.intValue == kSXTagCalendarInfo) {
            NSDictionary *data = [dictotal objectSafeDictionaryForKey:@"data"];
            self.repayMoneyLabel.text = [data objectSafeForKey:@"repayMoney"];
            self.paidMoneyLabel.text = [data objectSafeForKey:@"paidMoney"];
            NSArray *days = [data objectSafeArrayForKey:@"days"];
            [self.days removeAllObjects];
            for (NSDictionary *dict in days) {
                UCFCalendarDayInfo *calendarDay = [[UCFCalendarDayInfo alloc] init];
                calendarDay.isAdvanceRepay = [dict objectSafeForKey:@"isAdvanceRepay"];
                calendarDay.paidTime = [dict objectSafeForKey:@"paidTime"];
                [self.days addObject:calendarDay];
            }
            UCFCalendarCollectionViewCell *cell = [[self.calendar visibleCells] lastObject];
            cell.days = self.days;
            
        }
    }
    else{
//        [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
    }
    self.calendar.scrollEnabled = YES;
    self.calendar.pagingEnabled = YES;
    self.calendar.userInteractionEnabled = YES;
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    self.calendar.scrollEnabled = YES;
    self.calendar.pagingEnabled = YES;
    self.calendar.userInteractionEnabled = YES;
}


#pragma mark - FSCalendar的代理方法
- (void)calendar:(UCFCalendarCollectionViewCell *)calendarCell didClickedDay:(NSString *)day
{
    [self setCurrentDayWithDate:day];
    if ([self.delegate respondsToSelector:@selector(calendar:didClickedDay:)]) {
        [self.delegate calendar:calendarCell didClickedDay:day];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.calendar) {
        NSInteger index = scrollView.contentOffset.x / ScreenWidth;
        self.monthLabel.text = [self setCurrentMonthWithMonth:[self.months objectAtIndex:index]];
        [self getClendarInfoWithMonth:[self.months objectAtIndex:index]];
        [self.calendar reloadData];
        self.currentDayLabel.text = nil;
        [self.delegate calendar:[self.calendar.visibleCells lastObject] didClickedDay:nil];
    }
}

- (NSString *)setCurrentMonthWithMonth:(NSString *)month {
    NSDate *currentDate = [self.dateFormatter1 dateFromString:month];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:currentDate];
    return [NSString stringWithFormat:@"%ld年%ld月",(long)[comps year], (long)[comps month]];
}

- (void)setCurrentDayWithDate:(NSString *)date
{
    NSDate *currentDate = [self.dateFormatter dateFromString:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:currentDate];
    _currentDayLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)[comps year],(long)[comps month],(long)[comps day]];
}

- (void)headerViewInitUI {
    self.headerButton.selected = NO;
    self.headerButton.imageView.transform = CGAffineTransformIdentity;
//    [self headerButtonClicked:self.headerButton];
}

@end
