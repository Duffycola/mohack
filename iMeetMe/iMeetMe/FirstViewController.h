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



@interface FirstViewController : UIViewController<CLLocationManagerDelegate>
{
    IBOutlet UITextField* statusMsg;
    IBOutlet UILabel* statusLabel;
    IBOutlet UILabel* mapLabel;
    IBOutlet MKMapView* mapView;
    IBOutlet UIButton* buttonStatusSave;
    IBOutlet UIButton* buttonMapUpdate;
    
    IBOutlet UILabel* longitudeLabel;
    IBOutlet UILabel* latitudeLabel;
    
    NSString* currentID;
    
    CLLocationCoordinate2D currentCoordinate;
    
    //float currentLongitude;
    //float currentLatitude;
    
    CLLocationManager *locationManager;
}



-(IBAction)actionStatusSave:(id)sender;
-(IBAction)actionMapUpdate:(id)sender;


- (void)initLocationManager;


@end
