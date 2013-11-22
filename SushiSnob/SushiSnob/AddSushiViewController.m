//
//  AddSushiViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "AddSushiViewController.h"
#import "LocationManagerSingleton.h"
#import "AddVenueVC.h"

//for pic taking
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddSushiViewController ()

{
    float picLatitude;
    float picLongitude;
    int countForDoneButton;
}

- (IBAction)getLatLong:(id)sender;

-(IBAction)takePicture:(id)sender;
-(IBAction)addName:(id)sender;
-(IBAction)addVenue:(id)sender;

-(IBAction)thumbsUpViewTapped:(id)sender;
-(IBAction)thumbsDownViewTapped:(id)sender;

-(IBAction)rollViewTapped:(id)sender;
-(IBAction)sushiViewTapped:(id)sender;
-(IBAction)sashimiViewTapped:(id)sender;
-(IBAction)otherViewTapped:(id)sender;

@end

//textFieldAnimation
CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation AddSushiViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"add4SSushiVenue"]) {
        
        //((AddVenueVC*)segue.destinationViewController).venueDelegate = self;
        AddVenueVC *addVenueVC = [segue destinationViewController];
        addVenueVC.venueDelegate = self;
    }
}

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
    [LocationManagerSingleton sharedSingleton];
    
    self.sushiIsGood = YES;
    self.doneButton.enabled = NO;
    self.sushiDescription = @"chopsticksTV.png";
    
    UITapGestureRecognizer *singleTapPicture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
    [self.takePictureView addGestureRecognizer:singleTapPicture];
    
    UITapGestureRecognizer *singleTapName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addName:)];
    [self.addSushiNameView addGestureRecognizer:singleTapName];
    
    UITapGestureRecognizer *singleTapVenue = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addVenue:)];
    [self.addVenueView addGestureRecognizer:singleTapVenue];
    
    UITapGestureRecognizer *singleTapThumbsUp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbsUpViewTapped:)];
    [self.thumbsUpView addGestureRecognizer:singleTapThumbsUp];
    
    UITapGestureRecognizer *singleTapThumbsDown = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbsDownViewTapped:)];
    [self.thumbsDownView addGestureRecognizer:singleTapThumbsDown];
    
    UITapGestureRecognizer *singleTapRoll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rollViewTapped:)];
    [self.rollView addGestureRecognizer:singleTapRoll];
    
    UITapGestureRecognizer *singleTapSushi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sushiViewTapped:)];
    [self.sushiView addGestureRecognizer:singleTapSushi];
    
    UITapGestureRecognizer *singleTapSashimi = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sashimiViewTapped:)];
    [self.sashimiView addGestureRecognizer:singleTapSashimi];
    
    UITapGestureRecognizer *singleTapOther = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherViewTapped:)];
    [self.otherView addGestureRecognizer:singleTapOther];
    
    //sushi default pic
    self.selectedImage = [UIImage imageNamed:@"sushi.jpeg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark done and cancel buttons

- (IBAction)doneAddingSushi:(id)sender {
    //do this later after all inputs are setup
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //dispatch_queue_t delegateQueue = dispatch_queue_create("for delegate", NULL);
    //dispatch_async(delegateQueue, ^{
        if ([self.venueLabel.text isEqualToString:@"add restaurant"]) {
            self.venueLabel.text = @"";
        }
        
        [self.addSushiDelegate addSushiName:self.sushiNameTextField.text addSushiPicture:self.selectedImage addSushiDate:[NSDate date] addSushiGoodOrNot:self.sushiIsGood addSushiVenue:self.venueLabel.text addSushiDescription:self.sushiDescription addSushiAddress:self.sushiAddress addLatitude:picLatitude addLongitude:picLongitude];
    //});
}

- (IBAction)cancelAddingSushi:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UI elements

- (IBAction)add4QVenue:(id)sender {

}

#pragma TEXTFIELD DELEGATES
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    {
        CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
        CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
        CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
        CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
        CGFloat heightFraction = numerator / denominator;
        
        
        if (heightFraction < 0.0)
        {
            heightFraction = 0.0;
        } else if (heightFraction > 1.0) {
            heightFraction = 1.0;
        }
        
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= animatedDistance;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        
        [self.view setFrame:viewFrame];
        
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
    NSString *rawString = [textField text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0) {
        // Text was empty or only whitespace.
        self.doneButton.enabled = NO;
        self.addSushiNameImageView.image = [UIImage imageNamed:@"soySauce.png"];
        self.sushiNameLabel.hidden = NO;
        self.sushiNameTextField.hidden = YES;
        self.sushiNameLabel.text = @"add sushi name";
        self.sushiNameTextField.textColor = [UIColor colorWithRed:(250/255.f) green:(239/255.f) blue:(207/255.f) alpha:1];
    } else {
        self.doneButton.enabled = YES;
        self.addSushiNameImageView.image = [UIImage imageNamed:@"soySaucePink.png"];
        self.sushiNameLabel.text = self.sushiNameTextField.text;
        self.sushiNameTextField.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
        self.sushiNameLabel.hidden = YES;
        self.sushiNameTextField.hidden = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark take picture

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.view == self.sushiPictureViewHolder) {
        [self createActionSheet];
    }
    //touch on screen to resign keyboard
    [self.sushiNameTextField resignFirstResponder];
    //[self.sushiDescription resignFirstResponder];
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
    
    BOOL cameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if (buttonIndex == 0 && !cameraAvailable){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Camera Unavailable" message:@"Please Select Photo from Library" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
    if (buttonIndex == 0 && cameraAvailable) {
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
    self.takePictureViewImageView.image = imageTaken;
    
    dispatch_queue_t addGeolocationQueue = dispatch_queue_create("add geolocation to pic", NULL);
    
    dispatch_async(addGeolocationQueue, ^{
        self.selectedImage = imageTaken;
        CLLocationDegrees pictureLatitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.latitude;
        CLLocationDegrees pictureLongitude = [LocationManagerSingleton sharedSingleton].userLocation.coordinate.longitude;
        picLatitude = pictureLatitude;
        picLongitude = pictureLongitude;
        CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:pictureLatitude longitude:pictureLongitude];
        
        NSMutableDictionary *pictureOriginalMetadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        NSDictionary *gpsDataDictionary = [self getGPSDictionaryForLocation:clLocation];
        
        [pictureOriginalMetadata setObject:gpsDataDictionary forKey:(NSString*)kCGImagePropertyGPSDictionary];
        
    });//dispatch end
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.addSushiPictureLabel.text = @"picture added";
        self.addSushiPictureLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
        
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

-(void)updateVenueLabel:(NSString *)venue address:(NSString*)address
{
    self.venueLabel.text = venue;
    self.sushiAddress = address;
    NSLog(@"%@",address);
    self.venueLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
    self.addVenueViewImageView.image = [UIImage imageNamed:@"compassPink.png"];
}

- (IBAction)getLatLong:(id)sender {
}

#pragma mark actions for touching views

-(IBAction)takePicture:(id)sender
{
    [self createActionSheet];
}

-(IBAction)addName:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.sushiNameTextField.hidden = NO;
    self.sushiNameLabel.hidden = YES;
    [self.sushiNameTextField becomeFirstResponder];
}

-(IBAction)addVenue:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self performSegueWithIdentifier: @"add4SSushiVenue" sender: self];
}

