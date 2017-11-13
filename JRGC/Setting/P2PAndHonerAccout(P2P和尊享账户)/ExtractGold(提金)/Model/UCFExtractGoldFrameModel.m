//
//  UCFExtractGoldFrameModel.m
//  JRGC
//
//  Created by njw on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFExtractGoldFrameModel.h"
#import "UCFExtractGoldModel.h"
#import "UCFExtractGoldItemModel.h"

@interface UCFExtractGoldFrameModel ()
@property (nonatomic, strong) UCFExtractGoldModel *model;
@property (nonatomic, assign) CGFloat cellH;
@end

@implementation UCFExtractGoldFrameModel
+ (instancetype)extractGoldFrameWithModel:(UCFExtractGoldModel *)extractGoldModel
{
    return  [[self alloc] initWithModel:extractGoldModel];
}

-(id)initWithModel:(UCFExtractGoldModel *)model
{
    if (self = [super init])
    {
        self.model = model;
        [self caculateUIFrame];
    }
    return self;
}

- (void)caculateUIFrame
{
    _cellH = 0;
    _cellH += 37;
    _cellH += 24;
    _cellH += 28.5*3;
    NSInteger count = _model.details.count;
    _cellH += (count * 14.5 + (count + 1) * 7);
    NSString *status = _model.status;
    if ([status isEqualToString:@"00"] || [status isEqualToString:@"20"]) {
        _cellH += 37;
    }
    _cellH += 10;
}

- (UCFExtractGoldModel *)item
{
    return self.model;
}

- (CGFloat)cellHeight
{
    return self.cellH;
}

@end
