//
//  TabCompassViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 6/8/13.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "TabCompassViewController.h"
#import "VenueObject.h"
#import "AppDelegate.h"
#import "CompassWebiViewViewController.h"

@interface TabCompassViewController ()

{
    VenueObject* oneVenue;
    NSMutableArray *arrayWithDistance;
    NSArray *distanceSortedArray;
    NSString *latitudeWithCurrentCoordinates;
    NSString *longitudeWithCurrentCoordinates;
    float ourPhoneFloatLat;
    float ourPhoneFloatLong;
    VenueObject *selectedVenue;
    NSMutableArray * allItems1;
    AppDelegate *appDelegate ;
    BOOL activityIndicatorStopped;
    CompassWebiViewViewController *compassWebbyViewController;
}

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@property (nonatomic, strong) NSString * strLatitude;
@property (nonatomic, strong) NSString * strLongitude;
//@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL headingDidStartUpdating;
//@property (nonatomic, strong) 

@end

@implementation TabCompassViewController



- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self viewDidLoad];
}

- (void)viewDidLoad{
    
    if (![self connected]) {
        self.theDistanceLabel.text = @"No Signal";
        self.closeSushiLabel.text = @":(";
        self.saiImage.alpha = 0;
        self.sadSushiImage.alpha = 1;
        
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
        return;
    }
    else {
     [super viewDidLoad];
    self.saiImage.alpha = 1;
    self.sadSushiImage.alpha = 0;
    [self setupCompassObjectsAndLabels];
    [self startStandardLocationServices];
    //[self.activityIndicator startAnimating];
    //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UITapGestureRecognizer *singleTapWebview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(webViewTapAreaTapped:)];
        [self.webviewTapArea addGestureRecognizer:singleTapWebview];
    }
}


-(void)setupCompassObjectsAndLabels

{
    
    VenueObject * thisNearPlace = [[VenueObject alloc] init];
//    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    thisNearPlace = appDelegate.closestVenue;
    
    //NSString *nearPlaceName = thisNearPlace.title;
//    NSNumber *temporaryDistancefromFS = thisNearPlace.distance;
//    NSString *distLabel = [NSString stringWithFormat:@"%@",temporaryDistancefromFS];
   
    //self.theDistanceLabel.text = @"Calculating";
    //self.theDistanceLabel.text = @"Calculating.";
   // self.theDistanceLabel.text = @"Calculating..";
   // self.theDistanceLabel.text = @"Calculating...";
    //return;
//    self.theDistanceLabel.text = distLabel;
    //self.c//nearPlaceName;
    //self.theDistanceLabel.text = distLabel;
    


}

-(void) startStandardLocationServices
{
    locationManager=[[CLLocationManager alloc] init];
	locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter =  kCLDistanceFilterNone;
	locationManager.headingFilter = kCLHeadingFilterNone;
	locationManager.delegate=self;
    
    [locationManager startUpdatingLocation];
    
    if([CLLocationManager headingAvailable]) {
        
        [locationManager startUpdatingHeading];
    } else {
//        NSLog(@"Location Heading/Compass FAIL");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* startLocation = [locations lastObject];
//    NSDate* eventDate = startLocation.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
//    if (abs(howRecent) < 15.0) {
    if (startLocation.coordinate.latitude == 0 && startLocation.coordinate.longitude == 0) {
       // NSLog(@"Location is 0,0.");
        return;
    }
    
    ourPhoneFloatLat = startLocation.coordinate.latitude;
        ourPhoneFloatLong = startLocation.coordinate.longitude;
        self.strLatitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.latitude];
        self.strLongitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.longitude];
    
    
    thisDistVenueLat = [appDelegate.closestVenue.venueLatitude floatValue];
    thisDistVenueLong = [appDelegate.closestVenue.venueLongitude floatValue];
  //  give latitude2,lang of destination   and latitude,longitude of first place.
    
    //this function return distance in kilometer.
    
    float DistRadCurrentLat = degreesToRadians(startLocation.coordinate.latitude);
    float DistRadCurrentLong = degreesToRadians(startLocation.coordinate.longitude);
    float DistRadthisVenueLat = degreesToRadians(thisDistVenueLat);
    float DistRadthisVenueLong = degreesToRadians(thisDistVenueLong);
    //float deltLat = (radthisVenueLat - radcurrentLat);
    float deltDistLat = (DistRadthisVenueLat - DistRadCurrentLat);
    float deltDistLong = (DistRadthisVenueLong - DistRadCurrentLong);
    
    float a = (sinf(deltDistLat/2) * sinf(deltDistLat/2)) + ((sinf(deltDistLong/2) * sinf(deltDistLong/2)) * cosf(DistRadCurrentLat) * cosf(DistRadthisVenueLat));
    float srootA = sqrtf(a);
    float srootoneMinusA = sqrtf((1-a));
    
    float c = (2 * atan2f(srootA, srootoneMinusA));
    
    float distBetweenStartandVenueMeters = (c * 6371*1000); //radius of earth
