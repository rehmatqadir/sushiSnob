//
//  TabMapViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "TabMapViewController.h"
#import "LocationManagerSingleton.h"
#import "Sushi.h"
#import "VenueObject.h"
#import "MapVenueWebViewViewController.h"
#import "VenueTableViewController.h"

@interface TabMapViewController ()

@end

float userLatitude;
float userLongitude;
VenueObject *selectedVenue;
NSMutableDictionary *listVenue;



@implementation TabMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocationManagerSingleton sharedSingleton] describe];
    // Do any additional setup after loading the view.

}

-(void) viewDidAppear:(BOOL)animated
{
    [self setMapZoom];
    [self fourSquareParsing];
    
}

-(void) setMapZoom
{
    
    userLatitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude;
    userLongitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.longitude;
    
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake (userLatitude, userLongitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapCenter, span);
    self.venueMapView.region = region;
    self.venueMapView.showsUserLocation = YES;
        
}



-(void) fourSquareParsing
{
    listVenue = [[NSMutableDictionary alloc]init];
    venueArray = [[NSMutableArray alloc]init];
    
    NSString *userLongitudeString = [NSString stringWithFormat:@"%.2f",userLongitude];
    NSString *userLatitudeString = [NSString stringWithFormat:@"%.2f", userLatitude];
    
    NSString *currentCoordinate = [NSString stringWithFormat:@"%@,%@", userLatitudeString, userLongitudeString];
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&query=sushi&oauth_token=R0LICVP1OPDRVUGDTBAY4YQDCCRZKQ20BLR4SNG5XVKZ5T5M&v=20130608", currentCoordinate];

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
                               NSDictionary *mainDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                               NSDictionary *venueDictionary = [mainDictionary valueForKeyPath:@"response.venues"];
                                                             
                               for (listVenue in venueDictionary) {
                                   
                                   VenueObject *venueObject = [[VenueObject alloc]init];
                    
                                   venueObject.venueName = listVenue [@"name"];
                                   venueObject.address = listVenue [@"location"][@"address"];
                                   venueObject.fourSquareVenuePage = listVenue [@"canonicalUrl"];
                                   venueObject.venueLatitude = listVenue [@"location"][@"lat"];
                                   venueObject.venueLongitude = listVenue [@"location"][@"lng"];
                                   venueObject.distance = listVenue[@"location"][@"distance"];
                                   venueObject.checkinsCount = listVenue[@"stats"][@"checkinsCount"];
                                   
                                   venueObject.title = venueObject.venueName;
                                   venueObject.subtitle = venueObject.address;
                                   
                                   venueObject.coordinate = CLLocationCoordinate2DMake([venueObject.venueLatitude floatValue],[venueObject.venueLongitude floatValue]);
                                   
                                   [self.venueMapView addAnnotation:venueObject];
                                   [venueArray addObject:venueObject];

                               }
                               [self sortVenueDistanceArray];

                               
                           }];//end of Block
    
}

-(void) sortVenueDistanceArray
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"distance"
                                                ascending:YES];
                      
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];    
    distanceSortedArray = [venueArray sortedArrayUsingDescriptors:sortDescriptors];
    NSLog(@"the nearest venue: %@", [[distanceSortedArray objectAtIndex:0] valueForKeyPath:@"venueName"]);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Map Annotation
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *reuseIdentifier = @"myIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        ((MKPinAnnotationView *)(annotationView)).animatesDrop = YES;
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
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

- (IBAction)showLocation:(id)sender {
    NSLog(@"%f lat",[LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude);
    NSLog(@"number of venue: %i", venueArray.count);
}


@end
