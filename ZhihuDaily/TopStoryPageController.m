//
//  TopStoryPageController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TopStoryPageController.h"
#import "TopStoryViewController.h"

@interface TopStoryPageController () <UIPageViewControllerDataSource>

@property (weak, nonatomic) Timeline *timeline;

@end

@implementation TopStoryPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.dataSource = self;
}

- (void)setTimeline:(Timeline *)timeline {
    self->_timeline = timeline;
    
    if (timeline.topStories.count > 0) {
        [self setViewControllers:@[[self makeViewControllerForStoryAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    } else {
        [self setViewControllers:@[] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (UIViewController *)makeViewControllerForStoryAtIndex:(NSUInteger)idx {
    TopStoryViewController *vc = [[TopStoryViewController alloc] init];
    vc.view.frame = self.view.bounds;
    vc.index = idx;
    [vc loadWithStory:[self.timeline.topStories objectAtIndex:vc.index]];
    
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (((TopStoryViewController *) viewController).index + 1 < self.timeline.topStories.count) {
        return [self makeViewControllerForStoryAtIndex:((TopStoryViewController *) viewController).index + 1];
    } else {
        return nil;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (((TopStoryViewController *) viewController).index >= 1) {
        return [self makeViewControllerForStoryAtIndex:((TopStoryViewController *) viewController).index - 1];
    } else {
        return nil;
    }
}

@end