//    NSLog (@"the distance it's logging in m is %f", distBetweenStartandVenueMeters);
    
    float distBetweenStartandVenueFeet = (distBetweenStartandVenueMeters*3.281);
//    NSLog(@"the distance from foursquare is %@", appDelegate.closestVenue.distance);
   // float distBetweenStartandVenueKilometers = (c * 6371); //radius of earth
//    NSLog (@"%f", distBetweenStartandVenueKilometers);
    
    //float distBetweenStartandVenueFeet = (distBetweenStartandVenueMeters/3281);
    
//    NSLog (@"%f", distBetweenStartandVenueFeet);
    self.theDistance = [[NSString alloc] init];
    
   // float distPlaceHolder = [thisNearPlace.distance floatValue];
    int rounding = (distBetweenStartandVenueFeet);
    NSString *distLabel = [[NSString alloc] init];
    if (distBetweenStartandVenueFeet > 10000) {
        distLabel = [NSString stringWithFormat:@"Calculating..."];

                     }
    
   // if (distBetweenStartandVenueFeet < 75) {
     //   distLabel = [NSString stringWithFormat: @"Less than 100 feet, you're here, look up."];
        
   // }
    else if (distBetweenStartandVenueFeet > 2640 && distBetweenStartandVenueFeet < 3168){
        distLabel = @"0.5 miles";
    }
    
    else if (distBetweenStartandVenueFeet > 3168 && distBetweenStartandVenueFeet < 3696 ) {
        distLabel = @"0.6 miles";
    }
    
    else if (distBetweenStartandVenueFeet > 3696 && distBetweenStartandVenueFeet < 4224 ) {
        distLabel = @"0.7 miles";
    }
    
    else if (distBetweenStartandVenueFeet > 4224 && distBetweenStartandVenueFeet < 4752) {
        distLabel = @"0.8 miles";
    }
    else if (distBetweenStartandVenueFeet > 4752 && distBetweenStartandVenueFeet < 5016) {
        distLabel = @"0.9 miles";
    }
    else if (distBetweenStartandVenueFeet > 5016 && distBetweenStartandVenueFeet < 5808) {
        distLabel = @"1 mile";
    }
    
    else if (distBetweenStartandVenueFeet > 5808 && distBetweenStartandVenueFeet < 6336) {
        distLabel = @"1.1 miles";
    }
    else if (distBetweenStartandVenueFeet > 6336 && distBetweenStartandVenueFeet < 6864) {
        distLabel = @"1.2 miles";
    }
    else if (distBetweenStartandVenueFeet > 6864 && distBetweenStartandVenueFeet < 7392) {
        distLabel = @"1.3 miles";
    }
    else if (distBetweenStartandVenueFeet > 7392 && distBetweenStartandVenueFeet < 7920) {
        distLabel = @"1.4 miles";
    }
    else if (distBetweenStartandVenueFeet > 7920 && distBetweenStartandVenueFeet < 8448) {
        distLabel = @"1.5 miles";
    }
    else if (distBetweenStartandVenueFeet > 8448 && distBetweenStartandVenueFeet < 8976) {
        distLabel = @"1.6 miles";
    }
    else if (distBetweenStartandVenueFeet > 8976 && distBetweenStartandVenueFeet < 9504) {
        distLabel = @"1.7 miles";
    }
    else if (distBetweenStartandVenueFeet > 9504 && distBetweenStartandVenueFeet < 10032) {
        distLabel = @"1.8 miles";
    }
    else if (distBetweenStartandVenueFeet > 10032 && distBetweenStartandVenueFeet < 10560) {
        distLabel = @"1.9 miles";
    }
    else if (distBetweenStartandVenueFeet > 10560 && distBetweenStartandVenueFeet < 11088) {
        distLabel = @"2.0 miles";
    }
    else if (distBetweenStartandVenueFeet > 11088 && distBetweenStartandVenueFeet < 11616) {
        distLabel = @"2.1 miles";
    }
    else if (distBetweenStartandVenueFeet > 11616 && distBetweenStartandVenueFeet < 12144) {
        distLabel = @"2.2 miles";
    }
    else if (distBetweenStartandVenueFeet > 12144 && distBetweenStartandVenueFeet < 12672) {
        distLabel = @"2.3 miles";
    }
    else if (distBetweenStartandVenueFeet > 12672 && distBetweenStartandVenueFeet < 13200) {
        distLabel = @"2.4 miles";
    }
    else if (distBetweenStartandVenueFeet > 13200 && distBetweenStartandVenueFeet < 13728) {
        distLabel = @"2.5 miles";
    }
    else if (distBetweenStartandVenueFeet > 13728 && distBetweenStartandVenueFeet < 14256) {
        distLabel = @"2.6 miles";
    }
    else if (distBetweenStartandVenueFeet > 14256 && distBetweenStartandVenueFeet < 14784) {
        distLabel = @"2.7 miles";
    }
    else if (distBetweenStartandVenueFeet > 14784 && distBetweenStartandVenueFeet < 15312) {
        distLabel = @"2.8 miles";
    }
    else if (distBetweenStartandVenueFeet > 15312 && distBetweenStartandVenueFeet < 15840) {
        distLabel = @"2.9 miles";
    }
    else if (distBetweenStartandVenueFeet > 15840 && distBetweenStartandVenueFeet < 16368) {
        distLabel = @"3.0 miles";
    }
    else if (distBetweenStartandVenueFeet > 16368 && distBetweenStartandVenueFeet < 16896) {
        distLabel = @"3.1 miles";
    }
    else if (distBetweenStartandVenueFeet > 16896 && distBetweenStartandVenueFeet < 17424) {
        distLabel = @"3.2 miles";
    }
    else if (distBetweenStartandVenueFeet > 17424 && distBetweenStartandVenueFeet < 17952) {
        distLabel = @"3.3 miles";
    }
    else if (distBetweenStartandVenueFeet > 17952 && distBetweenStartandVenueFeet < 18480) {
        distLabel = @"3.4 miles";
    }
    else if (distBetweenStartandVenueFeet > 18480 && distBetweenStartandVenueFeet < 19008) {
        distLabel = @"3.5 miles";
    }
    else if (distBetweenStartandVenueFeet > 19008 && distBetweenStartandVenueFeet < 19536) {
        distLabel = @"3.6 miles";
    }
    else if (distBetweenStartandVenueFeet > 19536 && distBetweenStartandVenueFeet < 20064) {
        distLabel = @"3.7 miles";
    }
    
    else if (distBetweenStartandVenueFeet > 20064 && distBetweenStartandVenueFeet < 20592) {
        distLabel = @"3.8 miles";
    }
    else if (distBetweenStartandVenueFeet > 20592 && distBetweenStartandVenueFeet < 21120) {
        distLabel = @"3.9 miles";
    }
    else if (distBetweenStartandVenueFeet > 21120 && distBetweenStartandVenueFeet < 21648) {
        distLabel = @"4.0 miles";
    }
    else if (distBetweenStartandVenueFeet > 21648 && distBetweenStartandVenueFeet < 22176) {
        distLabel = @"4.1 miles";
    }
    else if (distBetweenStartandVenueFeet > 22176 && distBetweenStartandVenueFeet < 22704) {
        distLabel = @"4.2 miles";
    }
    else if (distBetweenStartandVenueFeet > 22704 && distBetweenStartandVenueFeet < 23232) {
        distLabel = @"4.3 miles";
    }
    else if (distBetweenStartandVenueFeet > 23232 && distBetweenStartandVenueFeet < 23760) {
        distLabel = @"4.4 miles";
    }
    else if (distBetweenStartandVenueFeet > 23760 && distBetweenStartandVenueFeet < 24288) {
        distLabel = @"4.5 miles";
    }
    else if (distBetweenStartandVenueFeet > 24288 && distBetweenStartandVenueFeet < 24816) {
        distLabel = @"4.6 miles";
    }
    else if (distBetweenStartandVenueFeet > 24816 && distBetweenStartandVenueFeet < 25344) {
        distLabel = @"4.7 miles";
    }
    
    else if (distBetweenStartandVenueFeet > 25344 && distBetweenStartandVenueFeet < 25872) {
        distLabel = @"4.8 miles";
    }
    else if (distBetweenStartandVenueFeet > 25872 && distBetweenStartandVenueFeet < 26400) {
        distLabel = @"4.9 miles";
    }
    else if (distBetweenStartandVenueFeet > 26400 && distBetweenStartandVenueFeet < 26928) {
        distLabel = @"5.0 miles";
    }
    else if (distBetweenStartandVenueFeet > 26928 && distBetweenStartandVenueFeet < 100000) {
        distLabel = @"5+ miles";
    }
    
        else
     
        {
            distLabel = [NSString stringWithFormat:@"%i feet", rounding];
            self.saiImage.alpha = 1;
            self.sadSushiImage.alpha = 0;
    }
    
   // NSString *distLabel = [NSString stringWithFormat:@"%i feet",rounding];
    self.theDistance = distLabel;
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
    //[self.activityIndicator stopAnimating];
    //[[UIApplication sharedApplication] endIgnoringInteractionEvents];

    if (!self.headingDidStartUpdating) {
        [self setupCompassObjectsAndLabels];
        self.headingDidStartUpdating = YES;
    }
    
    thisVenueLat = [appDelegate.closestVenue.venueLatitude floatValue];
    thisVenueLong = [appDelegate.closestVenue.venueLongitude floatValue];
    
    float radcurrentLat = degreesToRadians(ourPhoneFloatLat);
    float radcurrentLong = degreesToRadians(ourPhoneFloatLong);
    float radthisVenueLat = degreesToRadians(thisVenueLat);
    float radthisVenueLong = degreesToRadians(thisVenueLong);
    //float deltLat = (radthisVenueLat - radcurrentLat);
    float deltLong = (radthisVenueLong - radcurrentLong);
    
    float y = sinf(deltLong) * cosf(radthisVenueLat);
    float x = (cosf(radcurrentLat) * sinf(radthisVenueLat)) - ((sinf(radcurrentLat) *cosf(radthisVenueLat)) * cosf(deltLong));
    float radRotateAngle = atan2f(y, x);
    float initialVenueBearing = radRotateAngle;
    float VenueBearDeg;
    
    float initialVenueBearingDegrees = initialVenueBearing * 180/M_PI;
    
    if (initialVenueBearingDegrees < 0) {
        VenueBearDeg = initialVenueBearingDegrees + 360;
    }
    else{
        VenueBearDeg = initialVenueBearingDegrees;
    };
    

   // NSLog(@"Initial bearing/initial angle rotation from north in degrees is = %f", VenueBearDeg);
    VenueObject * thisNearPlace = [[VenueObject alloc] init];
