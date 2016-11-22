//
//  UCFTextField.h
//  testfileView
//
//  Created by 战神归来 on 15/8/18.
//  Copyright (c) 2015年 xiangha. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  先继承UCFTextField，
 *  UCFTextField 添加到视图后调用然后用实例去调用 [_textFileView createKeyBoard];
 *  如果该页面有多个 输入框，只调用一次即可
 */
@interface UCFTextField : UITextField
- (void)createKeyBoard;
@end
