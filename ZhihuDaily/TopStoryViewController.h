//
//  TopStoryViewController.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

static NSString * const kTopStoryViewDidTapNotification = @"kTopStoryViewDidTapNotification";
static NSString * const kTopStoryUserInfoKey = @"kTopStoryUserInfoKey";

@interface TopStoryViewController : UIViewController

@property (assign) NSUInteger index;

- (void)loadWithStory:(Story *)story;

@end