//    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    thisNearPlace = appDelegate.closestVenue;

    
    NSString *nearPlaceName = thisNearPlace.title;
    self.closeSushiLabel.text = nearPlaceName;

    //trig calculations necessary to display additional navigation information (distance, etc, spherical of cosines).
   // float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    //
    //float newRad =  newHeading.trueHeading * M_PI / 180.0f;
    //float managerheadRad = manager.heading.trueHeading * M_PI/180.0f;
    //float newHeadingRad = newHeading.trueHeading * M_PI /180.0f;
    float angleCalc;
    if (newHeading.trueHeading > VenueBearDeg)
    {angleCalc = -(newHeading.trueHeading - VenueBearDeg);
    }
    else
    {angleCalc = VenueBearDeg - newHeading.trueHeading;
    }
    //float angleCalc = (VenueBearDeg - newHeading.magneticHeading);
    
   // NSLog(@"%@", self.nearestPlaceLabel.text);
    float radAngleCalc = angleCalc * M_PI / 180.0f;
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //theAnimation.fromValue = [NSNumber numberWithFloat:0];
    //theAnimation.toValue=[NSNumber numberWithFloat:radAngleCalc];
    theAnimation.duration = .8f;
    self.closeSushiLabel.text = nearPlaceName;
    self.theDistanceLabel.text = self.theDistance;

    [self.saiImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    self.saiImage.transform = CGAffineTransformMakeRotation(radAngleCalc);
    if (![self connected]) {
        self.theDistanceLabel.text = @"No Signal";
        self.closeSushiLabel.text = @":(";
//        self.saiImage.alpha = 0;
//        self.sadSushiImage.alpha = 1;
    }
    
    //NSNumber *distY = thisNearPlace.distance;
    
    // NSLog (@"the distance it's logging in km is %f", distBetweenStartandVenueMeters);
    
    //float distPlaceHolder = [thisNearPlace.distance floatValue];
    //int rounding = (distBetweenStartandVenueMeters);
    
    //NSNumber *disttemp = roundf(distPlaceHolder);
//    NSString *distLabel = [NSString stringWithFormat:@"%i",rounding];
//    NSLog(@"%@", distLabel);
//    self.theDistance = distLabel;
//
//    
       //NSLog(@"true heading is %f", newHeading.trueHeading);

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[locationManager stopUpdatingHeading];
    [locationManager pausesLocationUpdatesAutomatically];// Or pause
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fSVenuePageButton:(id)sender {
    NSString * stringUrlForFS = [[NSString alloc] init];
    stringUrlForFS = appDelegate.closestVenue.fourSquareVenuePage;
    if (stringUrlForFS == NULL || stringUrlForFS == nil) {
        stringUrlForFS = @"www.foursquare.com";
    }
        else
        {
            stringUrlForFS = appDelegate.closestVenue.fourSquareVenuePage;
            
    }
    NSLog(@"this is the url for the restuarant returned from AppDel/Parse:  %@", stringUrlForFS);
    self.tempFSVenuePageUrl = stringUrlForFS;
    
    [self performSegueWithIdentifier:@"fromCompassToFSWebView" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fromCompassToFSWebView"]) {
        compassWebbyViewController = segue.destinationViewController;
        compassWebbyViewController.fSVenueWebPage = self.tempFSVenuePageUrl;
        NSLog(@"%@",self.tempFSVenuePageUrl);
        
    }
    
}
- (IBAction)webViewTapAreaTapped:(id)sender{
    NSString * stringUrlForFS = [[NSString alloc] init];
    stringUrlForFS = appDelegate.closestVenue.fourSquareVenuePage;
    if (stringUrlForFS == NULL || stringUrlForFS == nil) {
        stringUrlForFS = @"www.foursquare.com";
    }
    else
    {
        stringUrlForFS = appDelegate.closestVenue.fourSquareVenuePage;
        
    }
    NSLog(@"this is the url for the restuarant returned from AppDel/Parse:  %@", stringUrlForFS);
    self.tempFSVenuePageUrl = stringUrlForFS;
    
    [self performSegueWithIdentifier:@"fromCompassToFSWebView" sender:self];
}


@end