//
//  JRGCMenuItemModel.h
//  JRGCDemo
//
//  Created by NJW on 16/4/18.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFMenuItemModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSNumber *itemId;
@property (nonatomic, assign) BOOL hasWarningNum;
@end
