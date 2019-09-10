//
//  JPPhotoPickerConfig.m
//  Juper
//
//  Created by fk on 2019/9/7.
//  Copyright © 2019 fk. All rights reserved.
//

#import "JPPhotoPickerConfig.h"
#import "HXPhotoPicker.h"

static HXPhotoManager *pickerManager = nil;

@implementation JPPhotoPickerConfig

+ (HXPhotoManager *)getPhotoPickerConfig
{
    if (pickerManager) {
        return pickerManager;
    }
    
    pickerManager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
    pickerManager.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
    pickerManager.configuration.singleSelected = YES;
    pickerManager.configuration.albumListTableView = ^(UITableView *tableView) {
        //            NSSLog(@"%@",tableView);
    };
    pickerManager.configuration.singleJumpEdit = NO;
//    pickerManager.configuration.movableCropBox = YES;
//    pickerManager.configuration.movableCropBoxEditSize = YES;
    pickerManager.configuration.saveSystemAblum = YES;
    pickerManager.configuration.supportRotation = NO;

    
//    pickerManager.configuration.videoMaxNum = 5;
//    pickerManager.configuration.deleteTemporaryPhoto = NO;
//    pickerManager.configuration.lookLivePhoto = YES;
//    pickerManager.configuration.selectTogether = YES;
//    pickerManager.configuration.creationDateSort = YES;
//    //        pickerManager.configuration.cameraCellShowPreview = NO;
//    //        pickerManager.configuration.themeColor = [UIColor redColor];
//    pickerManager.configuration.navigationBar = ^(UINavigationBar *navigationBar, UIViewController *viewController) {
//        //            [navigationBar setBackgroundImage:[UIImage imageNamed:@"APPCityPlayer_bannerGame"] forBarMetrics:UIBarMetricsDefault];
//        //            navigationBar.barTintColor = [UIColor redColor];
//    };
    //        pickerManager.configuration.sectionHeaderTranslucent = NO;
    //        pickerManager.configuration.navBarBackgroudColor = [UIColor redColor];
    //        pickerManager.configuration.sectionHeaderSuspensionBgColor = [UIColor redColor];
    //        pickerManager.configuration.sectionHeaderSuspensionTitleColor = [UIColor whiteColor];
    //        pickerManager.configuration.statusBarStyle = UIStatusBarStyleLightContent;
    //        pickerManager.configuration.selectedTitleColor = [UIColor redColor];
    
    //        pickerManager.configuration.requestImageAfterFinishingSelection = YES;
//
//    __weak typeof(self) weakSelf = self;
//    pickerManager.configuration.photoListBottomView = ^(HXPhotoBottomView *bottomView) {
//        bottomView.bgView.barTintColor = weakSelf.bottomViewBgColor;
//    };
//    pickerManager.configuration.previewBottomView = ^(HXPhotoPreviewBottomView *bottomView) {
//        bottomView.bgView.barTintColor = weakSelf.bottomViewBgColor;
//    };
//    pickerManager.configuration.albumListCollectionView = ^(UICollectionView *collectionView) {
//        //            NSSLog(@"albumList:%@",collectionView);
//    };
//    pickerManager.configuration.photoListCollectionView = ^(UICollectionView *collectionView) {
//        //            NSSLog(@"photoList:%@",collectionView);
//    };
//    pickerManager.configuration.previewCollectionView = ^(UICollectionView *collectionView) {
//        //            NSSLog(@"preview:%@",collectionView);
//    };
    //        pickerManager.configuration.movableCropBox = YES;
    //        pickerManager.configuration.movableCropBoxEditSize = YES;
    //        pickerManager.configuration.movableCropBoxCustomRatio = CGPointMake(1, 1);
    
//    // 使用自动的相机  这里拿系统相机做示例
//    pickerManager.configuration.shouldUseCamera = ^(UIViewController *viewController, HXPhotoConfigurationCameraType cameraType, HXPhotoManager *manager) {
//
//        // 这里拿使用系统相机做例子
//        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
//        imagePickerController.delegate = (id)weakSelf;
//        imagePickerController.allowsEditing = NO;
//        NSString *requiredMediaTypeImage = ( NSString *)kUTTypeImage;
//        NSString *requiredMediaTypeMovie = ( NSString *)kUTTypeMovie;
//        NSArray *arrMediaTypes;
//        if (cameraType == HXPhotoConfigurationCameraTypePhoto) {
//            arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage,nil];
//        }else if (cameraType == HXPhotoConfigurationCameraTypeVideo) {
//            arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeMovie,nil];
//        }else {
//            arrMediaTypes=[NSArray arrayWithObjects:requiredMediaTypeImage, requiredMediaTypeMovie,nil];
//        }
//        [imagePickerController setMediaTypes:arrMediaTypes];
//        // 设置录制视频的质量
//        [imagePickerController setVideoQuality:UIImagePickerControllerQualityTypeHigh];
//        //设置最长摄像时间
//        [imagePickerController setVideoMaximumDuration:60.f];
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePickerController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//        [viewController presentViewController:imagePickerController animated:YES completion:nil];
//    };
    //        pickerManager.shouldSelectModel = ^NSString *(HXPhotoModel *model) {
    //            // 如果return nil 则会走默认的判断是否达到最大值
    //            //return nil;
    //            return @"Demo1 116 - 120 行注释掉就能选啦~\(≧▽≦)/~";
    //        };
//    pickerManager.configuration.videoCanEdit = NO;
//    pickerManager.configuration.photoCanEdit = NO;
    return pickerManager;
    
}


@end
