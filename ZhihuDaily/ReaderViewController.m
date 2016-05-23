//
//  ReaderViewController.m
//  ZhihuDaily
//
//  Created by 杨弘宇 on 16/5/22.
//  Copyright © 2016年 Cyandev. All rights reserved.
//

#import "ReaderViewController.h"
#import "OperationQueue.h"
#import "URLDownloadingOperation.h"
#import "StoryBodyParsingOperation.h"
#import "BlockOperation.h"
#import "CacheManager.h"
#import "HUDManager.h"

@interface ReaderViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"文章正文";
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.webView.scrollView.scrollIndicatorInsets = self.webView.scrollView.contentInset;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    UIImageView *grayLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo-gray-small"]];
    grayLogoImageView.frame = CGRectMake((self.view.frame.size.width - 65) / 2.0, 20, 65, 65);
    [self.webView insertSubview:grayLogoImageView atIndex:0];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.webView.scrollView addSubview:self.imageView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadStoryBody];
        [[HUDManager defaultManager] showProgressWithString:@"正在载入"];
    });
}

- (void)loadStoryBody {
    URLDownloadingOperation *downloadOp = [URLDownloadingOperation operationWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%lu", (unsigned long) self.story.storyId]]];
    StoryBodyParsingOperation *parsingOp = [[StoryBodyParsingOperation alloc] init];
    BlockOperation *updatingOp = [BlockOperation mainQueueOperationWithBlock:^{
        if (parsingOp.story.body) {
            NSString *compoundHTML = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=\"%@\"></head><body>%@</body></html>", self.story.body.cssString, self.story.body.htmlString];
            [self.webView loadHTMLString:compoundHTML baseURL:nil];
            self.imageView.image = [[CacheManager defaultManager] objectForKey:self.story.imageURL.absoluteString];
        } else {
            [[HUDManager defaultManager] showToastWithString:@"无法加载文章，请检查网络设置。"];
        }
        [[HUDManager defaultManager] hideProgress];
    }];
    
    parsingOp.story = self.story;
    
    [parsingOp addDependency:downloadOp];
    [updatingOp addDependency:parsingOp];
    
    [[OperationQueue globalQueue] addOperation:downloadOp];
    [[OperationQueue globalQueue] addOperation:parsingOp];
    [[OperationQueue globalQueue] addOperation:updatingOp];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

@end
