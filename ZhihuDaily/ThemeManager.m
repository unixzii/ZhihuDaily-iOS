//
//  ThemeManager.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface ThemeManager ()

@property (readwrite, copy, nonatomic) NSString *currentThemeName;

@end

@implementation ThemeManager

+ (instancetype)defaultManager {
    static ThemeManager *DefaultManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        DefaultManager = [[ThemeManager alloc] init];
    });
    
    return DefaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentThemeName = [[NSUserDefaults standardUserDefaults] stringForKey:@"AppTheme"];
        if (!self.currentThemeName) {
            self.currentThemeName = @"Default";
        }
    }
    return self;
}

- (void)setThemeName:(NSString *)themeName {
    self.currentThemeName = themeName;
    
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:@"AppTheme"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeManagerDidChangeThemeNotification object:nil];
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
    } completion:nil];
}

@end
