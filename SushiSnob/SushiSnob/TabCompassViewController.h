//
//  TabCompassViewController.h
//  SushiSnob
//
//  Created by MasterRyuX on 6/8/13.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "VenueObject.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import "CompassLoadingViewController.h"

@interface TabCompassViewController : UIViewController<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    float thisVenueLat;
    float thisVenueLong;
    float thisDistVenueLat;
    float thisDistVenueLong;
}
- (IBAction)fSVenuePageButton:(id)sender;
- (IBAction)webViewTapAreaTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *sadSushiImage;

@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *saiImage;
@property (strong, nonatomic) IBOutlet UILabel *closeSushiLabel;
@property (strong, nonatomic) IBOutlet UILabel *japaneseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *theDistanceLabel;
@property (strong, nonatomic) NSString * theDistance;
@property (strong, nonatomic) CLLocation *currentLoc;
@property (strong, nonatomic) NSString * tempFSVenuePageUrl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *webviewTapArea;


@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end



