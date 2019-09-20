//
//  JPFilterViewController.m
//  Juper
//
//  Created by fk on 2019/9/18.
//  Copyright © 2019 fk. All rights reserved.
//

#import "JPFilterViewController.h"

@interface JPFilterViewController ()

@property (nonatomic, strong) UIImage *originImage;

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

    
    
}



@end
