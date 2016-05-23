//
//  StartupViewController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "AppDelegate.h"
#import "StartupViewController.h"
#import "OperationQueue.h"
#import "BlockOperation.h"
#import "URLDownloadingOperation.h"
#import "StartupImageParsingOperation.h"
#import "TimelineViewController.h"
#import "NavigationController.h"
#import "CacheManager.h"

NSString * const kStartupImageCacheKey = @"com.cyandev.ZhihuDaily/startup_image";

@interface StartupViewController ()

@property (assign, nonatomic) BOOL mainViewControllerShown;

@property (weak, nonatomic) IBOutlet UIView *scrimView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (assign, nonatomic) NSTimeInterval startTime;

@end

@implementation StartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeScrimView];
    
    self.imageView.image = [[CacheManager defaultManager] objectForKey:kStartupImageCacheKey];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.startTime = [NSDate dateWithTimeIntervalSinceNow:0].timeIntervalSince1970;
    
    [self beginLoadStartupImage];
    
    [UIView animateWithDuration:4 animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (void)makeScrimView {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setFrame:self.scrimView.bounds];
    [gradient setColors:@[(id) [UIColor colorWithWhite:0 alpha:0.5].CGColor, (id) [UIColor clearColor].CGColor]];
    [gradient setStartPoint:CGPointMake(0, 1.5)];
    [gradient setEndPoint:CGPointMake(0, 0)];
    
    [self.scrimView.layer addSublayer:gradient];
}

- (void)beginLoadStartupImage {
    void(^delayedBlock)() = ^{
        if (!self.mainViewControllerShown) {
            [self showMainViewController];
        }
    };
    
    URLDownloadingOperation *downloadOp = [URLDownloadingOperation operationWithURL:[NSURL URLWithString:@"http://news-at.zhihu.com/api/4/start-image/720*1184"]];
    StartupImageParsingOperation *parsingOp = [[StartupImageParsingOperation alloc] init];
    BlockOperation *updatingOp = [BlockOperation mainQueueOperationWithBlock:^{
        UIImage *image = parsingOp.image;
        
        if (!image) {
            self.textLabel.text = @"首屏图片拉取失败";
            return;
        }
        
        [[CacheManager defaultManager] putObject:image forKey:kStartupImageCacheKey toBothDiskAndMemory:YES];
        
        [UIView transitionWithView:self.imageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.imageView.image = image;
        } completion:nil];
        self.textLabel.text = parsingOp.text;
    }];
    
    [parsingOp addDependency:downloadOp];
    [updatingOp addDependency:parsingOp];
    
    [[OperationQueue globalQueue] addOperation:downloadOp];
    [[OperationQueue globalQueue] addOperation:parsingOp];
    [[OperationQueue globalQueue] addOperation:updatingOp];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), delayedBlock);
}

- (void)showMainViewController {
    self.mainViewControllerShown = YES;
    
    TimelineViewController *vc = [[TimelineViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [AppDelegate sharedDelegate].mainViewController = vc;
    
    NavigationController *nc = [[NavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
