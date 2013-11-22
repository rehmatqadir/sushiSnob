//
//  LocationManagerSingleton.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>

{
    float userLatitude;
    float userLongitude;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;

-(void)describe;

-(void)turnOffLocations;

+(LocationManagerSingleton*)sharedSingleton;

@end
