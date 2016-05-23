//
//  TimelineSectionHeaderView.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/23.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TimelineSectionHeaderView.h"
#import "ThemeManager.h"

@interface TimelineSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;

@end

@implementation TimelineSectionHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyTheme];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeManagerDidChangeThemeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applyTheme {
    if ([[ThemeManager defaultManager].currentThemeName isEqualToString:@"Dark"]) {
        self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        //self.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.16 alpha:1];
        self.textLabel.textColor = [UIColor colorWithRed:0.62 green:0.65 blue:0.72 alpha:1];
    } else {
        self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
    }
}

@end
