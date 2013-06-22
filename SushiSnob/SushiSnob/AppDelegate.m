//
//  AppDelegate.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AppDelegate.h"
#import "VenueObject.h"
#import "TabCompassViewController.h"
#import "TabCompassViewController.h"
#import "TabMapViewController.h"

@interface AppDelegate ()
{

   
    VenueObject *selectedVenue;
    
    //parse variables
    NSMutableArray * fourSquareVenueResultsArray;
    NSMutableDictionary *listVenue;
    VenueObject* fourSquareVenueObject;
    NSDictionary *categoryDictionary;
    NSMutableArray *categoryArray;
    NSMutableDictionary *categoryInfo;
    NSMutableDictionary * checkinStats;
    NSMutableArray *arrayWithDistance;
    BOOL didRunFourSquareParse;
}

@property (nonatomic, strong) NSString * strLatitude;
@property (nonatomic, strong) NSString * strLongitude;

-(void)setupManagerContextModel;

@end


@implementation AppDelegate

-(void)setupManagerContextModel
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectoryURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL *modelUrl = [[NSBundle mainBundle]URLForResource:@"SushiSnob" withExtension:@"momd"];
    NSURL *persistentStoreDestinationUrl = [documentsDirectoryURL URLByAppendingPathComponent:@"SushiSnob.sqlite"];
    
    //pointing to the model -- what the data looks like -- not the actual data -- sort of like setting up the properties -- model holds data
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    //doesn't create the data -- it simply giving the persistanceStoreCoordinator access to the model
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error = nil;
    //so this is where the actual lies
    NSPersistentStore *persistenceStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreDestinationUrl options:nil error:&error];
    
    if (persistenceStore != nil) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    didRunFourSquareParse = NO;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupManagerContextModel];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController *navigationController0 = [[tabBarController viewControllers] objectAtIndex:0];
    TabMapViewController *tabMapViewController = [[navigationController0 viewControllers] objectAtIndex:0];
    tabMapViewController.managedObjectContext = self.managedObjectContext;

    TabCompassViewController *tabCompassViewController = [[tabBarController viewControllers] objectAtIndex:1];
    tabCompassViewController.managedObjectContext = self.managedObjectContext;

    UINavigationController *navigationController2 = [[tabBarController viewControllers] objectAtIndex:2];
    TabMySushiViewController *tabSushiViewController = [[navigationController2 viewControllers] objectAtIndex:0];
    tabSushiViewController.managedObjectContext = self.managedObjectContext;
    
    [tabBarController setSelectedIndex:1];
    
    [self startStandardLocationServices];
    
    //Set the status bar to black color.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    //Change @"menubar.png" to the file name of your image.
    UIImage *navBar = [UIImage imageNamed:@"menubar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    // Change the appearance of other navigation button
    UIImage *barButtonImage = [[UIImage imageNamed:@"button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    // Change the appearance of back button
    UIImage *backButtonImage = [[UIImage imageNamed:@"backButtonSolid"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -100) forBarMetrics:UIBarMetricsDefault];
    
    UIImage* tabBarBackground = [UIImage imageNamed:@"tabBar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBarSelected1.png"]];
    
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    
    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"MapTabIcon_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"MapTabIcon.png"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"Compass_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Compass.png"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"MySushi_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"MySushi.png"]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:250/255.0 green:239/255.0 blue:207/255.0 alpha:1.0], UITextAttributeTextColor, [UIFont fontWithName:@"HiraKakuProN-W6" size:8.5], UITextAttributeFont,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = [UIColor colorWithRed:239/255.0 green:109/255.0 blue:34/255.0 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor, [UIFont fontWithName:@"HiraKakuProN-W6" size:8.5], UITextAttributeFont,
                                                       nil] forState:UIControlStateHighlighted];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor colorWithRed:239/255.0 green:109/255.0 blue:34/255.0 alpha:1.0],
                                     UITextAttributeFont: [UIFont fontWithName:@"HiraKakuProN-W3" size:20.0f]
     }];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor blackColor], UITextAttributeTextColor,
