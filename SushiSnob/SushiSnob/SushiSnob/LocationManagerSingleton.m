//
//  LocationManagerSingleton.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "LocationManagerSingleton.h"


@implementation LocationManagerSingleton
{
   
}

-(id)init
{
    self = [super init];
    
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setHeadingFilter:kCLHeadingFilterNone];
        [self.locationManager startUpdatingLocation];
        //do more customization if needed
    }
    
    return self;
}

+(LocationManagerSingleton*)sharedSingleton
{
    static LocationManagerSingleton *sharedSingleton;
    if (!sharedSingleton) {
        sharedSingleton = [[LocationManagerSingleton alloc] init];
    }
    return sharedSingleton;
}

-(void)describe
{
    NSLog(@"yo");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.userLocation = [locations lastObject];
    userLatitude = self.userLocation.coordinate.latitude;
    userLongitude = self.userLocation.coordinate.longitude;
}

@end
