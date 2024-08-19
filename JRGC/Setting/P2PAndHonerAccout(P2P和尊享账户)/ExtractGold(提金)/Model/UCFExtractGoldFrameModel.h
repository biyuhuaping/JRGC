//
//  UCFExtractGoldFrameModel.h
//  JRGC
//
//  Created by njw on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UCFExtractGoldModel;
@interface UCFExtractGoldFrameModel : NSObject
+ (instancetype)extractGoldFrameWithModel:(UCFExtractGoldModel *)extractGoldModel;
- (UCFExtractGoldModel *)item;
- (CGFloat)cellHeight;
@end
