//
//  AppDelegate.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "TabMapViewController.h"
#import "TabCompassViewController.h"
#import "TabMySushiViewController.h"
#import "VenueObject.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"


@class TabMySushiViewController;


NSArray *distanceSortedArray;
float startingUserLocationFloatLat;
float startingUserLocationFloatLong;
NSString *latitudeWithCurrentCoordinates;
NSString *longitudeWithCurrentCoordinates;


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate,MKMapViewDelegate>

@property (strong, nonatomic) UIWindow *window;

//core data stuff
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//location stuff
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic)CLLocationManager*locationManager;
@property (strong, nonatomic) NSMutableArray * fourSquareVenueObjectsArray;
@property (strong, nonatomic) VenueObject * closestVenue;
@property (nonatomic, strong) NSString *logURL;



- (void) startStandardLocationServices;
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end