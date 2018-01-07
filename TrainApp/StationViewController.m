//
//  StationViewController.m
//  TrainApp
//
//  Created by Mia on 22/03/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

#import "StationViewController.h"
#import "StationCell.h"
#import "JSONParser.h"
#import "StationData.h"
#import "TimesViewController.h"

@interface StationViewController () {
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;

    NSMutableArray *stations;
}

@end

@implementation StationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"Stations";

    stations = [[NSMutableArray alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    NSLog(@"%d",[CLLocationManager authorizationStatus]);
    
    [locationManager startUpdatingLocation];
    
    NSLog(@"Starting");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getStationData:(CLLocationDegrees) latitude longitude:(CLLocationDegrees) longitude {
    
    //Original URL: https://data.gov.uk/data/api/service/transport/naptan_railway_stations/nearest?lat=%f&lon=%f
    NSString *apiCallUrl = [NSString stringWithFormat:@"https://augustinas.me/api/nearest?lat=%f&lon=%f&size=30", latitude, longitude];
    
    [self createTableData:apiCallUrl];
}

- (void)createTableData:(NSString *)url {
    
    [stations removeAllObjects];
    
    @try {
        NSArray *results = (NSArray *)[JSONParser getJSONFromURL:url];
        
        for (NSDictionary *station in results) {
            
            StationData *currentStation = [[StationData alloc] init];
            
            CLLocationDegrees longitude = [station[@"lon"] doubleValue];
            CLLocationDegrees latitude = [station[@"lat"] doubleValue];
            
            NSLog(@"%.2f %.2f", latitude, longitude);
            
            CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            CLLocationDistance distance = [currentLocation distanceFromLocation:stationLocation];
            
            NSString *stationName = station[@"name"];
            NSString *stationCode = station[@"crscode"];
            
            currentStation.stationName = stationName;
            currentStation.code = stationCode;
            currentStation.stationDistance = distance;
            
            [stations addObject:currentStation];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Error loading data");
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return stations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StationCell" forIndexPath:indexPath];
    
    if (cell != nil) {
        
        StationData *currentStation = stations[indexPath.row];
        
        cell.stationName.text = currentStation.stationName;
        cell.stationDistance.text = [NSString stringWithFormat:@"%.fm", currentStation.stationDistance];
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    TimesViewController *viewController = [segue destinationViewController];
    StationData *station = stations[indexPath.row];
    viewController.station = station;
}

#pragma mark - Some Location Stuff

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *current = locations[0];
    
    if (current != nil) {
        currentLocation = current;
        [locationManager stopUpdatingLocation];
        [self getStationData:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *current = newLocation;
    
    if (current != nil) {
        currentLocation = current;
        [locationManager stopUpdatingLocation];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            
            [self getStationData:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
            
        }];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed to get location");
}


@end
