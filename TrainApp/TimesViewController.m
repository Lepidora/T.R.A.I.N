//
//  TimesViewController.m
//  TrainApp
//
//  Created by Mia on 22/03/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

#import "TimesViewController.h"
#import "TimesCell.h"
#import "JSONParser.h"
#import "TrainTime.h"

@interface TimesViewController () {
    NSMutableArray *times;
}

@end

@implementation TimesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    times = [[NSMutableArray alloc] init];
    
    NSString *apiUrl = [NSString stringWithFormat:@"https://augustinas.me/api/schedule?crs=%@", _station.code];
    [self createTableData:apiUrl];
}

- (void)createTableData:(NSString *)url {
    
    [times removeAllObjects];
    
    @try {
        
        NSDictionary *jsonResults = [JSONParser getJSONFromURL:url];
        
        if (jsonResults[@"error"]) {
            
            TrainTime *trainTime = [[TrainTime alloc] init];
            trainTime.destination = @"This station has no data";
            trainTime.departure = @"";
            
            [times addObject:trainTime];
            
        } else {
            
            NSString *mainStation = jsonResults[@"name"];
            self.title = mainStation;
            
            NSArray *trains = jsonResults[@"trains"];
            
            for (NSDictionary *train in trains) {
                
                TrainTime *trainTime = [[TrainTime alloc] init];
                
                NSString *destination = train[@"destination"];
                NSString *departTime = train[@"departTime"];
                
                NSMutableString *formattedDepart = [NSMutableString stringWithString:departTime];
                [formattedDepart insertString:@":" atIndex:2];
                
                trainTime.destination = destination;
                trainTime.departure = formattedDepart;
                
                [times addObject:trainTime];
            }
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"Error loading data");
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return times.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimesCell" forIndexPath:indexPath];
    
    if (cell) {
        TrainTime *currentTime = times[indexPath.row];
        
        cell.destinationLabel.text = currentTime.destination;
        cell.timeLabel.text = currentTime.departure;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
