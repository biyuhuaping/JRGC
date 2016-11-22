//
//  PromptView.h
//  StandardDemo
//
//  Created by tianxuejun on 14-5-26.
//  Copyright (c) 2014年 Sosgps. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString * (^ShowImageBlock)(void);
typedef UIImage *(^GetImageBlock)(void);

@class PromptView;

@protocol PromptViewDelegate <NSObject>

- (void)handlePromptViewRemovedEvent:(PromptView *)promptView;

@end

@interface PromptView : UIView {
    NSString *_key;
}

@property (nonatomic, assign) id<PromptViewDelegate> delegate;

- (id)initWithKey:(NSString *)key;
- (id)initWithKey:(NSString *)key needBackgroundColor:(BOOL)needBackgroundColor;
+ (PromptView *)promptViewWithKey:(NSString *)key
                         delegate:(id<PromptViewDelegate>)delegate
                showWithImageName:(NSString *)imageName;
+ (PromptView *)promptViewWithKey:(NSString *)key
                         delegate:(id<PromptViewDelegate>)delegate
                showWithImageName:(NSString *)imageName isHorizontal:(BOOL)isHorizontal;
- (id)initWithKey:(NSString *)key needBackgroundColor:(BOOL)needBackgroundColor isHorizontal:(BOOL)isHorizontal;
- (void)show;
- (void)addImageWithName:(NSString *)imageName origin:(CGPoint)origin;
- (void)addImageWithImage:(UIImage *)image origin:(CGPoint)origin;
- (void)addImageWithImage:(UIImage *)image andFrame:(CGRect)rect;
- (void)addFullScreenImageWithImage:(UIImage *)image origin:(CGPoint)origin;

+ (PromptView *)addGuideViewWithKey:(NSString *)key isHorizontal:(BOOL)isHorizontal delegate:(id<PromptViewDelegate>)delegate imageBlock:(ShowImageBlock)imageBlock isFirstPage:(BOOL)firstPage;

+ (PromptView *)addGuideViewWithKey:(NSString *)key delegate:(id<PromptViewDelegate>)delegate imageBlock:(GetImageBlock)imageBlock;
+ (PromptView *)promptViewWithKey:(NSString *)key
                         delegate:(id<PromptViewDelegate>)delegate
                showWithImage:(UIImage *)image;
@end
