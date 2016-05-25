//
//  TimelineTableViewController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TimelineTableViewController.h"
#import "TimelineViewController.h"
#import "TimelineDataSource.h"
#import "TimelineSectionHeaderView.h"
#import "ReaderViewController.h"

@interface TimelineTableViewController ()

@end

@implementation TimelineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.dataSource tableView:tableView titleForHeaderInSection:section];
}

#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    TimelineSectionHeaderView *headerView = [[[UINib nibWithNibName:@"TimelineSectionHeaderView" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    headerView.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    headerView.topLineView.hidden = section <= 1;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource isKindOfClass:[TimelineDataSource class]]) {
        if (indexPath.section == 0) {
            return 200;
        }
    }
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Story *story = [((TimelineDataSource *) self.dataSource) storyAtIndexPath:indexPath];
    
    NSNotification *notification = [NSNotification notificationWithName:kStoryShouldShowNotification object:nil userInfo:@{kStoryUserInfoKey: story}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > scrollView.contentSize.height - scrollView.frame.size.height) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTimelineNeedsReserveNotification object:nil];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedsUpdateRefreshStateNotification object:nil];
}

@end
