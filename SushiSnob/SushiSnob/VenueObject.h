//
//  VenueObject.h
//  SushiSnob
//
//  Created by MasterRyuX on 6/7/13.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VenueObject : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString  *venueName;
@property (strong, nonatomic) NSString  *address;
@property (strong, nonatomic) NSString  *venueLatitude;
@property (strong, nonatomic) NSString  *venueLongitude;
@property (strong, nonatomic) NSNumber  *distance;
@property (strong, nonatomic) NSString  *checkinsCount;
@property (strong, nonatomic) NSString  *rating;
@property (strong, nonatomic) NSString  *hours;
@property (strong, nonatomic) NSString  *fourSquareVenuePage;
@property (strong, nonatomic) NSString  *subtitle;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) UIImage *venueIcon;

@property (strong, nonatomic) UIImage *venueBigPic;
@property (strong, nonatomic) NSData *venueTypeIcon;
@property (strong, nonatomic) NSData *venuePic;
@property (strong, nonatomic) NSString *iconURL;
@property (strong, nonatomic) NSString *venueCategory;

@property (nonatomic) CLLocationCoordinate2D coordinate;




@end
