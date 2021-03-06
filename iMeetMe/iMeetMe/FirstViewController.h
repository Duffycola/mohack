//
//  FirstViewController.h
//  iMeetMe
//
//  Created by Eduard Feicho on 14.11.12.
//  Copyright (c) 2012 Eduard Feicho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>



@interface FirstViewController : UIViewController<CLLocationManagerDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField* statusMsg;
    IBOutlet UILabel* statusLabel;
    IBOutlet UILabel* mapLabel;
    IBOutlet MKMapView* mapView;
    IBOutlet UIButton* buttonStatusSave;
    IBOutlet UIButton* buttonMapUpdate;
    
    IBOutlet UILabel* longitudeLabel;
    IBOutlet UILabel* latitudeLabel;
    IBOutlet UIButton* satelliteButton;
    
    NSString* currentID;
    
    CLLocationCoordinate2D currentCoordinate;
    
    //float currentLongitude;
    //float currentLatitude;
    
    CLLocationManager *locationManager;
    
    NSMutableArray* annotations;
    
    NSTimer* update_timer;
}



-(IBAction)actionStatusSave:(id)sender;
-(IBAction)actionMapUpdate:(id)sender;
-(IBAction)changeMapType:(id)sender;

- (void)initLocationManager;


@end
