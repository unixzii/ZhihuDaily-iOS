//
//  TopStoryCell.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopStoryPageController.h"

@interface TopStoryCell : UITableViewCell

@property (strong, nonatomic) TopStoryPageController *pageController;
@property (strong, nonatomic) UIPageControl *pageControl;

@end
