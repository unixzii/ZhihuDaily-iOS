//
//  TimelineDataSource.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TimelineDataSource.h"
#import "TimelineCell.h"
#import "TopStoryCell.h"

@interface TimelineDataSource ()

@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation TimelineDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.dateFormat = @"yyyy年MM月dd日";
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.timelines) {
        return 0;
    }
    
    return self.timelines.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.timelines) {
        return 0;
    }
    
    if (section == 0) {
        return 1;
    }
    
    return [self.timelines objectAtIndex:section - 1].stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *TopStoryCellIdentifier = @"TopStoryCell";
        
        TopStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:TopStoryCellIdentifier];
        
        if (!cell) {
            cell = [[TopStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopStoryCellIdentifier];
        }
        
        [cell.pageController setTimeline:[self.timelines firstObject]];
        cell.pageControl.numberOfPages = [self.timelines firstObject].topStories.count;
        cell.pageControl.currentPage = 0;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    [((TimelineCell *) cell) loadWithStory:[self storyAtIndexPath:indexPath]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.timelines || section == 0) {
        return nil;
    }
    
    return [self.formatter stringFromDate:[self.timelines objectAtIndex:section - 1].date];
}

- (Story *)storyAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.timelines objectAtIndex:indexPath.section - 1].stories objectAtIndex:indexPath.row];
}

@end
