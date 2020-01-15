//
//  JPFilterViewController.h
//  Juper
//
//  Created by fk on 2019/9/18.
//  Copyright © 2019 fk. All rights reserved.
//

#import "JPViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JPFilterViewController : JPViewController

@property (nonatomic, copy) void(^dismissedBlock)(UIImage *image);

- (instancetype)initWithImage:(UIImage *)originImage;

@end

NS_ASSUME_NONNULL_END
