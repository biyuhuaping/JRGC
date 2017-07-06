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

@interface UCFCalendarHeaderView () <UICollectionViewDataSource, UICollectionViewDelegate, NetworkModuleDelegate, UCFCalendarCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) UICollectionView *calendar;

@property (weak, nonatomic) IBOutlet UILabel *myPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitPrincipalLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitInterestLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentDayLabel;

@property (strong, nonatomic) NSMutableArray *months;
@property (weak, nonatomic) IBOutlet UIView *currentDayView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarH;
@property (strong, nonatomic) NSMutableArray *days;

@property (weak, nonatomic) UIButton *preButton;
@property (weak, nonatomic) UIButton *nextButton;
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

static NSString *const cellId = @"cellId";

+ (CGFloat)viewHeight
{
    return 638;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
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
    
    
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setTitle:@"Pre" forState:UIControlStateNormal];
    [preButton addTarget:self action:@selector(preButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [preButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:preButton];
    self.preButton = preButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:nextButton];
    self.nextButton = nextButton;
    
    [collectionView registerClass:[UCFCalendarCollectionViewCell class] forCellWithReuseIdentifier:cellId];
}

#pragma mark - 按钮的点击方法
- (void)preButtonClicked:(UIButton *)button
{
    if (self.calendar.contentOffset.x <=0) {
        return;
    }
    CGPoint currentOffSet = self.calendar.contentOffset;
    [self.calendar setContentOffset:CGPointMake(currentOffSet.x - ScreenWidth, 0)];
}

- (void)nextButtonClicked:(UIButton *)button
{
    if (self.calendar.contentOffset.x/ScreenWidth >= self.months.count-1) {
        return;
    }
    CGPoint currentOffSet = self.calendar.contentOffset;
    [self.calendar setContentOffset:CGPointMake(currentOffSet.x + ScreenWidth, 0)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.calendar.frame = self.calendarView.bounds;
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.currentDayView.frame);
    self.frame = frame;
    
    self.preButton.frame = CGRectMake(0, 160, 80, 44);
    self.nextButton.frame = CGRectMake(self.width - 80, 160, 80, 44);
    [self.calendar bringSubviewToFront:self.preButton];
    
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
    cell.month = [self.months objectAtIndex:indexPath.item];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.calendarView.bounds.size;
}

#pragma mark - 接受数据
- (void)setCalendarHeaderInfo:(NSDictionary *)calendarHeaderInfo
{
    _calendarHeaderInfo = calendarHeaderInfo;
    
    self.myPaymentLabel.text = [calendarHeaderInfo objectSafeForKey:@"myPayment"];
    self.waitPrincipalLabel.text = [calendarHeaderInfo objectSafeForKey:@"waitInterest"];
    self.waitInterestLabel.text = [calendarHeaderInfo objectSafeForKey:@"myPayment"];
    self.currentDay = [calendarHeaderInfo objectSafeForKey:@"today"];
    
    [self.months removeAllObjects];
    [self.months addObjectsFromArray:[calendarHeaderInfo objectSafeForKey:@"months"]];
    [self.calendar reloadData];
    if (_months.count > 0) {
        [self setNeedsDisplay];
    }
}

- (void)setCurrentDay:(NSString *)currentDay
{
    _currentDay = currentDay;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [dateFormatter dateFromString:currentDay];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:currentDate];
    _currentDayLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)[comps year],(long)[comps month],(long)[comps day]];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.months.count > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        BOOL isEnd = YES;
        for (NSString *month in _months) {
            if (([strDate compare:month options:NSLiteralSearch] == NSOrderedSame) || ([strDate compare:month options:NSLiteralSearch] == NSOrderedSame)) {
                NSInteger integer = [_months indexOfObject:month];
                [_calendar scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:integer inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                isEnd = NO;
                [self getClendarInfoWithMonth:month];
                break;
            }
        }
        if (isEnd) {
            [_calendar scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(self.months.count - 1) inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            [self getClendarInfoWithMonth:[self.months lastObject]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentDay" object:nil];
    }
}

- (void)getClendarInfoWithMonth:(NSString *)month {
    NSString *userId = [UCFToolsMehod isNullOrNilWithString:[[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
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
    NSString *rsttext = [dictotal objectSafeForKey:@"message"];
    
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
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    
}

#pragma mark - FSCalendar的代理方法
- (void)calendar:(UCFCalendarCollectionViewCell *)calendarCell didClickedDay:(NSString *)day
{
    self.currentDay = day;
    if ([self.delegate respondsToSelector:@selector(calendar:didClickedDay:)]) {
        [self.delegate calendar:calendarCell didClickedDay:day];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.calendar) {
        NSInteger index = scrollView.contentOffset.x / ScreenWidth;
        [self getClendarInfoWithMonth:[self.months objectAtIndex:index]];
    }
}

@end
