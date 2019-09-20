//
//  JPSketchFilter.h
//  Juper
//
//  Created by fk on 2019/9/18.
//  Copyright © 2019 fk. All rights reserved.
//

#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface JPSketchFilter : CIFilter

@property (nonatomic, strong) CIImage *inputImage;

@end

NS_ASSUME_NONNULL_END
