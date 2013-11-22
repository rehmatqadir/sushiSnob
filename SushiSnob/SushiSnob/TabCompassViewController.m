//
//  TabCompassViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 6/8/13.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//
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
    AppDelegate *appDelegate;
    BOOL activityIndicatorStopped;
    CompassWebiViewViewController *compassWebbyViewController;
}

#define degreesToRadians(x) (M_PI * x / 180.0)
#define radiandsToDegrees(x) (x * 180.0 / M_PI)

@property (nonatomic, strong) NSString * strLatitude;
@property (nonatomic, strong) NSString * strLongitude;
@property (nonatomic, weak) NSString *vcURLString;
@property (nonatomic) BOOL headingDidStartUpdating;

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
    self.vcURLString = appDelegate.logURL;
    NSLog(@"search url is %@", self.vcURLString);
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

    if (startLocation.coordinate.latitude == 0 && startLocation.coordinate.longitude == 0) {
        return;
    }
    
    ourPhoneFloatLat = startLocation.coordinate.latitude;
        ourPhoneFloatLong = startLocation.coordinate.longitude;
        self.strLatitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.latitude];
        self.strLongitude = [NSString stringWithFormat: @"%f", startLocation.coordinate.longitude];
    
    
    thisDistVenueLat = [appDelegate.closestVenue.venueLatitude floatValue];
    thisDistVenueLong = [appDelegate.closestVenue.venueLongitude floatValue];
  //  give latitude2,lang of destination   and latitude,longitude of first place.
    
    //this function returns distance in kilometer.
    
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
    int distBetweenStartandVenueMiles = (distBetweenStartandVenueFeet/5280);
    if (distBetweenStartandVenueFeet > 5280)
    {
        rounding = distBetweenStartandVenueMiles;
    }
    else
    {
        rounding = distBetweenStartandVenueFeet;
    };

       NSString *distLabel = [[NSString alloc] init];

        {
            if (distBetweenStartandVenueFeet > 5280) {
                //distLabel = [NSString stringWithFormat:@"Calculating..."];
                distLabel = [NSString stringWithFormat:@"%i miles", rounding];
                
            }
            else
                distLabel = [NSString stringWithFormat:@"%i feet", rounding];
                
                if (rounding < 150) {
                    
            distLabel = [NSString stringWithFormat:@" <150 feet, look up!"];
            self.saiImage.alpha = 1;
            self.sadSushiImage.alpha = 0;
    }
    
   // NSString *distLabel = [NSString stringWithFormat:@"%i feet",rounding];
    self.theDistance = distLabel;
        }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{

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