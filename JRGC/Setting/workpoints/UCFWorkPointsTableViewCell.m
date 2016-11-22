//
//  UCFWorkPointsTableViewCell.m
//  JRGC
//
//  Created by 狂战之巅 on 16/4/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFWorkPointsTableViewCell.h"
#import "UIDic+Safe.h"

@interface UCFWorkPointsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lable_point;//工分 （红进，绿出）
@property (weak, nonatomic) IBOutlet UILabel *lable_date;//使用时间
@property (weak, nonatomic) IBOutlet UILabel *lable_showTxt;//文字信息

@end
@implementation UCFWorkPointsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)reloadCellData:(NSDictionary *)dic
{
    if ([dic isKindOfClass:[NSDictionary class]] && [dic count] > 0) {
        
        if([[dic objectSafeForKey:@"cashAmount"]intValue]>0)
        {
            self.lable_point.textColor = UIColorWithRGB(0xfd4c4c);
            self.lable_point.text= [NSString stringWithFormat:@"+%@",[dic objectSafeForKey:@"cashAmount"]];
        }else if([[dic objectSafeForKey:@"cashAmount"]intValue]<0){
            self.lable_point.textColor = UIColorWithRGB(0x40AD3D);
            self.lable_point.text= [NSString stringWithFormat:@"%@",[dic objectSafeForKey:@"cashAmount"]];
        }
      self.lable_date.text= [self cutDate:[dic objectSafeForKey:@"createtime"] ];
      self.lable_showTxt.text=[dic objectSafeForKey:@"remark"];
    }
}
//只要时间到日 截取小时和分钟等数据 如：2016-04-04
-(NSString*)cutDate:(id)_date
{
    NSString*timeYouGet = [NSString stringWithFormat:@"%@",_date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDate *updatetimestamp = nil;
    if([timeYouGet length]==13){//时间戳有10位和13位的分开判断
        updatetimestamp = [NSDate dateWithTimeIntervalSince1970:[timeYouGet doubleValue] / 1000];
    }else{
        updatetimestamp = [NSDate dateWithTimeIntervalSince1970:[timeYouGet doubleValue]];
    }
   
  
    NSString *confromTimespStr = [formatter stringFromDate:updatetimestamp];
    NSString *strByCut = [confromTimespStr substringToIndex:10];
    return strByCut;
}
@end
