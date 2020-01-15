//
//  JPARViewController.h
//  Juper
//
//  Created by fk on 2020/1/14.
//  Copyright © 2020 fk. All rights reserved.
//

#import "JPViewController.h"
#import <ARKit/ARKit.h>
#import "RectangleDetector.h"

typedef NS_ENUM(NSUInteger, ARTrackingType) {
    ARTrackingType_image = 120,
    ARTrackingType_horizontalPlane,
    ARTrackingType_verticalPlane
};


@interface JPARViewController : JPViewController


@property (nonatomic, assign) ARTrackingType trakingType;
@property (nonatomic, strong) RectangleDetector *rectDetetor;
@property (nonatomic, strong) ARReferenceImage *refeImage;
@property (nonatomic, strong) SCNNode *imgPlaneNode;

- (instancetype)initWithImage:(UIImage *)image;

- (void)startImageTrackingConfiguration:(ARReferenceImage *)refImage;
//- (void)startPlaneTrackingConfiguration:(ARPlaneDetection)planeDetection;

@end

