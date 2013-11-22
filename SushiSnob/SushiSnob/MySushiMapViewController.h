//
//  MySushiMapViewController.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MySushiMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mySushiMapView;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedSushiResults;

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *documentsDirectory;

@end
