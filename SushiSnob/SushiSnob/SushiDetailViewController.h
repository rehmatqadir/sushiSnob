//
//  SushiDetailViewController.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Sushi.h"
#import <Social/Social.h>

@interface SushiDetailViewController : UIViewController

@property (strong, nonatomic) Sushi *selectedSushi;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *sushiDetailGoodOrBad;


@property (weak, nonatomic) IBOutlet UIView *viewTest;

@property (strong, nonatomic) IBOutlet UIImageView *sushiDetailImage;
@property (weak, nonatomic) IBOutlet UIImageView *sushiType;
@property (weak, nonatomic) IBOutlet UIImageView *sushiThumbsUp;

@property (strong, nonatomic) IBOutlet UILabel *sushiDetailVenue;
@property (strong, nonatomic) IBOutlet UILabel *sushiDetailDate;

@property (weak, nonatomic) IBOutlet UILabel *sushiAddress;

@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImage;
@property (strong, nonatomic) IBOutlet UIImageView *xImage;

@property (strong, nonatomic) IBOutlet MKMapView *sushiDetailMapView;

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *documentsDirectory;



- (IBAction)shareToSocial:(id)sender;

- (IBAction)tapTapped:(id)sender;


@end
