//
//  AppDelegate.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

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
    
    return YES;
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
