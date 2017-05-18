//
//  UCFNoticeView.h
//  JRGC
//
//  Created by njw on 2017/5/18.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFNoticeView : UIView
@property (nonatomic, copy) NSString *noticeStr;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@end
