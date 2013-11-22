//
//  TabMySushiViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-06.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "TabMySushiViewController.h"
#import "LocationManagerSingleton.h"
#import "AddSushiCell.h"
#import "SushiCell.h"
#import "Sushi.h"
//to detail
#import "SushiDetailViewController.h"

@interface TabMySushiViewController ()
{
    //make global in order to toss over to SushiDetailViewController
    UIImage *sushiCellImage;
    SushiCell *sushiCellClass;
    int numberOfRowsInTableView;
}

@property (strong, nonatomic) NSOperationQueue *backgroundOperationQueue;

@end

@implementation TabMySushiViewController 

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addSushi"]) {
        
        ((AddSushiViewController*)segue.destinationViewController).addSushiDelegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"viewSushi"]) {

        SushiDetailViewController *sushiDetailViewController = [segue destinationViewController];
        Sushi *selectedSushiCell = [self.fetchedSushiResults objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        [sushiDetailViewController setSelectedSushi:selectedSushiCell];
    }
    
    if ([segue.identifier isEqualToString:@"sushiMap"]) {
        MySushiMapViewController *mySushiMapViewController = [segue destinationViewController];
        mySushiMapViewController.managedObjectContext = self.managedObjectContext;
        mySushiMapViewController.fetchedSushiResults = self.fetchedSushiResults;
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

-(void)viewDidAppear:(BOOL)animated
{
//    if (![self connected]) {
//        NSLog(@"shishit");
//        self.doneButton.enabled = NO;
//
//    }
//    else {
//        self.doneButton.enabled = YES;
//    }
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fileManager = [NSFileManager defaultManager];
    self.documentsDirectory = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    
//    [self createOriginalSushiEntries];
    
    [self setupFetchedResults];
    
    //sushiCellClass = [[SushiCell alloc] init];
}

-(void)setupFetchedResults
{
    self.imageArray = [[NSMutableArray alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Sushi" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    
    NSError *error;
    self.fetchedSushiResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.fetchedSushiResults.count == 0) {
        self.sushiArrow.alpha = 0.5;
    } else {
        self.sushiArrow.alpha = 0;
    }
    
    for (int i = 0; i < self.fetchedSushiResults.count; i++) {
        Sushi *sushiInfo = [self.fetchedSushiResults objectAtIndex:i];
        UIImage *image;
        
        NSString *fileName = sushiInfo.sushiImageURL;
        if ([fileName isEqualToString:@""]) {
            image = [UIImage imageNamed:@"sushi.jpeg"];
        } else {
            NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
            image = [UIImage imageWithContentsOfFile:[localImageURL path]];
        }
        //[self.imageArray addObject:image];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSourceMethods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sushiCell = @"sushiCell";
    //NSString *addSushiCellIdentifier = @"addSushiCell";
    
    if (indexPath.section == 0){
        
        SushiCell *cell = [tableView dequeueReusableCellWithIdentifier:sushiCell];
        
        if (cell == nil) {
            cell = [[SushiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sushiCell];
        }
        
        if (self.fetchedSushiResults != 0) {
            Sushi *sushiInfo = [self.fetchedSushiResults objectAtIndex:indexPath.row];
            cell.sushiName.text  = sushiInfo.name;
            cell.sushiRestauraunt.text = sushiInfo.venue;
            
            NSTimeInterval timeSinceSushiEntry = -[sushiInfo.date timeIntervalSinceNow];
            NSLog(@"%f",timeSinceSushiEntry);
            if (timeSinceSushiEntry < 86400 && timeSinceSushiEntry > 3600) {
                int hours = timeSinceSushiEntry/60/60;
                cell.sushiDate.text = [NSString stringWithFormat:@"%i hours ago", hours];
            }
            else if (timeSinceSushiEntry > 86400) {
                int days = timeSinceSushiEntry/60/60/24;
                cell.sushiDate.text = [NSString stringWithFormat:@"%i days ago ",days];
            }
            else if (timeSinceSushiEntry < 3600) {
                cell.sushiDate.text = @"added recently";
            }
            
            cell.sushiNameJapanese.text = sushiInfo.venue;
            NSLog(@"%@",sushiInfo.description);
            
            NSString *imageName = sushiInfo.sushiDescription;
            
            cell.sushiImageView.image = [UIImage imageNamed:imageName];
            
            //cell.sushiImageView.image = [self.imageArray objectAtIndex:indexPath.row];
        }
        
        return cell;
        
    }
    
    if (indexPath.section == 1){
        
//        AddSushiCell *cell = [tableView dequeueReusableCellWithIdentifier:addSushiCellIdentifier];
//        if (cell == nil) {
//            cell = [[AddSushiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addSushiCellIdentifier];
//        }

//        cell.textLabel.text = @"Add Sushi";
        
//        return cell;
    }
    return nil;
}

-(void)addPictureToCell: (SushiCell*)sushiCell
            atIndexPath:(NSIndexPath*)indexpath
{
    sushiCell.imageView.image = [self.imageArray objectAtIndex:indexpath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (![self connected]){
//        return 1;
//    } else {
//        return 2;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSLog(@"sections");
        numberOfRowsInTableView = section;
        NSLog(@"number of rows: %i",section);
        return self.fetchedSushiResults.count;
    } else {
        return 1;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        //[self.tableView beginUpdates];
        //self.fetchedSushiResults dele
        
        NSString *sushiName = ((Sushi*)([self.fetchedSushiResults objectAtIndex:indexPath.row])).sushiImageURL;
        NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:sushiName];
        [self.fileManager removeItemAtURL:localImageURL error:nil];
        
        [self.managedObjectContext deleteObject:[self.fetchedSushiResults objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"error");
            return;
        }
        
    //[self.fetchedSushiResults removeObjectAtIndex:indexPath.row];
    [self setupFetchedResults];
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)addSushiName:(NSString *)sushiName addSushiPicture:(UIImage *)sushiPicutre addSushiDate:(NSDate *)sushiDate addSushiGoodOrNot:(BOOL)sushiGoodOrNot addSushiVenue:(NSString *)sushiVenue addSushiDescription:(NSString *)sushiDescription addSushiAddress:(NSString *)sushiAddress addLatitude:(float)latitude addLongitude:(float)longitude
{
    
    //save coreData
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Sushi" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newSushi = [[NSManagedObject alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [newSushi setValue:sushiName forKey:@"name"];
    [newSushi setValue:sushiDate forKey:@"date"];
    [newSushi setValue:sushiVenue forKey:@"venue"];
    [newSushi setValue:sushiAddress forKey:@"address"];
    [newSushi setValue:[NSNumber numberWithBool:sushiGoodOrNot] forKey:@"isRatedGood"];
    [newSushi setValue:sushiDescription forKey:@"sushiDescription"];
    [newSushi setValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [newSushi setValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    
    //save image
    //NSString *sushiImageURLString = [sushiName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddmmssss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//    NSString *sushiImageURLString = [sushiName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSURL *sushiImageURL = [NSURL URLWithString:dateString];
    NSString *fileName = [sushiImageURL lastPathComponent];
    [newSushi setValue:fileName forKey:@"sushiImageURL"];
    NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
    NSData *imageData;
    imageData = UIImageJPEGRepresentation(sushiPicutre, 0.1);
    [imageData writeToURL:localImageURL atomically:YES];
    
    //save to core
    NSError *error;
    [self.managedObjectContext save:&error];
    [self setupFetchedResults];
   }

-(void)createOriginalSushiEntries
{
    
    //first entry
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Sushi" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newSushi = [[NSManagedObject alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
    [newSushi setValue:@"Spider Roll" forKey:@"name"];
    [newSushi setValue:[NSDate date] forKey:@"date"];
    [newSushi setValue:@"Union Sushi" forKey:@"venue"];
    [newSushi setValue:[NSNumber numberWithBool:0] forKey:@"isRatedGood"];
    [newSushi setValue:[NSNumber numberWithFloat:41.938846] forKey:@"latitude"];
    [newSushi setValue:[NSNumber numberWithFloat:-87.642625] forKey:@"longitude"];
    [newSushi setValue:@"chopsticksTV.png" forKey:@"sushiDescription"];
    
    //image
    NSString *sushiImageURLString = @"caliRoll";
    NSURL *sushiImageURL = [NSURL URLWithString:sushiImageURLString];
    NSString *fileName = [sushiImageURL lastPathComponent];
    [newSushi setValue:fileName forKey:@"sushiImageURL"];
    NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"californiaRollSmall.png"]);
    [imageData writeToURL:localImageURL atomically:YES];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    [self setupFetchedResults];
//    [self.tableView reloadData];
}
@end