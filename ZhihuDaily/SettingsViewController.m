//
//  SettingsViewController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "SettingsViewController.h"
#import "ThemeManager.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *noImageModeSwitch;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nightModeSwitch.on = [[ThemeManager defaultManager].currentThemeName isEqualToString:@"Dark"];
    self.noImageModeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"NoImageMode"];
}

- (IBAction)nightModeSwitchDidChange:(id)sender {
    // 延时应用主题以避免开关动画卡顿。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ThemeManager defaultManager] setThemeName:self.nightModeSwitch.on ? @"Dark" : @"Default"];
    });
}

- (IBAction)noImageModeSwitchDidChange:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.noImageModeSwitch.on forKey:@"NoImageMode"];
}

@end
