//
//  SushiDetailMKAnnotation.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-09.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SushiDetailMKAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString  *subtitle;
@property (strong, nonatomic) NSString  *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
