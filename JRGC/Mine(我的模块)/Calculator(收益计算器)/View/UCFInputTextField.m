//
//  UCFInputTextField.m
//  JRGC
//
//  Created by njw on 2017/12/12.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFInputTextField.h"

@implementation UCFInputTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    if(action ==@selector(paste:))//禁止粘贴
        
        return NO;
    
    if(action ==@selector(select:))// 禁止选择
        
        return NO;
    
    if(action ==@selector(selectAll:))// 禁止全选
        
        return NO;
    
    return[super canPerformAction:action withSender:sender];
    
}

@end
