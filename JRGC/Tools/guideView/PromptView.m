//
//  PromptView.m
//  StandardDemo
//
//  Created by tianxuejun on 14-5-26.
//  Copyright (c) 2014年 Sosgps. All rights reserved.
//

#import "PromptView.h"
#import "AppDelegate.h"
@implementation PromptView

- (id)initWithKey:(NSString *)key
{
    return [self initWithKey:key needBackgroundColor:YES];
}

- (id)initWithKey:(NSString *)key needBackgroundColor:(BOOL)needBackgroundColor
{
    return [self initWithKey:key needBackgroundColor:needBackgroundColor isHorizontal:NO];
}

- (id)initWithKey:(NSString *)key needBackgroundColor:(BOOL)needBackgroundColor isHorizontal:(BOOL)isHorizontal
{
    CGRect rect = CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight);
    if (isHorizontal) {
        rect = CGRectMake(0.0f, 0.0f, ScreenHeight, ScreenWidth);
    }
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _key = key;
        rect.origin.y = 0.0f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (needBackgroundColor) {
            button.backgroundColor = [UIColor blackColor];
            button.alpha = 0.5f;
        } else {
            button.backgroundColor = [UIColor clearColor];
        }
        
        button.frame = rect;
        [button addTarget:self
                   action:@selector(removePrompViewButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)dealloc
{
    _key = nil;
}

+ (PromptView *)promptViewWithKey:(NSString *)key
                         delegate:(id<PromptViewDelegate>)delegate
                     showWithImageName:(NSString *)imageName
{
    return [self promptViewWithKey:key delegate:delegate showWithImageName:imageName isHorizontal:NO];
}

+ (PromptView *)promptViewWithKey:(NSString *)key
                         delegate:(id<PromptViewDelegate>)delegate
                showWithImage:(UIImage *)image
{
    PromptView *promptView = [[PromptView alloc] initWithKey:key needBackgroundColor:NO isHorizontal:NO];
    promptView.delegate = delegate;
    UIImage *mainPromptViewImage = image;
    CGFloat ratio = 1.0f;
    if (mainPromptViewImage
        && mainPromptViewImage.size.width > 0
        && mainPromptViewImage.size.height > 0) {
        ratio = mainPromptViewImage.size.width / mainPromptViewImage.size.height;
    }
    [promptView addFullScreenImageWithImage:mainPromptViewImage origin:CGPointMake(0, 0)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [promptView show];
    }
    return promptView;

}

+ (PromptView *)promptViewWithKey:(NSString *)key
                         delegate:(id<PromptViewDelegate>)delegate
                showWithImageName:(NSString *)imageName isHorizontal:(BOOL)isHorizontal
{
    PromptView *promptView = [[PromptView alloc] initWithKey:key needBackgroundColor:NO isHorizontal:isHorizontal];
    promptView.delegate = delegate;
    UIImage *mainPromptViewImage = [UIImage imageNamed:imageName];
    CGFloat ratio = 1.0f;
    if (mainPromptViewImage
        && mainPromptViewImage.size.width > 0
        && mainPromptViewImage.size.height > 0) {
        ratio = mainPromptViewImage.size.width / mainPromptViewImage.size.height;
    }
    float width = ScreenWidth;
    float height = ScreenWidth / ratio;
    if (isHorizontal) {
        width = ScreenWidth * ratio;
        height = ScreenWidth;
    }
 //   CGRect rect = CGRectMake(0, 0, width, height);
    
//    [promptView addImageWithImage:mainPromptViewImage
//                           andFrame:rect];
    [promptView addFullScreenImageWithImage:mainPromptViewImage origin:CGPointMake(0, 0)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        [promptView show];
    }
    return promptView;
}

- (void)show
{
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.window.rootViewController.view addSubview:self];
}

- (void)addImageWithImage:(UIImage *)image origin:(CGPoint)origin
{
    CGRect rect = CGRectMake(origin.x, origin.y,
                             image.size.width, image.size.height);
    [self addImageWithImage:image andFrame:rect];
}

- (void)addImageWithImage:(UIImage *)image andFrame:(CGRect)rect
{
    UIImageView *promptImageView = [[UIImageView alloc] initWithFrame:rect];
    promptImageView.image = image;
    [self addSubview:promptImageView];
}

- (void)addFullScreenImageWithImage:(UIImage *)image origin:(CGPoint)origin
{
    CGRect rect = CGRectMake(origin.x, origin.y, ScreenWidth, ScreenHeight);
    UIImageView *promptImageView = [[UIImageView alloc] initWithFrame:rect];
    promptImageView.image = image;
    [self addSubview:promptImageView];
}

- (void)removePrompViewButtonClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:_key];
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_delegate handlePromptViewRemovedEvent:self];
    }];
}

+ (PromptView *)addGuideViewWithKey:(NSString *)key isHorizontal:(BOOL)isHorizontal delegate:(id<PromptViewDelegate>)delegate imageBlock:(ShowImageBlock)imageBlock isFirstPage:(BOOL)firstPage
{
    if ([GUIDE_OPEN isEqualToString:@"1"] || firstPage) {
        NSString *imageName = imageBlock();
        BOOL isShowAllTheTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"showguidealltime"];
        if (![[NSUserDefaults standardUserDefaults] valueForKey:key]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (isShowAllTheTime) {
                return [PromptView promptViewWithKey:key
                                     delegate:delegate
                            showWithImageName:imageName isHorizontal:isHorizontal];
            } else if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"promitDic"] valueForKey:key]) {
                return [PromptView promptViewWithKey:key
                                         delegate:delegate
                                showWithImageName:imageName isHorizontal:isHorizontal];
            }
        } else {
            if (isShowAllTheTime) {
                return [PromptView promptViewWithKey:key
                                     delegate:delegate
                            showWithImageName:imageName isHorizontal:isHorizontal];
            }
        }
    }
    return nil;
}

+ (PromptView *)addGuideViewWithKey:(NSString *)key delegate:(id<PromptViewDelegate>)delegate imageBlock:(GetImageBlock)imageBlock;
{
    if (GUIDE_OPEN) {
        UIImage *image = imageBlock();
        BOOL isShowAllTheTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"showguidealltime"];
        if (![[NSUserDefaults standardUserDefaults] valueForKey:key]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (isShowAllTheTime) {
                return [PromptView promptViewWithKey:key delegate:delegate showWithImage:image];
            } else if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"promitDic"] valueForKey:key]) {
                return [PromptView promptViewWithKey:key delegate:delegate showWithImage:image];
            }
        } else {
            if (isShowAllTheTime) {
                return [PromptView promptViewWithKey:key delegate:delegate showWithImage:image];
            }
        }
    }
    return nil;
}


@end
