//
//  FaceRectKeyPointView.m
//  Created by DengWuPing on 15/7/17.
//  Copyright (c) 2015年 dengwuping. All rights reserved.
//
#import "FaceRectKeyPointView.h"

@implementation FaceRectKeyPointView
{
    CGContextRef context ;
}

- (void)drawRect:(CGRect)rect {
    
    [self drawPointWithPoints:self.personArray] ;
}

-(void)drawPointWithPoints:(NSArray *)arrPersons
{
    if (context) {
        CGContextClearRect(context, self.bounds) ;
    }
    context = UIGraphicsGetCurrentContext();
    
    float xScal = self.preLayersize.width / 480;
    float yscal = self.preLayersize.height /640;
    
    float sizeScale = xScal >= yscal ? xScal : yscal;

    if (self.personArray != nil) {
        for (int i = 0; i<self.personArray.count; i++) {
            
            NSDictionary *dicPerson = [self.personArray objectAtIndex:i];
            //人脸关键点
            if ([dicPerson objectForKey:CWKEY_POINTS_KEY]) {
                
                for (NSString *strPoints in [dicPerson objectForKey:CWKEY_POINTS_KEY]) {
                    
                    CGPoint keyPoint = CGPointFromString(strPoints) ;
                    
                    CGContextAddEllipseInRect(context, CGRectMake(keyPoint.x*xScal, keyPoint.y*yscal, 2 , 2));
                }
            }
            
            CGRect  rect = CGRectZero;
            
            float origionx = 0;
            //人脸匡
            if ([dicPerson objectForKey:CWFACERECT_KEY] !=nil) {
                rect = CGRectFromString([dicPerson objectForKey:CWFACERECT_KEY]);
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    origionx = rect.origin.x * xScal;
                }else if(self.preLayersize.width < 480){
                    origionx = rect.origin.x * xScal -10 ;
                }else{
                    origionx = rect.origin.x * xScal;
                }
                
                rect = CGRectMake(origionx, rect.origin.y * yscal, rect.size.width * sizeScale, rect.size.height * sizeScale);
                
                CGContextAddRect(context,rect ) ;
            }
            
            CGFloat width = rect.size.width /6;

            //人脸跟踪ID
            if ([dicPerson objectForKey:CWTRACKID_KEY] != nil && (![[dicPerson objectForKey:CWTRACKID_KEY] isEqualToString:@"-1"])) {
                
                UIFont  *font = [UIFont boldSystemFontOfSize:18.f];//设置
                
                NSDictionary  * dict = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor greenColor]};
                
                [self strDraw:[dicPerson objectForKey:CWTRACKID_KEY] rect:CGRectMake(rect.origin.x, rect.origin.y-30, width, 40) Dict:dict];
            }
            UIFont  *font = [UIFont systemFontOfSize:15.f];//设置
            NSDictionary  * dict = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor greenColor]};
            //人脸质量分数
            if ([dicPerson objectForKey:CWFACESCORE_KEY] !=nil ) {
                [self strDraw:[dicPerson objectForKey:CWFACESCORE_KEY] rect:CGRectMake(rect.origin.x+width *5, rect.origin.y-30, 50, 40) Dict:dict];
            }
            //抬头
            if ([dicPerson objectForKey:CWFACEHEADPITCH_KEY] !=nil ) {
                if ([[dicPerson objectForKey:CWFACEHEADPITCH_KEY] intValue] ==1) {
                    [self strDraw:@"抬;" rect:CGRectMake(rect.origin.x+width, rect.origin.y-30,width, 40)  Dict:dict];
                }else if ([[dicPerson objectForKey:CWFACEHEADPITCH_KEY] intValue] == -1){
                    [self strDraw:@"低;" rect:CGRectMake(rect.origin.x+width, rect.origin.y-30, width, 40)  Dict:dict];
                }
            }else{
                  [self strDraw:@"_;" rect:CGRectMake(rect.origin.x+width, rect.origin.y-30,width, 40)  Dict:dict];
            }
            //转头
            if ([dicPerson objectForKey:CWFACEHEADYAW_KEY] !=nil ) {
                
                //左转
                if ([[dicPerson objectForKey:CWFACEHEADYAW_KEY] intValue] ==1) {
                    [self strDraw:@"左;" rect:CGRectMake(rect.origin.x+width*2, rect.origin.y-30, width, 40)  Dict:dict];
                    
                }else if ([[dicPerson objectForKey:CWFACEHEADYAW_KEY] intValue] ==-1){
                    //右转
                    [self strDraw:@"右;" rect:CGRectMake(rect.origin.x+width*2, rect.origin.y-30, width, 40)  Dict:dict];
                }
            }else{
                [self strDraw:@"_;" rect:CGRectMake(rect.origin.x+width*2, rect.origin.y-30, width, 40)  Dict:dict];
            }
            //张嘴
            if ([dicPerson objectForKey:CWFACEMOUTHOPEN_KEY] !=nil ) {
                [self strDraw:@"张;" rect:CGRectMake(rect.origin.x+width*3, rect.origin.y-30, width, 40)  Dict:dict];
            }else{
                 [self strDraw:@"_;" rect:CGRectMake(rect.origin.x+width*3, rect.origin.y-30, width, 40)  Dict:dict];
            }
            //眨眼
            if ([dicPerson objectForKey:CWFACEBLINK_KEY] !=nil ) {
                [self strDraw:@"眨;" rect:CGRectMake(rect.origin.x+width*4, rect.origin.y-30, width, 40)  Dict:dict];
            }else{
                 [self strDraw:@"_;" rect:CGRectMake(rect.origin.x+width*4, rect.origin.y-30, width, 40)  Dict:dict];
            }
        }
        
        [[UIColor greenColor] set];
        CGContextSetLineWidth(context, 2);
        CGContextStrokePath(context);
    }
}

-(void)strDraw:(NSString *)str rect:(CGRect)rect Dict:(NSDictionary *)dict{
    [str  drawInRect:rect withAttributes:dict];
}

@end
