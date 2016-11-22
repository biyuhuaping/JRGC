//
//  FaceRectKeyPointView.h
//  Created by DengWuPing on 15/7/17.
//  Copyright (c) 2015年 dengwuping. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface FaceRectKeyPointView : UIView

#define CWKEY_POINTS_KEY @"KEY_Points_KEY" //关键点

#define CWFACERECT_KEY   @"FaceRect_KEY"  //人脸框坐标

#define CWTRACKID_KEY   @"TrackID_KEY"    //跟踪ID

#define CWFACESCORE_KEY   @"FaceScore_KEY"  //人脸质量分数

#define CWFACEBRIGHTNESS_KEY   @"Brightness_KEY" //亮度

#define CWFACEHEADPITCH_KEY   @"HeadPitch_KEY"  //抬头点头

#define CWFACEHEADYAW_KEY   @"HeadYaw_KEY"  //左右转头

#define CWFACEMOUTHOPEN_KEY   @"MouthOpen_KEY"  //张嘴

#define CWFACEBLINK_KEY       @"Blink_KEY"   //眨眼

#define CWFACECLEARNESS_KEY   @"Clearness_KEY"  //人脸清晰度

#define CWFACEGLASSNESS_KEY   @"Glassness_KEY"  //是否戴眼镜

#define CWFACESKINNESS_KEY   @"Skiness_KEY"     //肤色


@property (nonatomic , strong) NSArray * personArray;

@property (nonatomic , assign) CGSize  preLayersize;

@end
