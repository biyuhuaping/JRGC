//
//  UCFPickView.m
//  JRGC
//
//  Created by njw on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPickView.h"

@interface UCFPickView () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomSpace;
@property (weak, nonatomic) IBOutlet UIPickerView *monthPickerView;

@end

@implementation UCFPickView

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self hidden];
}

- (void)show
{
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = NO;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomViewBottomSpace.constant = 0;
        }];
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = YES;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomViewBottomSpace.constant = -273;
        }];
    }];
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    [_monthPickerView reloadAllComponents];
}
- (void)scrollToThisMonth:(NSString *)month
{
    if ([self.dataArray containsObject:month]) {
        [_monthPickerView selectRow:[self.dataArray indexOfObject:month] inComponent:0 animated:YES];
    } else {
        
    }
}
#pragma mark - pickerView的代理方法
//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
    return self.dataArray.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    NSMutableString *month = [self.dataArray objectAtIndex:row];
    NSString *temp = [month stringByReplacingOccurrencesOfString:@"-" withString:@"年      "];
    return [NSString stringWithFormat:@"%@月", temp];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.currentMonth = [self.dataArray objectAtIndex:row];
}

- (IBAction)pickerSelectedMonth:(UIButton *)sender {
    [self hidden];
    if ([self.delegate respondsToSelector:@selector(pickerView:selectedMonth:withIndex:)]) {
        if (self.currentMonth) {
            [self.delegate pickerView:self selectedMonth:self.currentMonth withIndex:[self.dataArray indexOfObject:self.currentMonth]];
        }
        else {
            [self.delegate pickerView:self selectedMonth:[self.dataArray firstObject] withIndex:0];
        }
    }
}

@end
