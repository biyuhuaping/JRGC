//
//  BJGridItem.m
//  ZakerLike
//
//  Created by bupo Jung on 12-5-15.
//  Copyright (c) 2012年 Wuxi Smart Sencing Star. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BJGridItem.h"

@implementation BJGridItem
@synthesize isEditing,isRemovable,index;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithTitle:(NSString *)title withImageName:(NSString *)imageName atIndex:(NSInteger)aIndex editable:(BOOL)removable {
    self = [super initWithFrame:CGRectMake(0, 0, 64, 64)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        normalImage = [UIImage imageNamed:imageName];
        titleText = title;
        self.isEditing = NO;
        index = aIndex;
        self.isRemovable = removable;
        

        // place a clickable button on top of everything
        button = [[UIImageView alloc] init];
        button.image = [UIImage imageNamed:imageName];
        //循环创建UIImage并添加到数组中
//        NSMutableArray *arrayM = [NSMutableArray array];
//        for (int i = 0; i < 12; i++) {
//            //拼接图片名称
//            NSString *imgName = [NSString stringWithFormat:@"package_%d.png",i+1];
//            
//            //根据图片路径加载图片数据
//            UIImage *imgTemp = [UIImage imageNamed:imgName];
//            
//            //将图片名存储到数组
//            [arrayM addObject:imgTemp];
//        }
//        
//        //为animationImages属性赋值一个数组
//        button.animationImages = arrayM;
//        
//        //设置帧动画播放时间
//        button.animationDuration = arrayM.count * 0.1;
//        
//        //设置帧动画播放次数
//        button.animationRepeatCount = 0;
//        
//        //开启动画
//        [button startAnimating];
        
        [button setFrame:self.bounds];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [button addGestureRecognizer:tapGes];
        
        [button setUserInteractionEnabled:YES];
//        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
//        [button setBackgroundColor:[UIColor clearColor]];
//        [button setTitle:titleText forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *longPress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPress];
        longPress = nil;
        [self addSubview:button];
        
        if (self.isRemovable) {
            // place a remove button on top right corner for removing item from the board
            deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            float w = 20;
            float h = 20;
            
            [deleteButton setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, w, h)];
            [deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
            deleteButton.backgroundColor = [UIColor clearColor];
            [deleteButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setHidden:YES];
            [self addSubview:deleteButton];
        }
    }
    return self;
}

#pragma mark - UI actions

- (void) clickItem:(id)sender {
    [delegate gridItemDidClicked:self];
}
- (void) pressedLong:(UILongPressGestureRecognizer *) gestureRecognizer{
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            point = [gestureRecognizer locationInView:self];
            [delegate gridItemDidEnterEditingMode:self];
            //放大这个item
            [self setAlpha:1.0];
            DLog(@"press long began");
            break;
        case UIGestureRecognizerStateEnded:
            point = [gestureRecognizer locationInView:self];
            [delegate gridItemDidEndMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
            //变回原来大小
            //[self setAlpha:0.5f];
            DLog(@"press long ended");
            break;
        case UIGestureRecognizerStateFailed:
            DLog(@"press long failed");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            
            [delegate gridItemDidMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
            DLog(@"press long changed");
            break;
        default:
            DLog(@"press long else");
            break;
    }
}

- (void) removeButtonClicked:(id) sender  {
    [delegate gridItemDidDeleted:self atIndex:index];
}

#pragma mark - Custom Methods

- (void) enableEditing {
    
    if (self.isEditing == YES)
        return;
    
    // put item in editing mode
    self.isEditing = YES;
    
    // make the remove button visible
    [deleteButton setHidden:NO];
    [button setUserInteractionEnabled:NO];
    // start the wiggling animation
    CGFloat rotation = 0.03;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];    
}

- (void) disableEditing {
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [deleteButton setHidden:YES];
    [button setUserInteractionEnabled:YES];
    self.isEditing = NO;
}

# pragma mark - Overriding UiView Methods

- (void) removeFromSuperview {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
        [self setFrame:CGRectMake(self.frame.origin.x+50, self.frame.origin.y+50, 0, 0)];
        [deleteButton setFrame:CGRectMake(0, 0, 0, 0)];
    }completion:^(BOOL finished) {
        [super removeFromSuperview];
    }]; 
}

@end
