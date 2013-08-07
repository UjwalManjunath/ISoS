//
//  SoSEmergencyVC.m
//  ISoS
//
//  Created by Ujwal Manjunath on 8/7/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "SoSEmergencyVC.h"

@interface SoSEmergencyVC ()
@property (weak, nonatomic) IBOutlet UIImageView *crimeImage;  //using it to just transform the image

@end

@implementation SoSEmergencyVC

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
    self.crimeImage.transform = CGAffineTransformMakeRotation(M_PI/4);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
