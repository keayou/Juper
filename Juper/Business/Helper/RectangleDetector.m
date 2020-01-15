//
//  RectangleDetector.m
//  PaintingAR
//
//  Created by fk on 2019/6/25.
//  Copyright © 2019 fk. All rights reserved.
//

#import "RectangleDetector.h"
#import <Vision/Vision.h>

#import "Utilities.h"

@interface RectangleDetector ()

@property (nonatomic, assign) BOOL isBusy;

@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RectangleDetector

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _previewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
    return self;
}

- (void)startDetetion
{
    [_timer invalidate];
    _timer = nil;
    
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (!weakSelf.arSession) {
            return;
        }
        CVPixelBufferRef pixelBuff = weakSelf.arSession.currentFrame.capturedImage;
        if (pixelBuff) {
            [weakSelf searchRectangleInPixelBuffer:pixelBuff];
        }
    }];
}

- (void)searchRectangleInPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (_isBusy) return;

    _isBusy = YES;
    
    _pixelBuffer = pixelBuffer;
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:pixelBuffer orientation:(kCGImagePropertyOrientationUp) options:@{}];
    __weak typeof(self) weakSelf = self;
    VNDetectRectanglesRequest *rectRequest = [[VNDetectRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        [weakSelf processRectangleRequest:(VNDetectRectanglesRequest *)request error:error];
    }];
    rectRequest.maximumObservations = 1;
    rectRequest.minimumSize = 0.3;
    rectRequest.minimumConfidence = 0.85;
    rectRequest.minimumAspectRatio = 0.3;
    rectRequest.quadratureTolerance = 20;
    rectRequest.usesCPUOnly = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error = nil;
        @try {
            [handler performRequests:@[rectRequest] error:&error];
        } @catch (NSException *exception) {
            NSLog(@"%@ -- %@ -- %s",error,NSStringFromClass([self class]),__func__);
        } @finally {
        }
    });
}

- (void)processRectangleRequest:(VNDetectRectanglesRequest *)vnRequest error:(NSError *)error {
    
    if (![vnRequest isKindOfClass:[VNDetectRectanglesRequest class]]) {
        _isBusy = NO;
        return;
    }
    if (error) {
        NSLog(@"%@ -- %@ -- %s",error,NSStringFromClass([self class]),__func__);
        _isBusy = NO;
        return;
    }
    
    VNRectangleObservation *rectangle = vnRequest.results.firstObject;
    
    if (![rectangle isKindOfClass:[VNRectangleObservation class]]) {
        NSLog(@"Error: Rectangle detection failed - Vision request returned an error");
        _isBusy = NO;
        return;
    }
    
    // 获取UI坐标系四个角点
    CGFloat previewWidth = _previewSize.width;
    CGFloat previewHeight = _previewSize.height;

    CGPoint previewTopLeft  = CGPointMake(rectangle.topRight.y * previewWidth, previewHeight - rectangle.topRight.x * previewHeight );
    CGPoint previewTopRight = CGPointMake(rectangle.bottomRight.y * previewWidth , previewHeight - rectangle.bottomRight.x * previewHeight);
    CGPoint previewBottomRight = CGPointMake(rectangle.bottomLeft.y * previewWidth, previewHeight - rectangle.bottomLeft.x * previewHeight);
    CGPoint previewBottomLeft = CGPointMake(rectangle.topLeft.y * previewWidth, previewHeight - rectangle.topLeft.x * previewHeight);

//    CGPoint previewTopLeft = CGPointMake(rectangle.topLeft.x * previewWidth , previewHeight - rectangle.topLeft.y * previewHeight);
//    CGPoint previewTopRight = CGPointMake(rectangle.topRight.x * previewWidth , previewHeight - rectangle.topRight.y * previewHeight);
//    CGPoint previewBottomLeft = CGPointMake(rectangle.bottomLeft.x * previewWidth, previewHeight - rectangle.bottomLeft.y * previewHeight);
//    CGPoint previewBottomRight = CGPointMake(rectangle.bottomRight.x * previewWidth , previewHeight - rectangle.bottomRight.y * previewHeight);

    
    NSArray *list = @[[NSValue valueWithCGPoint:previewTopLeft],
                      [NSValue valueWithCGPoint:previewTopRight],
                      [NSValue valueWithCGPoint:previewBottomRight],
                      [NSValue valueWithCGPoint:previewBottomLeft]
                      ];


    // 获取矫正后的矩形区域
    CIFilter *filter = [CIFilter filterWithName:@"CIPerspectiveCorrection"];

    CGFloat width = CVPixelBufferGetWidth(_pixelBuffer);
    CGFloat height = CVPixelBufferGetHeight(_pixelBuffer);

    CGPoint topLeft = CGPointMake([self subtractOffset:70 originStart:rectangle.topLeft.x * width],
                                  [self additionOffset:70 originStart:rectangle.topLeft.y * height max:height]);

    CGPoint topRight = CGPointMake([self additionOffset:70 originStart:rectangle.topRight.x * width max:width],
                                   [self additionOffset:70 originStart:rectangle.topRight.y * height max:height]);

    CGPoint bottomLeft = CGPointMake([self subtractOffset:70 originStart:rectangle.bottomLeft.x * width],
                                     [self subtractOffset:70 originStart:rectangle.bottomLeft.y * height]);

    CGPoint bottomRight = CGPointMake([self additionOffset:70 originStart:rectangle.bottomRight.x * width max:width],
                                      [self subtractOffset:70 originStart:rectangle.bottomRight.y * height]);

    [filter setValue:[CIVector vectorWithCGPoint:topLeft] forKey:@"inputTopLeft"];
    [filter setValue:[CIVector vectorWithCGPoint:topRight] forKey:@"inputTopRight"];
    [filter setValue:[CIVector vectorWithCGPoint:bottomLeft] forKey:@"inputBottomLeft"];
    [filter setValue:[CIVector vectorWithCGPoint:bottomRight] forKey:@"inputBottomRight"];

    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:_pixelBuffer];
    ciImage = [ciImage imageByApplyingCGOrientation:kCGImagePropertyOrientationUp];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    CIImage *perspectiveImage = [filter valueForKey:kCIOutputImageKey];

    if (perspectiveImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(didDetecteRectangle:trackingImage:)]) {
                [self.delegate didDetecteRectangle:list trackingImage:perspectiveImage];
            }
        });
    }
    _isBusy = NO;
}

- (CGFloat)additionOffset:(CGFloat)offset originStart:(CGFloat)start max:(CGFloat)max {
    CGFloat an = start + offset;
    return an > max ? max : an;
}

- (CGFloat)subtractOffset:(CGFloat)offset originStart:(CGFloat)start {
    CGFloat an = start - offset;
    return an < 0 ? 0 : an;
}

#pragma mark - Lazy Init



@end
