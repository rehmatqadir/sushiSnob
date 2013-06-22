//
//  SushiDetailFullPictureViewController.m
//  SushiSnob
//
//  Created by Andrew McCallum14 on 2013-06-16.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "SushiDetailFullPictureViewController.h"

@interface SushiDetailFullPictureViewController ()

@end

@implementation SushiDetailFullPictureViewController

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
    self.imageView.image = self.sushiImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
