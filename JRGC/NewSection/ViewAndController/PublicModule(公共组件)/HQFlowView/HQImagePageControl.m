//
//  HQImagePageControl.m
//  HQCardFlowView
//
//  Created by Mr_Han on 2018/7/24.
//  Copyright © 2018年 Mr_Han. All rights reserved..
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//

#import "HQImagePageControl.h"
#define dotW 8
#define activeDotW 14
#define margin 6
#define activeWidth 34
#define inactiveWidth 14
#define activeHeight 4

@interface HQImagePageControl ()

@property(nonatomic, copy) NSString *type;

@end

@implementation HQImagePageControl

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    //没用上
    activeImage = [UIImage imageNamed:@"icon_pageWidget_sign"];
    inactiveImage = [UIImage imageNamed:@"icon_pageWidget"] ;
    
    return self;
}
-(id)initWithFrame:(CGRect)frame withType:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {

        _type = type;
    }
    return self;
}
-(void)updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        UIView *vi = [self.subviews objectAtIndex:i];
        
        //添加imageView
        if ([vi.subviews count] == 0) {
            UIImageView * view = [[UIImageView alloc]initWithFrame:vi.bounds];
            [vi addSubview:view];
        };
        
        //配置imageView
        UIImageView * view = vi.subviews[0];
        
        if (i == self.currentPage){
            view.image = activeImage;
        } else {
            view.image = inactiveImage;
        }
    }
}

-(void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    //修改图标大小
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = activeHeight;
        if (subviewIndex == page) {
            subview.backgroundColor = [UIColor whiteColor];
            if ([self.type isEqualToString: @"Asset"]) {
                subview.backgroundColor = [Color color:PGColorOptionInputDefaultBlackGray];
            }
            subview.alpha = 1;
            size.width = activeWidth;
            subview.layer.cornerRadius = 2.0f;
        } else {
            subview.backgroundColor = [UIColor whiteColor];
            if ([self.type isEqualToString: @"Asset"]) {
                subview.backgroundColor = [Color color:PGColorOptionInputDefaultBlackGray];
            }
            size.width = inactiveWidth;
            subview.alpha = 0.4;
            subview.layer.cornerRadius = 2.0f;
        }
        
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     
                                     size.width,size.height)];
        
    }
    
    
    //    [self updateDots];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点间距
    CGFloat marginX1 = inactiveWidth + margin;
    CGFloat marginX2 = activeWidth + margin;
    
    //计算整个pageControll的宽度
    CGFloat newW1 = (self.subviews.count - 1 ) * marginX1 + activeDotW;
    
    
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW1, self.frame.size.height);
    
    //设置居中
    CGPoint center = self.center;
    center.x = self.superview.center.x;
    self.center = center;
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (i == self.currentPage) {
            
            [dot setFrame:CGRectMake(i * marginX1, dot.frame.origin.y, activeWidth, activeHeight)];
            
        }else {
            if (i < self.currentPage) {
                [dot setFrame:CGRectMake(i * marginX1, dot.frame.origin.y, inactiveWidth, activeHeight)];
            } else if(i > self.currentPage){
                [dot setFrame:CGRectMake((i-1) * marginX1 + marginX2, dot.frame.origin.y, inactiveWidth, activeHeight)];
            }
            
        }
        
    }
    
}
@end
