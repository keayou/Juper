//
//  JPMainTabBarController.m
//  Juper
//
//  Created by fk on 2019/8/31.
//  Copyright © 2019 fk. All rights reserved.
//

#import "JPMainTabBarController.h"
#import "JPMainViewController.h"

@interface JPMainTabBarController ()<UITabBarControllerDelegate>

@end

@implementation JPMainTabBarController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBarVC];
}

#pragma mark - setup
- (void)setupTabBarVC {
    JPMainViewController *_0 = [JPMainViewController new];

 
   JPNavigationController *nva_0 = [self addChildViewController:_0 imageName:@"" selectedImageName:@"" title:@"首页"];
    self.viewControllers = @[nva_0];

    self.delegate = self;
    [self setSelectedIndex:0];
    self.tabBar.hidden = YES;
}

- (JPNavigationController *)addChildViewController:(UIViewController *)childController imageName:(NSString *)normalImg selectedImageName:(NSString *)selectImg title:(NSString *)title {
    JPNavigationController *nav = [[JPNavigationController alloc] initWithRootViewController:childController];
//    childController.tabBarItem.image = [[UIImage imageNamed:normalImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    childController.title = title;
    [self addChildViewController:nav];
    return nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
