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

@property(nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,strong) CLGeocoder *geocoder;

@property(nonatomic,strong) CLPlacemark *placemark;

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
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //NSDictionary *contact = [def objectForKey:@"Contacts"];
    NSLog(@"%@",[def objectForKey:@"Contacts"]);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"emergency message" message:@"message sending failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
            break;
            
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        NSLog(@" Longitude: %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"Latitude: %@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    }
    
 //   [self.locationManager stopUpdatingLocation];
    
    NSLog(@"Resolving the Address");
    self.geocoder = [[CLGeocoder alloc]init];
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && [placemarks count]>0){
            self.placemark = [placemarks lastObject];
            NSLog(@"Address : %@ %@ \n %@ %@ \n %@ \n %@",self.placemark.subThoroughfare,self.placemark.thoroughfare,self.placemark.postalCode,self.placemark.locality
                  ,self.placemark.administrativeArea,self.placemark.country);
        }
        else {
            NSLog(@"%@", error.debugDescription);
        }
    }];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate =self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone ;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [self.locationManager startMonitoringSignificantLocationChanges];
    NSLog(@"locationManager started updating location");
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}




@end
