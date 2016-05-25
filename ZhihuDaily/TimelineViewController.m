//
//  TimelineViewController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TimelineViewController.h"
#import "TimelineTableViewController.h"
#import "TimelineDataSource.h"
#import "TimelineController.h"
#import "ReaderViewController.h"
#import "HUDManager.h"
#import "UIImage+Helpers.h"

@interface TimelineViewController () <TimelineControllerDelegate>

@property (strong, nonatomic) TimelineController *timelineController;
@property (strong, nonatomic) TimelineDataSource *timelineDataSource;

@property (strong, nonatomic) TimelineTableViewController *timelineTableViewController;

@property (strong, nonatomic) UIView *progressBar;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"知乎日报";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsViewController:)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.timelineController = [[TimelineController alloc] init];
    self.timelineController.delegate = self;
    
    self.timelineDataSource = [[TimelineDataSource alloc] init];
    self.timelineDataSource.cellIdentifier = @"Cell";
    
    self.timelineTableViewController = [[TimelineTableViewController alloc] init];
    [self.timelineTableViewController willMoveToParentViewController:self];
    [self addChildViewController:self.timelineTableViewController];
    self.timelineTableViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.timelineTableViewController.view];
    [self.timelineTableViewController didMoveToParentViewController:self];
    
    self.timelineTableViewController.dataSource = self.timelineDataSource;
    [self.timelineTableViewController.tableView registerNib:[UINib nibWithNibName:@"TimelineCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.timelineTableViewController.refreshControl addTarget:self.timelineController action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    
    self.progressBar = [[UIView alloc] init];
    self.progressBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 5);
    self.progressBar.backgroundColor = [UIColor colorWithRed:0 green:0.51 blue:1 alpha:1];
    [self.view addSubview:self.progressBar];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.timelineController reload];
    });
    
    [self.timelineController addObserver:self forKeyPath:@"busy" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRefreshState) name:kNeedsUpdateRefreshStateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.timelineController selector:@selector(reserve) name:kTimelineNeedsReserveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showReaderViewController:) name:kStoryShouldShowNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"busy"] && object == self.timelineController) {
        [self updateRefreshState];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.timelineController];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showSettingsViewController:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    [self showViewController:[storyboard instantiateInitialViewController] sender:sender];
}

- (void)showReaderViewController:(NSNotification *)aNotification {
    ReaderViewController *readerVC = [[ReaderViewController alloc] init];
    readerVC.story = (aNotification.userInfo)[kStoryUserInfoKey];
    
    [self showViewController:readerVC sender:self];
}

- (void)updateRefreshState {
    if (!self.timelineController.busy) {
        if (self.timelineTableViewController.refreshControl.refreshing) {
            [self.timelineTableViewController.refreshControl endRefreshing];
        }
        
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:kNilOptions animations:^{
            CGRect frame = self.progressBar.frame;
            frame.size.width = CGRectGetWidth(self.view.frame);
            self.progressBar.frame = frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.progressBar.alpha = 0;
            }];
        }];
    } else {
        __block CGRect frame = self.progressBar.frame;
        frame.size.width = 0;
        self.progressBar.frame = frame;
        self.progressBar.alpha = 1;
        
        [UIView animateWithDuration:0.3 animations:^{
            frame.size.width = 30;
            self.progressBar.frame = frame;
        }];
    }
}

#pragma mark - Timeline Controller Delegate

- (void)timelineControllerDidFinishLoading:(TimelineController *)timelineController {
    [self.timelineTableViewController.refreshControl endRefreshing];
    self.timelineDataSource.timelines = timelineController.timelines;
    [self.timelineTableViewController.tableView reloadData];
}

- (void)timelineControllerDidFailedLoading:(TimelineController *)timelineController {
    [self.timelineTableViewController.refreshControl endRefreshing];
    [[HUDManager defaultManager] showToastWithString:@"无法获取最新消息，请检查网络设置。"];
}

@end
