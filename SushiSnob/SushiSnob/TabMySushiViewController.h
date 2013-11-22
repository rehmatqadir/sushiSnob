//
//  TabMySushiViewController.h
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AddSushiDelegate.h"
#import "AddSushiViewController.h"
#import "MySushiMapViewController.h"
#import <dispatch/dispatch.h>
#import "Reachability.h"

@interface TabMySushiViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AddSushiDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *fetchedSushiResults;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *sushiArrow;


//for writing pics to disk
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *documentsDirectory;
@property (strong, nonatomic) NSMutableArray *imageArray;

@end