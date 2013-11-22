//
//  MySushiMapPictureViewController.m
//  SushiSnob
//
//  Created by MasterRyuX on 2013-06-11.
//  Copyright (c) 2013 MasterRyuX. All rights reserved.
//

#import "MySushiMapPictureViewController.h"

@interface MySushiMapPictureViewController ()

@end

@implementation MySushiMapPictureViewController

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
    NSLog(@"%@",self.fileName);
    
    self.fileManager = [NSFileManager defaultManager];
    self.documentsDirectory = [self.fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL *localImageURL = [self.documentsDirectory URLByAppendingPathComponent:self.fileName];
    self.imageView.image = [UIImage imageWithContentsOfFile:localImageURL.path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
