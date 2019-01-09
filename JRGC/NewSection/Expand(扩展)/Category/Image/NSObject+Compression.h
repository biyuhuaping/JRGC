//
//  NSObject+Compression.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Compression)
/**
 *  压缩图片
 *
 *  @param defineWidth 要压缩的目标尺寸
 *
 *  @return 压缩后的图片
 */
- (UIImage *)imageCompressForTargetWidth:(CGFloat)defineWidth;
    
@end
