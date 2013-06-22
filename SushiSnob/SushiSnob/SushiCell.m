//
//  SushiCell.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-06.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "SushiCell.h"
#import "TabMySushiViewController.h"

@implementation SushiCell
{
    TabMySushiViewController *tabMySushiViewController;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)addPicture:(Sushi*)sushi
atIndexPath:(NSIndexPath*)indexPath
{
//    NSLog(@"sushicell");
//    NSString *fileName = sushi.sushiImageURL;
//    NSURL *localImageURL = [documentsDirectory URLByAppendingPathComponent:fileName];
//    UIImage *cellImage = [UIImage imageWithContentsOfFile:[localImageURL path]];
    
//    self.sushiImageView.image = [tabMySushiViewController.imageArray objectAtIndex:indexPath.row];
    
//    NSBlockOperation *mainQueueOperation = [NSBlockOperation blockOperationWithBlock:^{
//        NSString *fileName = sushi.sushiImageURL;
//        NSURL *localImageURL = [documentsDirectory URLByAppendingPathComponent:fileName];
//        UIImage *cellImage = [UIImage imageWithContentsOfFile:[localImageURL path]];
//        self.sushiImageView.image = cellImage;
//    }];
//    
//    [[NSOperationQueue mainQueue] addOperation:mainQueueOperation];
    
    //[[NSOperationQueue mainQueue] addOperation:mainQueueOperation];
    //}];
    
    //[self.backgroundOperationQueue addOperation:imageBlockOperation];
}



@end
