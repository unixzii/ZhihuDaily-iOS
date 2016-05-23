//
//  NavigationController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "NavigationController.h"
#import "ThemeManager.h"
#import "UIImage+Helpers.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self applyTheme];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeManagerDidChangeThemeNotification object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[ThemeManager defaultManager].currentThemeName isEqualToString:@"Dark"] ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applyTheme {
    if ([[ThemeManager defaultManager].currentThemeName isEqualToString:@"Dark"]) {
        [self.navigationBar setBackgroundImage:[UIImage imageFilledWithColor:[UIColor colorWithRed:0.12 green:0.12 blue:0.16 alpha:1]] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [UIImage imageFilledWithColor:[UIColor colorWithRed:0.11 green:0.11 blue:0.16 alpha:1]];
        self.navigationBar.tintColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.44 alpha:1];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.74 green:0.77 blue:0.82 alpha:1]};
    } else {
        [self.navigationBar setBackgroundImage:[UIImage imageFilledWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [UIImage imageFilledWithColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1]];
        self.navigationBar.tintColor = [UIColor colorWithRed:0.73 green:0.73 blue:0.84 alpha:1];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.23 green:0.25 blue:0.27 alpha:1]};
    }
}

@end
