//
//  SushiDetailViewController.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Sushi.h"

@interface SushiDetailViewController : UIViewController

@property (strong, nonatomic) Sushi *selectedSushi;


@property (strong, nonatomic) IBOutlet UIImageView *sushiDetailImage;
@property (strong, nonatomic) IBOutlet UILabel *sushiDetailName;
@property (strong, nonatomic) IBOutlet UILabel *sushiDetailVenue;
@property (strong, nonatomic) IBOutlet UILabel *sushiDetailDate;
@property (strong, nonatomic) IBOutlet UILabel *sushiDetailNotes;
@property (strong, nonatomic) IBOutlet UILabel *sushiDetailCity;
@property (strong, nonatomic) IBOutlet UIView *sushiDetailGoodOrBad;
@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImage;
@property (strong, nonatomic) IBOutlet UIImageView *xImage;
@property (strong, nonatomic) IBOutlet MKMapView *sushiDetailMapView;

@end
