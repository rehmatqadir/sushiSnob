//
//  AddVenueVC.m
//  SushiSnob
//
//  Created by Craig on 6/11/13.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AddVenueVC.h"


@interface AddVenueVC ()

@end

@implementation AddVenueVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma tableView dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return distanceSortedArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"localVenue";
    UITableViewCell* tableViewCell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    VenueObject *venueObject = [distanceSortedArray objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = venueObject.title;
    tableViewCell.detailTextLabel.text = venueObject.subtitle;
    return tableViewCell;
    
    
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat
{
    //tableViewCell.textLabel.text
   
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    VenueObject *selectedVenue = [distanceSortedArray objectAtIndex:indexPath.row];
    selectedSushiVenue = selectedVenue.title;
    sushiAddress = selectedVenue.subtitle;
    
    self.venueTextField.text = selectedSushiVenue;

    [self.venueDelegate updateVenueLabel:selectedSushiVenue address:sushiAddress];

    NSLog(@"the selected object is: %@", selectedSushiVenue);
 

    [self dismissViewControllerAnimated:YES completion:nil];


}



- (IBAction)addVenueWithButton:(id)sender {
    [self.venueDelegate updateVenueLabel:self.venueTextField.text address:sushiAddress];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//get rid of keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.venueTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
