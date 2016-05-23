//
//  BaseTableViewController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ThemeManager.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self applyTheme];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyTheme) name:kThemeManagerDidChangeThemeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applyTheme {
    if ([[ThemeManager defaultManager].currentThemeName isEqualToString:@"Dark"]) {
        self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.2 alpha:1];
        self.tableView.separatorColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.16 alpha:1];
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    } else {
        self.tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1];
        self.tableView.separatorColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1];
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    }
}

@end
