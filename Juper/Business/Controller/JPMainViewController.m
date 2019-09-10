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

@interface JPMainViewController ()

@property (nonatomic, strong) NSArray *photoList;

@end

@implementation JPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupRootView];
    [self configRootSubViews:self.view];
    
    [self loadUserPhotoData];
}

#pragma mark - LoadUI
- (void)setupRootView
{
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
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
    [self hx_presentSelectPhotoControllerWithManager:[JPPhotoPickerConfig getPhotoPickerConfig]
                                             didDone:^(NSArray<HXPhotoModel *> *allList,
                                                       NSArray<HXPhotoModel *> *photoList,
                                                       NSArray<HXPhotoModel *> *videoList,
                                                       BOOL isOriginal,
                                                       UIViewController *viewController,
                                                       HXPhotoManager *manager) {
                                                 
                                                 
                                                 NSLog(@"asdasdas");
                                                 
                                                 
                                             }cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
                                                 
                                                 NSLog(@"qqqq");
                                                 
                                                 
                                             }
     ];
    
    
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
