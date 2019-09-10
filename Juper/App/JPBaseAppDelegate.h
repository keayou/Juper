//
//  JPBaseAppDelegate.h
//  Juper
//
//  Created by fk on 2019/8/31.
//  Copyright © 2019 fk. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JPBaseAppDelegateInstance [JPBaseAppDelegate sharedAppDelegate]

@interface JPBaseAppDelegate : UIResponder

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedAppDelegate;

- (UINavigationController *)navigationViewController;

- (UIViewController *)topViewController;

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (NSArray *)popToViewController:(UIViewController *)viewController;

- (UIViewController *)popViewController:(BOOL)animated;

- (NSArray *)popToRootViewController;

- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;


@end

