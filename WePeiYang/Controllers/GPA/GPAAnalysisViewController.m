//
//  GPAAnalysisViewController.m
//  WePeiYang
//
//  Created by Qin Yubo on 15/11/16.
//  Copyright © 2015年 Qin Yubo. All rights reserved.
//

#import "GPAAnalysisViewController.h"
#import "PNChart.h"
#import "GPAData.h"
#import "GPAClassData.h"
#import "Chameleon.h"

@interface GPAAnalysisViewController ()

@end

@implementation GPAAnalysisViewController

@synthesize dataArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (dataArr.count > 0) {
        [self strokeChart];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

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
    
    NSArray *items = @[
                       [PNPieChartDataItem dataItemWithValue:gradeA color:[UIColor flatGreenColor] description:@"90~100"],
                       [PNPieChartDataItem dataItemWithValue:gradeB color:[UIColor flatMagentaColor] description:@"80~90"],
                       [PNPieChartDataItem dataItemWithValue:gradeC color:[UIColor flatSkyBlueColor] description:@"70~80"],
                       [PNPieChartDataItem dataItemWithValue:gradeD color:[UIColor flatYellowColorDark] description:@"60~70"],
                       [PNPieChartDataItem dataItemWithValue:gradeE color:[UIColor flatRedColor] description:@"0~60"]
                       ];
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(24, 76, self.view.frame.size.width - 48, 360) items:items];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont systemFontOfSize:17.0];
    [self.view addSubview:pieChart];
    [pieChart strokeChart];
    
    pieChart.legendFont = [UIFont systemFontOfSize:14.0];
    pieChart.legendStyle = PNLegendItemStyleStacked;
    UIView *legend = [pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(24, 460, legend.frame.size.width, legend.frame.size.height)];
    [self.view addSubview:legend];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
