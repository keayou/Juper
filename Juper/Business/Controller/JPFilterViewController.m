//
//  JPFilterViewController.m
//  Juper
//
//  Created by fk on 2019/9/18.
//  Copyright © 2019 fk. All rights reserved.
//

#import "JPFilterViewController.h"
#import "Utilities.h"
#import "JPSketchFilter.h"
#define PresentedTopBlankHeight (40.0f)

@interface JPFilterViewController ()

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *handledImage;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JPFilterViewController

- (instancetype)initWithImage:(UIImage *)originImage
{
    self = [super init];
    if (self) {
        _originImage = originImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    _handledImage = [self getHandledImage];
    [self.imageView setImage:_handledImage];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setSize:CGSizeMake(120, 40)];
    startBtn.centerX = self.view.width / 2;
    startBtn.bottom = self.view.height - PresentedTopBlankHeight - 80;
    [startBtn setTitle:@"AR绘制" forState:UIControlStateNormal];
    startBtn.layer.cornerRadius = 4.0;
    startBtn.backgroundColor = [UIColor blueColor];
    [startBtn addTarget:self action:@selector(startDrawClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
}

#pragma mark - Private
- (UIImage *)getHandledImage
{
    CIImage * inputImage = [[CIImage alloc] initWithImage:_originImage];
    CIContext * context = [CIContext contextWithOptions:nil];
    JPSketchFilter * filter = [JPSketchFilter new];
    filter.inputImage = inputImage;
    CGImageRef cgImage = [context createCGImage:filter.outputImage fromRect:[inputImage extent]];
    UIImage *outImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    UIImage *filterImage = [Utilities imageToTransparent:outImage];
    
    return filterImage;
}

#pragma mark - Events
- (void)startDrawClicked:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.dismissedBlock) {
            weakSelf.dismissedBlock(weakSelf.handledImage);
        }
    }];
}

- (UIImageView *)imageView
{
    if (_imageView) return _imageView;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - PresentedTopBlankHeight)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];

    return _imageView;
}

@end
