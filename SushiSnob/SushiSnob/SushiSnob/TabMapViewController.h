//
//  TabMapViewController.h
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface TabMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *venueMapView;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


- (IBAction)showLocation:(id)sender;

@end

NSMutableArray* venueArray;
NSArray *distanceSortedArray;


