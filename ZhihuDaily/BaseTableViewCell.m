//
//  BaseTableViewCell.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ThemeManager.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self applyTheme];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeManagerDidChangeThemeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applyTheme {
    if ([[ThemeManager defaultManager].currentThemeName isEqualToString:@"Dark"]) {
        self.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.16 alpha:1];
        self.textLabel.textColor = [UIColor colorWithRed:0.62 green:0.65 blue:0.72 alpha:1];
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.32 green:0.33 blue:0.4 alpha:1];
        
        UIView *selected = [[UIView alloc] init];
        selected.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];
        self.selectedBackgroundView = selected;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor colorWithRed:0.37 green:0.37 blue:0.37 alpha:1];
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        self.selectedBackgroundView = nil;
    }
}

@end
