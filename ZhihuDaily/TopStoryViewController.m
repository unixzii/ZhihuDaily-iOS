//
//  TopStoryViewController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "TopStoryViewController.h"
#import "TimelineViewController.h"
#import "OperationQueue.h"
#import "ImageDownloadingOperation.h"

@interface TopStoryViewController ()

@property (strong, nonatomic) ImageDownloadingOperation *currentDownloadingOperation;

@property (weak, nonatomic) Story *story;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation TopStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *aRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:aRecognizer];
}

- (void)loadWithStory:(Story *)story {
    self.story = story;
    
    self.label.text = story.title;
    self.imageView.image = nil;
    
    if (self.currentDownloadingOperation) {
        [self.currentDownloadingOperation cancel];
    }
    
    self.currentDownloadingOperation = [ImageDownloadingOperation operationWithURL:story.imageURL forImageView:self.imageView];
    
    [[OperationQueue globalQueue] addOperation:self.currentDownloadingOperation];
}

- (void)handleTap:(id)sender {
    NSNotification *notification = [NSNotification notificationWithName:kStoryShouldShowNotification object:nil userInfo:@{kStoryUserInfoKey: self.story}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