-(IBAction)thumbsUpViewTapped:(id)sender{
    self.sushiIsGood = YES;
    self.thumbsUpView.alpha = 1;
    self.thumbsUpImageView.image = [UIImage imageNamed:@"thumbsUpPink.png"];
    self.thumbsDownImageView.image = [UIImage imageNamed:@"thumbsDown.png"];
    self.thumbsDownView.alpha = 0.5;
    NSLog(@"%c",self.sushiIsGood);
    self.enjoyItLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
}
-(IBAction)thumbsDownViewTapped:(id)sender
{
    self.sushiIsGood = NO;
    self.thumbsUpView.alpha = 0.5;
    self.thumbsUpImageView.image = [UIImage imageNamed:@"thumbsUp.png"];
    self.thumbsDownImageView.image = [UIImage imageNamed:@"thumbsDownPink.png"];
    self.thumbsDownView.alpha = 1;
    NSLog(@"%c",self.sushiIsGood);
    self.enjoyItLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
}

-(IBAction)rollViewTapped:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.sushiDescription = @"sushiRollTV.png";
    
    self.rollImageView.image = [UIImage imageNamed:@"sushiRollTVPink.png"];
    self.rollView.alpha = 1;
    self.sushiImageView.image = [UIImage imageNamed:@"sushiTV.png"];
    self.sushiView.alpha = 0.5;
    self.sashimiImageView.image = [UIImage imageNamed:@"sashimiTV.png"];
    self.sashimiView.alpha = 0.5;
    self.otherImageView.image = [UIImage imageNamed:@"chopsticksTV.png"];
    self.otherView.alpha = 0.5;
    
    self.sushiTypeLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];

    NSLog(@"%@",self.sushiDescription);
}

-(IBAction)sushiViewTapped:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.sushiDescription = @"sushiTV.png";
    
    self.rollImageView.image = [UIImage imageNamed:@"sushiRollTV.png"];
    self.rollView.alpha = 0.5;
    self.sushiImageView.image = [UIImage imageNamed:@"sushiTVPink.png"];
    self.sushiView.alpha = 1;
    self.sashimiImageView.image = [UIImage imageNamed:@"sashimiTV.png"];
    self.sashimiView.alpha = 0.5;
    self.otherImageView.image = [UIImage imageNamed:@"chopsticksTV.png"];
    self.otherView.alpha = 0.5;
    
    self.sushiTypeLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
    NSLog(@"%@",self.sushiDescription);
}

-(IBAction)sashimiViewTapped:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.sushiDescription = @"sashimiTV.png";
    
    self.rollImageView.image = [UIImage imageNamed:@"sushiRollTV.png"];
    self.rollView.alpha = 0.5;
    self.sushiImageView.image = [UIImage imageNamed:@"sushiTV.png"];
    self.sushiView.alpha = 0.5;
    self.sashimiImageView.image = [UIImage imageNamed:@"sashimiTVPink.png"];
    self.sashimiView.alpha = 1;
    self.otherImageView.image = [UIImage imageNamed:@"chopsticksTV.png"];
    self.otherView.alpha = 0.5;
    
    self.sushiTypeLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
    NSLog(@"%@",self.sushiDescription);
}

-(IBAction)otherViewTapped:(id)sender
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.sushiDescription = @"chopsticksTV.png";
    
    self.rollImageView.image = [UIImage imageNamed:@"sushiRollTV.png"];
    self.rollView.alpha = 0.5;
    self.sushiImageView.image = [UIImage imageNamed:@"sushiTV.png"];
    self.sushiView.alpha = 0.5;
    self.sashimiImageView.image = [UIImage imageNamed:@"sashimiTV.png"];
    self.sashimiView.alpha = 0.5;
    self.otherImageView.image = [UIImage imageNamed:@"chopsticksTVPink.png"];
    self.otherView.alpha = 1;
    
    self.sushiTypeLabel.textColor = [UIColor colorWithRed:(242/255.f) green:(111/255.f) blue:(74/255.f) alpha:1];
    NSLog(@"%@",self.sushiDescription);
}

@end
