//
//  JPARViewController+ARDelegate.m
//  Juper
//
//  Created by fk on 2020/1/14.
//  Copyright © 2020 fk. All rights reserved.
//

#import "JPARViewController+ARDelegate.h"
#import "RectangleDetector.h"


@implementation JPARViewController (ARDelegate)


#pragma mark - ARSCNViewDelegate
//// Override to create and configure nodes for anchors added to the view's session.
//- (SCNNode *)renderer:(id<SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor {
//    SCNNode *node = [SCNNode new];
//
//    // Add geometry to the node...
//
//    return node;
//}

- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (self.trakingType == ARTrackingType_image && self.imgPlaneNode) {
        ARImageAnchor *imageAnchor = (ARImageAnchor *)anchor;
        if ([imageAnchor isKindOfClass:[ARImageAnchor class]] && imageAnchor.referenceImage == self.refeImage) {
            [node addChildNode:self.imgPlaneNode];
        }
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (node == self.imgPlaneNode) {
        self.imgPlaneNode = nil;
    }
    [node.childNodes enumerateObjectsUsingBlock:^(SCNNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (node == self.imgPlaneNode) {
            self.imgPlaneNode = nil;
            *stop = YES;
        }
    }];
}

#pragma mark - ARSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame {
    if (self.trakingType == ARTrackingType_image) {
        
//        CVPixelBufferRef pixelBuff = frame.capturedImage;
//        [self.rectDetetor searchRectangleInPixelBuffer:pixelBuff];
        
    } else if (self.trakingType == ARTrackingType_verticalPlane || self.trakingType == ARTrackingType_horizontalPlane ) {
    }
}

- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors {
    NSLog(@"%s",__func__);
}

- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors {
    NSLog(@"%s",__func__);
}

- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors {
    NSLog(@"%s",__func__);
}

#pragma mark - ARSessionObserver
- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    self.imgPlaneNode = nil;
    if (error.code == ARErrorCodeInvalidReferenceImage) {
        NSLog(@"Error: The detected rectangle cannot be tracked.");
        [self startImageTrackingConfiguration:nil];
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@ -- %@ -- %@",error.localizedDescription,error.localizedFailureReason,error.localizedRecoverySuggestion];
    NSLog(@"%@ -- %@",NSStringFromClass([self class]),str);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Restart" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self startImageTrackingConfiguration:nil];
        }];
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:str preferredStyle:(UIAlertControllerStyleAlert)];
        [alertVc addAction:action];
        [self presentViewController:alertVc animated:YES completion:nil];
    });
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
}

@end
