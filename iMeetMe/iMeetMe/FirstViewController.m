//
//  FirstViewController.m
//  iMeetMe
//
//  Created by Eduard Feicho on 14.11.12.
//  Copyright (c) 2012 Eduard Feicho. All rights reserved.
//

#import "FirstViewController.h"
#import "Networking.h"
#import <Foundation/NSJSONSerialization.h>
#import "DisplayMap.h"

@interface FirstViewController ()

- (void)initLocationManager;
- (void)updateMapView;

@end

@implementation FirstViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    currentID = @"2";
    currentCoordinate = CLLocationCoordinate2DMake(50.77821, 6.060545);
//    currentLongitude = 6.060545;
//    currentLatitude = 50.77821;
    
    // setup core location manager
    [self initLocationManager];
    
    mapView.zoomEnabled = YES;
    mapView.scrollEnabled = YES;
    mapView.showsUserLocation = YES;
    
    
    [mapView setCenterCoordinate:currentCoordinate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)actionStatusSave:(id)sender;
{
    // create correct url
    statusLabel.text = @"Sending status...";
    
    
    // GET /position?latitude=...&longitude=...&status=...&id=...]
    NSDictionary* variables = [NSDictionary dictionaryWithObjectsAndKeys:
     [NSString stringWithFormat:@"%f",currentCoordinate.latitude], @"latitude",
     [NSString stringWithFormat:@"%f",currentCoordinate.longitude], @"longitude",
     statusMsg.text, @"status",
     currentID, @"id",
     [NSString stringWithFormat:@"%d", (int)[[NSDate date] timeIntervalSince1970]],@"timestamp",
     nil];
    
    Networking* request = [Networking createGetRequestTo:@"position" withVariables:variables];
    [request startAsyncRequestWithObject:self andCallback:@selector(actionStatusSaveDone:)];
    
}



- (IBAction)actionMapUpdate:(id)sender;
{
    mapLabel.text = @"Retrieving map data";
    
    NSDictionary* variables = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%f",currentCoordinate.latitude], @"latitude",
                               [NSString stringWithFormat:@"%f",currentCoordinate.longitude], @"longitude",
                               [NSString stringWithFormat:@"%f",5000.0], @"distance",
                               nil];
    
    Networking* request = [Networking createGetRequestTo:@"list" withVariables:variables];
    [request startAsyncRequestWithObject:self andCallback:@selector(actionMapUpdateDone:)];
    
}


// Callback for status update
- (void)actionStatusSaveDone:(NSData*)data;
{
    statusLabel.text = @"Status update complete";
}


// Callback for map list locations
- (void)actionMapUpdateDone:(NSData*)data;
{
    mapLabel.text = @"Map update complete";
    
    NSError* error = nil;
    NSDictionary *map_data = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        NSLog(@"[ERROR] Error retrieving map data: %@", [error localizedDescription]);
        mapLabel.text = @"Error retrieving map data";
        return;
    }
    
    NSArray* users = [map_data objectForKey:@"users"];
    NSEnumerator* e = [users objectEnumerator];
    NSDictionary* user;
    while (user = [e nextObject]) {
        
        NSString* user_id = [user objectForKey:@"id"];
        NSString* user_timestamp = [user objectForKey:@"timestamp"];
        NSString* user_latitude = [user objectForKey:@"latitude"];
        NSString* user_longitude = [user objectForKey:@"longitude"];
        NSString* user_status = [user objectForKey:@"status"];
        NSString* user_name = [user objectForKey:@"name"];
        
        NSLog(@"received user [%@,%@,%@,%@,%@,%@]", user_id, user_timestamp, user_latitude, user_longitude, user_status, user_name);
        
        
        DisplayMap* annotation = [[DisplayMap alloc] init];
        annotation.title = user_name;
        annotation.subtitle = user_status;
        annotation.coordinate = CLLocationCoordinate2DMake([user_latitude floatValue], [user_longitude floatValue]);
        [mapView addAnnotation:annotation];
    }
    
}


#pragma mark - Core Location Manager

- (void)initLocationManager;
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
{
    
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    currentCoordinate = newLocation.coordinate;
//    currentLongitude = newLocation.coordinate.longitude;
//    currentLatitude = newLocation.coordinate.latitude;
    
    longitudeLabel.text = [NSString stringWithFormat:@"Longitude: %f", currentCoordinate.longitude];
    latitudeLabel.text = [NSString stringWithFormat:@"Latitude: %f", currentCoordinate.latitude];
    
    [self updateMapView];
}


- (void)updateMapView;
{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCoordinate, 5000.0, 5000.0);
    
//    [mapView setCenterCoordinate:currentCoordinate];
//    [mapView setRegion:region];
    
}



@end
