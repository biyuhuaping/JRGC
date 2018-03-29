//
//  UIImageView+UcfLib.h
//  UcfLib
//
//  Created by 杨名宇 on 29/11/2016.
//  Copyright © 2016 Ucf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UcfLib)

- (void)setImageWithUrl:(NSString *)imgUrl andPlaceholderImg:(UIImage *)image;

- (void)setImageWithUrl:(NSString *)imgUrl andPlaceholderUrl:(NSString *)placeholderUrl;

- (void)setImageWithUrl:(NSString *)imgUrl andPlaceholderUrl:(NSString *)placeholderUrl repeatCount:(float)count finish:(void (^)(NSString* imgType))finish;

@end
