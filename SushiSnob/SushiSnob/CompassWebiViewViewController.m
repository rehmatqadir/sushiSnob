//
//  CompassWebiViewViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "CompassWebiViewViewController.h"

@interface CompassWebiViewViewController ()

@end

@implementation CompassWebiViewViewController

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
    NSURL *url = [NSURL URLWithString:self.fSVenueWebPage];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.nearestVenueFSWebView loadRequest:request];
    [self.activityIndicator startAnimating];
    
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
  //  self.webActivityIndicator.hidden = YES;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}
@end
