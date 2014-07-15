//
//  YTrendChartView.h
//  GPAInfo
//
//  Created by yong.h on 13-10-5.
//  Copyright (c) 2013年 yong.h. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTermDelegate <NSObject>

- (void)selectTermForString:(NSString *)string;

@end

@interface YTrendChartView : UIView

@property (strong, nonatomic)NSArray *weightedScores;
@property (strong, nonatomic)NSArray *terms;
@property (strong, nonatomic) NSArray *termsInGraph;
@property (strong, nonatomic)NSMutableArray *globalRelativeScores;

@property (nonatomic)NSInteger selectedItem;
@property (nonatomic)BOOL isFirstLoaded;
@property (nonatomic)NSInteger widthSpace;
@property (nonatomic)NSInteger heightSpace;
@property (nonatomic)float highestScore;
@property (nonatomic)float lowestScore;

@property (assign, nonatomic) id<SelectTermDelegate> delegate;

@end
