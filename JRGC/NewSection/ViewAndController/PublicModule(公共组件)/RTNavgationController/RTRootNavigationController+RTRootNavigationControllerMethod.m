//
//  RTRootNavigationController+RTRootNavigationControllerMethod.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "RTRootNavigationController+RTRootNavigationControllerMethod.h"

@implementation RTRootNavigationController (RTRootNavigationControllerMethod)
- (void)removeViewControllerOnTheFormer
{
    NSMutableArray<__kindof UIViewController *> *controllers = [self.viewControllers mutableCopy];
    
    if(controllers.count>2){
        NSMutableArray*mutableArryTemp = [[NSMutableArray alloc]init];
        for(int m =0 ;m<controllers.count-2;m++){
            UIViewController *controllerTemp = [controllers objectAtIndex:m];
            [mutableArryTemp addObject:controllerTemp];
        }
        //    UIViewController *controllerRoot = [controllers objectAtIndex:_indext];
        UIViewController *controllerTop = [controllers lastObject];
        [mutableArryTemp addObject:controllerTop];
        
        //    [super setViewControllers:[NSArray arrayWithObjects:controllerRoot,controllerTop,nil] animated:flag];
        [super setViewControllers:mutableArryTemp animated:NO];
        
    }
}
- (void)removeViewControllerToRootanimated:(BOOL)animated
{
    NSMutableArray<__kindof UIViewController *> *controllers = [self.viewControllers mutableCopy];
    UIViewController *controllerRoot = [controllers objectAtIndex:0];
    UIViewController *controllerTop = [controllers lastObject];
    
    [super setViewControllers:[NSArray arrayWithObjects:controllerRoot,controllerTop,nil] animated:animated];
    
    
}


@end
