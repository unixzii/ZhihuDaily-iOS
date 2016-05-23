//
//  ThemeManager.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kThemeManagerDidChangeThemeNotification = @"kThemeManagerDidChangeThemeNotification";

@interface ThemeManager : NSObject

@property (readonly, copy, nonatomic) NSString *currentThemeName;

+ (instancetype)defaultManager;

- (void)setThemeName:(NSString *)themeName;

@end
