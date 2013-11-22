//
//  CompassWebiViewViewController.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompassWebiViewViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *nearestVenueFSWebView;
@property (strong, nonatomic) NSString *fSVenueWebPage;
- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
