//
//  JPMainViewController.m
//  Juper
//
//  Created by fk on 2019/9/7.
//  Copyright © 2019 fk. All rights reserved.
//

#import "JPMainViewController.h"
#import "HXPhotoPicker.h"
#import "JPPhotoPickerConfig.h"
#import "JPFilterViewController.h"
#import "JPARViewController.h"

@interface JPMainViewController ()

@property (nonatomic, strong) NSArray *photoList;

@end

@implementation JPMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupRootView];
    [self configRootSubViews:self.view];
    
    [self loadUserPhotoData];
}

#pragma mark - LoadUI
- (void)setupRootView
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configRootSubViews:(UIView *)pView
{
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = pView.bounds;
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:200];
    [addBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor lightTextColor];
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [pView addSubview:addBtn];
}

#pragma mark - LoadData
- (void)loadUserPhotoData
{
   
    
}
    

#pragma mark - Events
- (void)addBtnClicked:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    [self hx_presentSelectPhotoControllerWithManager:[JPPhotoPickerConfig getPhotoPickerConfig]
                                             didDone:^(NSArray<HXPhotoModel *> *allList,
                                                       NSArray<HXPhotoModel *> *photoList,
                                                       NSArray<HXPhotoModel *> *videoList,
                                                       BOOL isOriginal,
                                                       UIViewController *viewController,
                                                       HXPhotoManager *manager)
     {
        if (photoList.count <= 0)  return;

        HXPhotoModel *photoModel = photoList.firstObject;
        [photoModel requestPreviewImageWithSize:PHImageManagerMaximumSize startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel *model) {
            // 如果照片在iCloud上会去下载,此回调代表开始下载iCloud上的照片
            // 如果照片在本地存在此回调则不会走
        } progressHandler:^(double progress, HXPhotoModel *model) {
            // iCloud下载进度
            // 如果为网络图片,则是网络图片的下载进度
        } success:^(UIImage *image, HXPhotoModel *model, NSDictionary *info) {
            if (image) {
                JPFilterViewController *vc = [[JPFilterViewController alloc] initWithImage:image];
                vc.dismissedBlock = ^(UIImage * _Nonnull fImage) {
                    if (fImage) {
                        JPARViewController *arVC = [[JPARViewController alloc] initWithImage:fImage];
                        [weakSelf.navigationController pushViewController:arVC animated:YES];
                    }
                    
                };
                [weakSelf presentViewController:vc animated:YES completion:nil];
            }
        } failed:^(NSDictionary *info, HXPhotoModel *model) {

        }];
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSLog(@"qqqq");
    }];
}
    
#pragma mark - Private
//- （）
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
