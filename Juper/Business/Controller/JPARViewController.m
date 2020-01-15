//
//  JPARViewController.m
//  Juper
//
//  Created by fk on 2020/1/14.
//  Copyright © 2020 fk. All rights reserved.
//

#import "JPARViewController.h"

#import "JPARViewController+ARDelegate.h"

#import "Utilities.h"

@interface JPARViewController ()<ARSCNViewDelegate,ARSessionDelegate,RectangleDetectorDelegate>

@property (nonatomic, strong) ARSCNView *arSCNView;

@property (nonatomic, strong) UIImage *paintingImage;

@end

@implementation JPARViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        _paintingImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGSize size = CGSizeMake(_paintingImage.size.width + 100 * 2, _paintingImage.size.height + 100 * 2);
//    UIGraphicsBeginImageContext(size);
//    [_paintingImage drawInRect:CGRectMake(100, 100, _paintingImage.size.width, _paintingImage.size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    _paintingImage = newImage;
    
    [self loadUI];

    self.trakingType = ARTrackingType_image;
    
    [self startImageTrackingConfiguration:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.arSCNView.session pause];
}

#pragma mark - UI
- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.arSCNView];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setSize:CGSizeMake(80, 40)];
    backBtn.left = 40;
    backBtn.top = 40;
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = 4.0;
    backBtn.backgroundColor = [UIColor blueColor];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resetBtn setSize:CGSizeMake(80, 40)];
    resetBtn.right = self.view.width - 40;
    resetBtn.top = 40;
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    resetBtn.layer.cornerRadius = 4.0;
    resetBtn.backgroundColor = [UIColor blueColor];
    [resetBtn addTarget:self action:@selector(resetBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
    
//    NSArray *array = [NSArray arrayWithObjects:@"矩形",@"地板",@"墙面", nil];
//    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
//    segment.frame = CGRectMake(10, StatusBarHeightReal, self.view.frame.size.width - 20, 30);
//    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
//    segment.selectedSegmentIndex = 0;
//    [self.view addSubview:segment];
}

#pragma mark -Events
- (void)backBtnClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetBtnClicked:(UIButton *)sender
{
    [_imgPlaneNode removeFromParentNode];
    _imgPlaneNode = nil;
    [self startImageTrackingConfiguration:nil];
}

#pragma mark - Private
- (void)startImageTrackingConfiguration:(ARReferenceImage *)refImage
{
    ARImageTrackingConfiguration *configuration = [ARImageTrackingConfiguration new];
    configuration.autoFocusEnabled = YES;
    if (refImage) {
        configuration.trackingImages = [NSSet setWithObjects:refImage, nil];
    }
    configuration.maximumNumberOfTrackedImages = 1;

    [self.arSCNView.session runWithConfiguration:configuration options: ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
    
    [self.rectDetetor startDetetion];
}

- (void)createImageNode:(CGSize)size
{
    SCNPlane *plane = [SCNPlane planeWithWidth:size.width height:size.height];
    plane.firstMaterial.diffuse.contents = _paintingImage;
    //    plane.firstMaterial.lightingModelName = SCNLightingModelPhysicallyBased;
    
    SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
    planeNode.eulerAngles = SCNVector3Make(-M_PI / 2, 0, 0);// eulerAngles.x = -.pi / 2
    planeNode.name = @"sgNode";
    
    _imgPlaneNode = planeNode;
}

#pragma mark - RectangleDetectorDelegate
- (void)didDetecteRectangle:(NSArray <NSValue *>*)pointList trackingImage:(CIImage *)trackingImage {

    if (trackingImage && self.trakingType == ARTrackingType_image && _imgPlaneNode == nil) {
        
//        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//        [bezierPath moveToPoint:[pointList[0] CGPointValue]];
//        [bezierPath addLineToPoint:[pointList[1] CGPointValue]];
//        [bezierPath addLineToPoint:[pointList[2] CGPointValue]];
//        [bezierPath addLineToPoint:[pointList[3] CGPointValue]];
//        [bezierPath closePath];
//        [bezierPath fill];
//
//        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//        shapeLayer.fillColor = [UIColor colorWithWhite:0.6 alpha:0.5].CGColor;
//        [self.view.layer addSublayer:shapeLayer];
//        shapeLayer.path = bezierPath.CGPath;
        
        CVPixelBufferRef pixelBuff = [Utilities getPixelBuffer:trackingImage];
        
        ARReferenceImage *refImage = [[ARReferenceImage alloc] initWithPixelBuffer:pixelBuff orientation:kCGImagePropertyOrientationLeft physicalWidth:1];
        [self createImageNode:refImage.physicalSize];
        _refeImage = refImage;

        [self startImageTrackingConfiguration:refImage];
    }
}

#pragma mark - Lazy Init
- (ARSCNView *)arSCNView
{
    if (_arSCNView != nil) {
        return _arSCNView;
    }
    _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    _arSCNView.delegate = self;
    _arSCNView.session.delegate = self;
    _arSCNView.showsStatistics = YES;
    _arSCNView.debugOptions = ARSCNDebugOptionShowFeaturePoints;
    return _arSCNView;
}

- (RectangleDetector *)rectDetetor
{
    if (_rectDetetor) return _rectDetetor;
    
    _rectDetetor = [[RectangleDetector alloc] init];
    _rectDetetor.previewSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _rectDetetor.delegate = self;
    _rectDetetor.arSession = self.arSCNView.session;
    
    return _rectDetetor;
}

@end