//      [UIFont fontWithName:@"HiraKakuProN-W3" size:8.0], UITextAttributeFont,
//      nil]
//                                             forState:UIControlStateHighlighted];
    
    return YES;
}


-(void) startStandardLocationServices
{
    //if you can't find a location -- then find one...
    if (nil == self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        
        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        [self.locationManager startUpdatingLocation];
        
        if([CLLocationManager headingAvailable]) {
            [self.locationManager startUpdatingHeading];
        } else {
            //NSLog(@"No Compass -- You're lost");
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    self.location = [locations objectAtIndex:0];
    
    CLLocation * startingUserLocation = [locations lastObject];
    //NSLog(@"this is from location manager: %f", startingUserLocation.coordinate.latitude);
    
    startingUserLocationFloatLat = startingUserLocation.coordinate.latitude;
    startingUserLocationFloatLong = startingUserLocation.coordinate.longitude;
    self.strLatitude = [NSString stringWithFormat: @"%f", startingUserLocation.coordinate.latitude];
    self.strLongitude = [NSString stringWithFormat: @"%f", startingUserLocation.coordinate.longitude];
    
    NSString *currentUserCoordForURL = [NSString stringWithFormat:@"%@,%@", self.strLatitude, self.strLongitude];
    
    if (didRunFourSquareParse == NO) {
        NSLog(@"starting the parse");
    self.fourSquareVenueObjectsArray = [[NSMutableArray alloc] init];

    //searches 4S for nearby sushi restaurants based on the current location
    NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&query=sushi&oauth_token=R0LICVP1OPDRVUGDTBAY4YQDCCRZKQ20BLR4SNG5XVKZ5T5M", currentUserCoordForURL];
    NSLog(@"The search URL is%@", urlString);
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue: [NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
     
     {
         NSDictionary *fourSquareInitialDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSDictionary * venueDictionary = [fourSquareInitialDictionary objectForKey:@"response"];
         NSArray *groupsArray = [venueDictionary objectForKey:@"groups"];
         NSDictionary *subgroupDictionary = [groupsArray objectAtIndex:0];
         fourSquareVenueResultsArray = [subgroupDictionary objectForKey:@"items"];
         
         for (listVenue in fourSquareVenueResultsArray)
         {
             fourSquareVenueObject = [[VenueObject alloc]init] ;
             fourSquareVenueObject.title = [listVenue objectForKey:@"name"];
             fourSquareVenueObject.fourSquareVenuePage = listVenue [@"canonicalUrl"];
             fourSquareVenueObject.venueLatitude = listVenue [@"location"][@"lat"];
             fourSquareVenueObject.venueLongitude = listVenue [@"location"][@"lng"];
             fourSquareVenueObject.coordinate = CLLocationCoordinate2DMake([fourSquareVenueObject.venueLatitude floatValue], [fourSquareVenueObject.venueLongitude floatValue]);
             fourSquareVenueObject.subtitle = listVenue [@"location"][@"address"];
//             if (listVenue [@"stats"][@"checkinsCount"] == nil || listVenue [@"stats"][@"checkinsCount"] == NULL)
//             {
//                 fourSquareVenueObject.subtitle = @"0";
//             } else {
//                 //NSString * subtitlecheckinPart = [listVenue[@"stats"][@"checkinsCount"] stringValue];
//                 fourSquareVenueObject.subtitle = fourSquareVenueObject.address;
//             }
             categoryArray = [listVenue objectForKey: @"categories"];
             if (categoryArray == nil || categoryArray == NULL || [categoryArray count] == 0)
             {
                 fourSquareVenueObject.venueCategory = @"Public Space";
             } else {
                 categoryInfo = [categoryArray objectAtIndex:0];
                 fourSquareVenueObject.venueCategory = [categoryInfo objectForKey:@"name"];
             }
             fourSquareVenueObject.distance = listVenue[@"location"][@"distance"];
             [self.fourSquareVenueObjectsArray addObject:fourSquareVenueObject];
         }
         //this method call the sortArray method which will sort the venue objects by distance
         [self sortVenuesByDistance];
         
     }];
        didRunFourSquareParse = YES;

    } else {NSLog(@"array already ran");};
} 





-(void) sortVenuesByDistance {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    distanceSortedArray = [[NSArray alloc] init];
    distanceSortedArray = [self.fourSquareVenueObjectsArray sortedArrayUsingDescriptors:sortDescriptors];
    self.closestVenue = [distanceSortedArray objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
   //NSLog(@"%@", distanceSortedArray);
    
   //NSLog(@"nearest venue: %@", [distanceSortedArray objectAtIndex:0]);

    //NSString * distanceFScheck = self.closestVenue.distance;
    
    NSLog(@"distance from foursquare is %@", self.closestVenue.distance);

}


-(void) reparseFourSquare
{
    
    NSString *currentUserCoordForURL = [NSString stringWithFormat:@"%@,%@", self.strLatitude, self.strLongitude];
    
   
        NSLog(@"starting the parse");
        self.fourSquareVenueObjectsArray = [[NSMutableArray alloc] init];
        
        //searches 4S for nearby sushi restaurants based on the current location
        NSString *urlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%@&query=sushi&oauth_token=R0LICVP1OPDRVUGDTBAY4YQDCCRZKQ20BLR4SNG5XVKZ5T5M", currentUserCoordForURL];
        NSLog(@"The search URL is%@", urlString);
        NSURL *url = [NSURL URLWithString: urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue: [NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
         
         {
             NSDictionary *fourSquareInitialDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSDictionary * venueDictionary = [fourSquareInitialDictionary objectForKey:@"response"];
             NSArray *groupsArray = [venueDictionary objectForKey:@"groups"];
             NSDictionary *subgroupDictionary = [groupsArray objectAtIndex:0];
             fourSquareVenueResultsArray = [subgroupDictionary objectForKey:@"items"];
             
             for (listVenue in fourSquareVenueResultsArray)
             {
                 fourSquareVenueObject = [[VenueObject alloc]init] ;
                 fourSquareVenueObject.title = [listVenue objectForKey:@"name"];
                 fourSquareVenueObject.fourSquareVenuePage = listVenue [@"canonicalUrl"];
                 fourSquareVenueObject.venueLatitude = listVenue [@"location"][@"lat"];
                 fourSquareVenueObject.venueLongitude = listVenue [@"location"][@"lng"];
                 fourSquareVenueObject.coordinate = CLLocationCoordinate2DMake([fourSquareVenueObject.venueLatitude floatValue], [fourSquareVenueObject.venueLongitude floatValue]);
                 fourSquareVenueObject.subtitle = listVenue [@"location"][@"address"];
                 //             if (listVenue [@"stats"][@"checkinsCount"] == nil || listVenue [@"stats"][@"checkinsCount"] == NULL)
                 //             {
                 //                 fourSquareVenueObject.subtitle = @"0";
                 //             } else {
                 //                 //NSString * subtitlecheckinPart = [listVenue[@"stats"][@"checkinsCount"] stringValue];
                 //                 fourSquareVenueObject.subtitle = fourSquareVenueObject.address;
                 //             }
                 categoryArray = [listVenue objectForKey: @"categories"];
                 if (categoryArray == nil || categoryArray == NULL || [categoryArray count] == 0)
                 {
                     fourSquareVenueObject.venueCategory = @"Public Space";
                 } else {
                     categoryInfo = [categoryArray objectAtIndex:0];
                     fourSquareVenueObject.venueCategory = [categoryInfo objectForKey:@"name"];
                 }
                 fourSquareVenueObject.distance = listVenue[@"location"][@"distance"];
                 [self.fourSquareVenueObjectsArray addObject:fourSquareVenueObject];
             }
             //this method call the sortArray method which will sort the venue objects by distance
             [self sortVenuesByDistance];
             
         }];
       

} 







- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
