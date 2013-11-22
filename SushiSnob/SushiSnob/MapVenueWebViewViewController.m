//
//  MapVenueWebViewViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "MapVenueWebViewViewController.h"

@interface MapVenueWebViewViewController ()

@end

@implementation MapVenueWebViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:self.fourSquareVenueWebPage];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.venueFSWebView loadRequest:request];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.webActivityIndicator.hidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
