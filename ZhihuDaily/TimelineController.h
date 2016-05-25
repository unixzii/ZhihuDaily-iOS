//
//  TimelineController.h
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/21.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Timeline.h"

@class TimelineController;


@protocol TimelineControllerDelegate <NSObject>

@optional

- (void)timelineControllerDidFinishLoading:(TimelineController *)timelineController;
- (void)timelineControllerDidFailedLoading:(TimelineController *)timelineController;

@end


@interface TimelineController : NSObject

@property (readonly, copy, nonatomic) NSArray<Timeline *> *timelines;
@property (weak, nonatomic) id<TimelineControllerDelegate> delegate;

@property (readonly, assign, nonatomic) BOOL busy;

- (void)reload;
- (void)reserve;

@end
