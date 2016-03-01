//
//  GPAAnalysisTableViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/17.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "GPAAnalysisTableViewController.h"
//#import "PNChart.h"
#import "GPAData.h"
#import "GPAClassData.h"
#import "Chameleon.h"
#import "Masonry.h"

@interface GPAAnalysisTableViewController ()

@end

@implementation GPAAnalysisTableViewController

@synthesize headerView;
@synthesize dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (dataArr.count > 0) {
        [self strokeChart];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)strokeChart {
    int gradeA = 0;
    int gradeB = 0;
    int gradeC = 0;
    int gradeD = 0;
    int gradeE = 0;
    int totalNum = 0;
    for (GPAData *data in dataArr) {
        for (GPAClassData *class in data.data) {
            totalNum ++;
            float score = [class.score floatValue];
            if (score >= 90) {
                gradeA ++;
            } else if (score >= 80) {
                gradeB ++;
            } else if (score >= 70) {
                gradeC ++;
            } else if (score >= 60) {
                gradeD ++;
            } else {
                gradeE ++;
            }
        }
    }
    
//    NSArray *items = @[
//                       [PNPieChartDataItem dataItemWithValue:gradeA color:[UIColor flatGreenColor] description:@"90~100"],
//                       [PNPieChartDataItem dataItemWithValue:gradeB color:[UIColor flatMagentaColor] description:@"80~90"],
//                       [PNPieChartDataItem dataItemWithValue:gradeC color:[UIColor flatSkyBlueColor] description:@"70~80"],
//                       [PNPieChartDataItem dataItemWithValue:gradeD color:[UIColor flatYellowColorDark] description:@"60~70"],
//                       [PNPieChartDataItem dataItemWithValue:gradeE color:[UIColor flatRedColor] description:@"0~60"]
//                       ];
//    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(24, 8, self.view.frame.size.width - 48, 360) items:items];
//    pieChart.descriptionTextColor = [UIColor whiteColor];
//    pieChart.descriptionTextFont = [UIFont systemFontOfSize:17.0];
//    [headerView addSubview:pieChart];
//    [pieChart strokeChart];
//    
//    pieChart.legendFont = [UIFont systemFontOfSize:14.0];
//    pieChart.legendStyle = PNLegendItemStyleStacked;
//    UIView *legend = [pieChart getLegendWithMaxWidth:200];
//    [legend setFrame:CGRectMake(24, 400, legend.frame.size.width, legend.frame.size.height)];
//    [headerView addSubview:legend];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
