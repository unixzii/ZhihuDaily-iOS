//
//  TimelineViewController.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

static NSString * const kNeedsUpdateRefreshStateNotification = @"kNeedsUpdateRefreshStateNotification";
static NSString * const kTimelineNeedsReserveNotification = @"kTimelineNeedsReserveNotification";
static NSString * const kStoryShouldShowNotification = @"kStoryShouldShowNotification";
static NSString * const kStoryUserInfoKey = @"kTopStoryUserInfoKey";

@interface TimelineViewController : BaseViewController

@end
