//
//  TabMapViewController.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface TabMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet MKMapView *venueMapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

- (IBAction)refreshLocationButton:(id)sender;


@end





