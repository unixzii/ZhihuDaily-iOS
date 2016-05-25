//
//  HUDManager.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "HUDManager.h"

@interface HUDManager ()

@property (strong, nonatomic) UIView *centralProgressView;
@property (strong, nonatomic) UIView *bottomToastView;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HUDManager

+ (instancetype)defaultManager {
    static HUDManager *DefaultManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        DefaultManager = [[HUDManager alloc] init];
    });
    
    return DefaultManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.centralProgressView = [[UINib nibWithNibName:@"CentralProgressView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        self.bottomToastView = [[UINib nibWithNibName:@"BottomToastView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(hideToast) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)showToastWithString:(NSString *)string {
    [self.timer invalidate];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomToastView.frame = CGRectMake(0, window.frame.size.height - 50, window.frame.size.width, 50);
    self.bottomToastView.transform = CGAffineTransformMakeTranslation(0, 50);
    ((UILabel *) [self.bottomToastView viewWithTag:1]).text = string;
    
    [window addSubview:self.bottomToastView];
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomToastView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
}

- (void)hideToast {
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomToastView.transform = CGAffineTransformMakeTranslation(0, 50);
    } completion:^(BOOL finished) {
        [self.bottomToastView removeFromSuperview];
        self.bottomToastView.transform = CGAffineTransformIdentity;
    }];
    [self.timer invalidate];
}

- (void)showProgressWithString:(NSString *)string {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.centralProgressView.frame = CGRectMake((CGRectGetWidth(window.frame) - 160) / 2.0, (CGRectGetHeight(window.frame) - 100) / 2.0, 160, 100);
    self.centralProgressView.alpha = 0;
    ((UILabel *) [self.centralProgressView viewWithTag:1]).text = string;
    
    [window addSubview:self.centralProgressView];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.centralProgressView.alpha = 1;
    }];
}

- (void)hideProgress {
    [UIView animateWithDuration:0.4 animations:^{
        self.centralProgressView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.centralProgressView removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

@end
