//
//  SushiDetailViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "SushiDetailViewController.h"
#import "SushiDetailMKAnnotation.h"
#import "SushiVenueAnnotationView.h"
#import "SushiDetailFullPictureViewController.h"

@interface SushiDetailViewController ()
{
    //social stuff
    SLComposeViewController *slComposeViewController;
    UIActivityViewController *uiActivityViewController;
}
@end

@implementation SushiDetailViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"viewFullPicture"]){
        SushiDetailFullPictureViewController *sushiDetailFullPictureViewController = [segue destinationViewController];
        [sushiDetailFullPictureViewController setSushiImage:self.sushiDetailImage.image];
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
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, 568)];
    
    //title
    self.title = self.selectedSushi.name;
    //image
    self.fileManager = [NSFileManager defaultManager];
    self.documentsDirectory = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSString *fileName = self.selectedSushi.sushiImageURL;
    if (fileName != nil) {
        NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
        self.sushiDetailImage.image = [UIImage imageWithContentsOfFile:localImageURL.path];
    } else {
        self.sushiDetailImage.image = [UIImage imageNamed:@"sushi.jpeg"];
    }
    //small image sushi type and thumbs
    NSString *boolString = [NSString stringWithFormat:@"%@", self.selectedSushi.isRatedGood];
    
    if ([boolString isEqualToString:@"1"]) {
        self.sushiType.image = [UIImage imageNamed:@"thumbsUp.png"];
    } else if ([boolString isEqualToString:@"0"])  {
        self.sushiType.image = [UIImage imageNamed:@"thumbsDown.png"];
    }
    
    //venue
    self.sushiDetailVenue.text = self.selectedSushi.venue;
    
    //address
    self.sushiAddress.text = self.selectedSushi.address;
    
    //date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM.dd.yyyy"];
    self.sushiDetailDate.text = [dateFormatter stringFromDate:self.selectedSushi.date];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTapped:)];
    [self.sushiDetailImage addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMapZoom
{
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake([self.selectedSushi.latitude doubleValue], [self.selectedSushi.longitude doubleValue]);
    MKCoordinateSpan span = MKCoordinateSpanMake(.05, .05);
    MKCoordinateRegion region = MKCoordinateRegionMake(mapCenter, span);
    self.sushiDetailMapView.region = region;
    
    SushiDetailMKAnnotation *sushiDetailMKAnnotation = [[SushiDetailMKAnnotation alloc] init];
    sushiDetailMKAnnotation.coordinate = CLLocationCoordinate2DMake([self.selectedSushi.latitude doubleValue], [self.selectedSushi.longitude doubleValue]);
    [self.sushiDetailMapView addAnnotation:sushiDetailMKAnnotation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *reuseIdentifier = @"myIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    
    if (annotationView == nil) {
        annotationView = [[SushiVenueAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    } else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (IBAction)shareToSocial:(id)sender {
    NSString *someText = [NSString stringWithFormat:@"check out this %@. found with #sushisnob",self.selectedSushi.name];
    NSArray *dataToShare = @[someText, self.sushiDetailImage.image];
    
    uiActivityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    uiActivityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeMessage, UIActivityTypeCopyToPasteboard,UIActivityTypePostToWeibo, UIActivityTypeAssignToContact];
    [self presentViewController:uiActivityViewController animated:YES completion:^{
        //stuff
    }];
}

- (IBAction)tapTapped:(id)sender {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [self performSegueWithIdentifier: @"viewFullPicture" sender: self];
}
@end
