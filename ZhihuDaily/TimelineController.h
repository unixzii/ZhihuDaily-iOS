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

@property (readonly, strong, nonatomic) NSMutableArray<Timeline *> *timelines;
@property (weak, nonatomic) id<TimelineControllerDelegate> delegate;

- (void)reload;
- (void)reserve;

@end
