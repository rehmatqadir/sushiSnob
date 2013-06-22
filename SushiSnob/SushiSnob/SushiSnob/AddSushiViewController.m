//
//  AddSushiViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AddSushiViewController.h"
#import "LocationManagerSingleton.h"
#import "VenueObject.h"
//for pic taking
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddSushiViewController ()
{
    float picLatitude;
    float picLongitude;
}

@end
NSMutableArray* venueArray;


@implementation AddSushiViewController

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
	// Do any additional setup after loading the view.
    [self.sushiGoodOrNot setTitle:@"Good!" forSegmentAtIndex:0];
    [self.sushiGoodOrNot setTitle:@"Bad!" forSegmentAtIndex:1];
    picLatitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude;
    picLongitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.longitude;
    [self venueSearch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark done and cancel buttons

- (IBAction)doneAddingSushi:(id)sender {
    //do this later after all inputs are setup
    
    [self.sushiTableUpdateDelegate updateSushiTableView];


    [self.addSushiDelegate addSushiName:self.sushiNameTextField.text addSushiPicture:self.selectedImage addSushiDate:[NSDate date] addSushiGoodOrNot:[self sushiIsGoodOrNot] addSushiDescription:self.sushiDescription.text addSushiCityName:self.sushiCityName.text addLatitude:picLatitude addLongitude:picLongitude];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //test
        
    }];
    


}

- (IBAction)cancelAddingSushi:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)changeSushiGoodOrNot:(id)sender {
//    if (self.sushiGoodOrNot.selectedSegmentIndex == 0) {
//        self.sushiIsGood = YES;
//    } else {
//        self.sushiIsGood = NO;
//    }
//}

#pragma mark UI elements

-(BOOL)sushiIsGoodOrNot
{
    if (self.sushiGoodOrNot.selectedSegmentIndex == 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

- (IBAction)add4QVenue:(id)sender {
}

- (IBAction)sushiDescriptionRecordVoice:(id)sender {
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark take picture

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.view == self.sushiPictureViewHolder) {
        [self createActionSheet];
    }
}

-(void)createActionSheet
{
    //still need to figure out how to disable a button
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Photo of Sushi" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Pic with Camera", @"Choose from Library", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    if (buttonIndex == 0) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else if (buttonIndex == 1) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageTaken = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.selectedImage = imageTaken;
    self.sushiPic.image = imageTaken;
    
    CLLocationDegrees pictureLatitude = picLatitude;
    CLLocationDegrees pictureLongitude = picLongitude;
    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:pictureLatitude longitude:pictureLongitude];
    
    NSMutableDictionary *pictureOriginalMetadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSDictionary *gpsDataDictionary = [self getGPSDictionaryForLocation:clLocation];
    
    [pictureOriginalMetadata setObject:gpsDataDictionary forKey:(NSString*)kCGImagePropertyGPSDictionary];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library addAssetsGroupAlbumWithName:@"Sushi" resultBlock:^(ALAssetsGroup *group) {

    } failureBlock:^(NSError *error) {

    }];
    
    //why?
    __block ALAssetsGroup *assetsGroup;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Sushi"]) {
            assetsGroup = group;
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"fail");
    }];
    
    CGImageRef img = [imageTaken CGImage];
    
    [library writeImageToSavedPhotosAlbum:img metadata:pictureOriginalMetadata completionBlock:^(NSURL *assetURL, NSError *error) {
        
        if (error.code == 0) {
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                [assetsGroup addAsset:asset];
            } failureBlock:^(NSError *error) {
                NSLog(@"fail");
            }];
        } else {
            NSLog(@"fail");
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSString *stringForGoogleAPI = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",pictureLatitude, pictureLongitude];
        NSURL *url = [NSURL URLWithString:stringForGoogleAPI];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
            NSMutableDictionary *objectsDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSMutableArray *resultsArray = [NSMutableArray array];
            resultsArray = [objectsDict objectForKey:@"results"];
            NSMutableDictionary *zeroDict = [resultsArray objectAtIndex:0];
            NSMutableArray *addressComponentsArray = [zeroDict objectForKey:@"address_components"];
            NSMutableDictionary *boroughDict = [addressComponentsArray objectAtIndex:3];
            NSMutableDictionary *cityDict = [addressComponentsArray objectAtIndex:4];
            NSString *boroughName = [boroughDict objectForKey:@"long_name"];
            NSString *cityName = [cityDict objectForKey:@"long_name"];
            self.sushiCityName.text = [NSString stringWithFormat:@"%@, %@", boroughName, cityName];
        }];

    }];
}

- (NSDictionary *)getGPSDictionaryForLocation:(CLLocation *)location {
    NSMutableDictionary *gps = [NSMutableDictionary dictionary];
    
    // GPS tag version
    [gps setObject:@"2.2.0.0" forKey:(NSString *)kCGImagePropertyGPSVersion];
    
    // Time and date must be provided as strings, not as an NSDate object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSDateStamp];
    
    // Latitude
    CGFloat latitude = location.coordinate.latitude;
    if (latitude < 0) {
        latitude = -latitude;
        [gps setObject:@"S" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    } else {
        [gps setObject:@"N" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    
    // Longitude
    CGFloat longitude = location.coordinate.longitude;
    if (longitude < 0) {
        longitude = -longitude;
        [gps setObject:@"W" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    } else {
        [gps setObject:@"E" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    
    // Altitude
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        if (altitude < 0) {
            altitude = -altitude;
            [gps setObject:@"1" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        } else {
            [gps setObject:@"0" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        }
        [gps setObject:[NSNumber numberWithFloat:altitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
    }
    
    // Speed, must be converted from m/s to km/h
    if (location.speed >= 0){
        [gps setObject:@"K" forKey:(NSString *)kCGImagePropertyGPSSpeedRef];
        [gps setObject:[NSNumber numberWithFloat:location.speed*3.6] forKey:(NSString *)kCGImagePropertyGPSSpeed];
    }
    
    // Heading
    if (location.course >= 0){
        [gps setObject:@"T" forKey:(NSString *)kCGImagePropertyGPSTrackRef];
        [gps setObject:[NSNumber numberWithFloat:location.course] forKey:(NSString *)kCGImagePropertyGPSTrack];
    }
    
    return gps;
}

#pragma venueSearch
-(void) venueSearch
{
    float userLatitude;
    float userLongitude;
    //VenueObject *selectedVenue;
    NSMutableDictionary *listVenue;
    userLatitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude;
    userLongitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.longitude;
    
    NSLog(@"userLong %f", userLongitude);
    NSLog(@"userlat %f", userLatitude);

    
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


@end
