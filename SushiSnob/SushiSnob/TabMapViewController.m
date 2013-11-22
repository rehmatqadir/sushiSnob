//
//  TabMapViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

//
//  TabMapViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "TabMapViewController.h"
#import "LocationManagerSingleton.h"
#import "Sushi.h"
#import "VenueObject.h"
#import "MapVenueWebViewViewController.h"
#import "VenueTableViewController.h"
#import "AppDelegate.h"
#import "SushiVenueAnnotationView.h"
#import "Reachability.h"

@interface TabMapViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;

@end


VenueObject *selectedVenue;
float refreshedLatitude;
float refreshedLongitude;
bool refreshButtonActive;
int count;



@implementation TabMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

//-(void)viewDidAppear:(BOOL)animated
//{
 //   [self viewDidLoad];
//}
- (void)viewDidLoad
{
    if (![self connected]) {
        //self.refreshButton.enabled = NO;
    } else {
        [super viewDidLoad];
        [self setMapZoom];
        refreshButtonActive = YES;
    }
}

-(void) setMapZoom
{

    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake (startingUserLocationFloatLat, startingUserLocationFloatLong);
    NSLog(@"%f", startingUserLocationFloatLong);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapCenter, span);
    self.venueMapView.region = region;
    
    AppDelegate *appDelegate1 = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.venueMapView addAnnotations:appDelegate1.fourSquareVenueObjectsArray];
}
   



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Map Annotation

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    mapView.showsUserLocation = YES;

    NSString *reuseIdentifier = @"myIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[SushiVenueAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView;
    
    for (annotationView in views) {
        if ([annotationView.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        //check if current annotation is insider visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(annotationView.annotation.coordinate);
        if (!MKMapRectContainsPoint(mapView.visibleMapRect, point)) {
            continue;
        }
        
        CGRect endFrame = annotationView.frame;
        
        //move annotation out of view
        annotationView.frame = CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - self.view.frame.size.height, annotationView.frame.size.width, annotationView.frame.size.height);
        
        //animate drop
        [UIView animateWithDuration:0.5 delay:0.04 * [views indexOfObject:annotationView] options:UIViewAnimationOptionCurveEaseOut animations:^{
            annotationView.frame = endFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    annotationView.transform = CGAffineTransformMake(1.0, 0, 0, 0.8, 0, + annotationView.frame.size.height*0.1);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        annotationView.transform = CGAffineTransformIdentity;
                    }];
                }];
            }
        }];
    }
    
    self.refreshButton.enabled = YES;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    selectedVenue = ((VenueObject *)(view.annotation));
    [self performSegueWithIdentifier:@"pushWebView" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushWebView"]) {
        MapVenueWebViewViewController *mapVenueWebViewController = segue.destinationViewController;
        mapVenueWebViewController.mkAnnotation = [self.venueMapView selectedAnnotations][0];
        mapVenueWebViewController.fourSquareVenueWebPage = selectedVenue.fourSquareVenuePage;
    }
    
}



# pragma refresh button action
- (IBAction)refreshLocationButton:(id)sender {
    AppDelegate *appDelegate1 = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.venueMapView removeAnnotations: appDelegate1.fourSquareVenueObjectsArray];

    appDelegate1.fourSquareVenueObjectsArray = nil;
    NSLog(@"appDelegateArray = %i", appDelegate1.fourSquareVenueObjectsArray.count
          );
    distanceSortedArray = nil;
    [self refreshVenueLocations];
    
    
}

-(void)refreshVenueLocations
{
    self.refreshButton.enabled = NO;

    
    self.locationManager = [[CLLocationManager alloc] init];

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    self.venueMapView.delegate = self;
    [self.locationManager startUpdatingLocation];

} 
        
        


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location;
    location = [locations lastObject];
    
    NSString *refreshedStringLat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *refreshedStringLong = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *currentUserCoordForURL = [NSString stringWithFormat:@"%@,%@", refreshedStringLat, refreshedStringLong];
    AppDelegate *appDelegate1 = (AppDelegate*)[UIApplication sharedApplication].delegate;

    appDelegate1.fourSquareVenueObjectsArray = [[NSMutableArray alloc] init];
    
    
    //searches 4S for nearby sushi restaurants based on the current location
    refreshButtonActive = NO;
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&query=sushi&oauth_token=R0LICVP1OPDRVUGDTBAY4YQDCCRZKQ20BLR4SNG5XVKZ5T5M", currentUserCoordForURL];
    NSLog(@"The search URL is%@", urlString);
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    self.activityIndicator.hidden = NO;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
     
     {
         self.activityIndicator.hidden = YES;
         NSDictionary *fourSquareInitialDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSDictionary * venueDictionary = [fourSquareInitialDictionary objectForKey:@"response"];
         NSArray *groupsArray = [venueDictionary objectForKey:@"groups"];
         NSDictionary *subgroupDictionary = [groupsArray objectAtIndex:0];
         NSMutableArray *fourSquareVenueResultsArray = [subgroupDictionary objectForKey:@"items"];
         
         for (NSMutableDictionary *listVenue in fourSquareVenueResultsArray)
         {
             VenueObject *fourSquareVenueObject = [[VenueObject alloc]init] ;
             fourSquareVenueObject.title = [listVenue objectForKey:@"name"];
             fourSquareVenueObject.fourSquareVenuePage = listVenue [@"canonicalUrl"];
             fourSquareVenueObject.venueLatitude = listVenue [@"location"][@"lat"];
             fourSquareVenueObject.venueLongitude = listVenue [@"location"][@"lng"];
             fourSquareVenueObject.coordinate = CLLocationCoordinate2DMake([fourSquareVenueObject.venueLatitude floatValue], [fourSquareVenueObject.venueLongitude floatValue]);
             fourSquareVenueObject.subtitle = listVenue [@"location"][@"address"];
            
                         fourSquareVenueObject.distance = listVenue[@"location"][@"distance"];
             [appDelegate1.fourSquareVenueObjectsArray addObject:fourSquareVenueObject];
         }
        
         [self sortVenuesByDistance];
         

         
     }];
    
    //zoom map to current location
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake (location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapCenter, span);
//    self.venueMapView.region = region;
    [self.venueMapView setRegion:region animated:YES];
    self.venueMapView.showsUserLocation = YES;
    [self.locationManager stopUpdatingLocation];

    
}

-(void) sortVenuesByDistance {
    NSLog(@"sorting by distance");
    
    AppDelegate *appDelegate1 = (AppDelegate*)[UIApplication sharedApplication].delegate;

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    distanceSortedArray = [[NSArray alloc] init];
    distanceSortedArray = [appDelegate1.fourSquareVenueObjectsArray sortedArrayUsingDescriptors:sortDescriptors];
    appDelegate1.closestVenue = [distanceSortedArray objectAtIndex:0];
        //NSLog(@"%@", distanceSortedArray);
    NSLog(@"nearest venue: %@", [distanceSortedArray objectAtIndex:0]);
    [self.venueMapView addAnnotations:appDelegate1.fourSquareVenueObjectsArray];

}


@end

