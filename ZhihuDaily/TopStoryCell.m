//
//  TopStoryCell.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TopStoryCell.h"
#import "TopStoryViewController.h"

@interface TopStoryCell () <UIPageViewControllerDelegate>

@end

@implementation TopStoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.pageController = [[TopStoryPageController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageController.delegate = self;
        [self addSubview:self.pageController.view];
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.userInteractionEnabled = false;
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pageController.view.frame = self.bounds;
    [self.pageController.view setNeedsLayout];
    
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.pageControl.currentPage = ((TopStoryViewController *) (pageViewController.viewControllers).firstObject).index;
}

@end
