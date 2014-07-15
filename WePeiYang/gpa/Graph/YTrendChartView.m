//
//  YTrendChartView.m
//  GPAInfo
//
//  Created by yong.h on 13-10-5.
//  Copyright (c) 2013年 yong.h. All rights reserved.
//

#import "YTrendChartView.h"
#import "data.h"

@implementation YTrendChartView {
    NSString *selectedLastly;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.weightedScores = [data shareInstance].every;
        self.terms = [data shareInstance].term;
        self.termsInGraph = [data shareInstance].termsInGraph;
        
        self.selectedItem = [self.weightedScores count] - 1;
        //self.selectedItem = 0;
        self.isFirstLoaded = YES;
        self.highestScore = 0;
        self.lowestScore = 100;
        
        self.backgroundColor = [UIColor clearColor];
        selectedLastly = @"0";
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    NSInteger height = self.frame.size.height;
    NSInteger width = self.frame.size.width;
    //NSInteger heightSpace, widthSpace;
    
    //float highestScore = 0;
    //float lowestScore = 100;
    
    UIImage *pointSelected = [UIImage imageNamed:@"chart_selected"];
    UIImage *pointUnselected = [UIImage imageNamed:@"chart_unselected"];
    
    //获取最高成绩和最低成绩
    if ([self.weightedScores count] >= 1) {
        for (int i = 0; i < [self.weightedScores count]; i++) {
            
            if ([self.weightedScores[i] floatValue] > self.highestScore) {
                self.highestScore = [self.weightedScores[i] floatValue];
            }
            if ([self.weightedScores[i] floatValue] < self.lowestScore) {
                self.lowestScore = [self.weightedScores[i] floatValue];
            }
        }
    }
    
    //NSLog(@"%f %f", self.highestScore, self.lowestScore);
    
    float relativeScores[[self.weightedScores count]];
    
    //获取相对成绩
    for (int i = 0; i < [self.weightedScores count]; i++) {
        float temp = [self.weightedScores[i] floatValue] - self.lowestScore;
        relativeScores[i] = temp;
    }
    
    //设置各项长宽的比例
    if ([self.weightedScores count] > 1) {
        self.widthSpace = (NSInteger)(width - 80)/([self.weightedScores count] - 1);
    } else {
        self.widthSpace = width;
    }
    self.heightSpace = (NSInteger)((height - 40)/(self.highestScore - self.lowestScore));
    
    // 开始画图
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255 green:0 blue:0 alpha:0.33].CGColor);
    //CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5].CGColor);
    CGContextSetLineWidth(context, 5.0f);
    
    // 先画线
    for (int i = 0; i < [self.weightedScores count]; i++) {
        if (i != 0) {
            CGContextMoveToPoint(context, 40+self.widthSpace*(i-1), height-20-(relativeScores[i-1]*self.heightSpace));
            CGContextAddLineToPoint(context, 40+self.widthSpace*i, height-20-(relativeScores[i]*self.heightSpace));
            CGContextStrokePath(context);
        }
    }
    
    //第一个按钮的位置
    //float a = 50+self.widthSpace*0-pointSelected.size.width;
    //float b = height-40-relativeScores[0]*self.heightSpace-pointSelected.size.height/6;
    
    // 画节点、加权成绩、学期
    for (int i = 0; i < [self.weightedScores count]; i++) {
        
        if (i == self.selectedItem) {
            CGRect tempRect = CGRectMake(48+self.widthSpace*i-pointSelected.size.width, height-24-relativeScores[i]*self.heightSpace-pointSelected.size.height/6, pointSelected.size.width, pointSelected.size.height);
            CGContextDrawImage(context, tempRect, pointSelected.CGImage);
            CGContextStrokePath(context);
            NSString *selectedTerm = [self.terms objectAtIndex:i];
            if(![selectedTerm isEqualToString:selectedLastly]) [delegate selectTermForString:selectedTerm];
            selectedLastly = selectedTerm;
        } else {
            CGRect tempRect = CGRectMake(48+self.widthSpace*i-pointUnselected.size.width, height-24-relativeScores[i]*self.heightSpace-pointUnselected.size.height/6, pointUnselected.size.width, pointUnselected.size.height);
            CGContextDrawImage(context, tempRect, pointUnselected.CGImage);
            CGContextStrokePath(context);
        }
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        NSString *score = [NSString stringWithFormat:@"%.2f", [[self.weightedScores objectAtIndex:i] floatValue]];
        [score drawAtPoint:CGPointMake(38+self.widthSpace*i-pointUnselected.size.width, height-40-relativeScores[i]*self.heightSpace-pointUnselected.size.height/6) withFont:font];//绘制分数
        NSString *term = [NSString stringWithFormat:@"%@", [self.termsInGraph objectAtIndex:i]];
        [term drawAtPoint:CGPointMake(36+self.widthSpace*i-pointUnselected.size.width, height-11-relativeScores[i]*self.heightSpace-pointUnselected.size.height/6) withFont:font];//绘制学期
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    float relativeScores[[self.weightedScores count]];
    
    //获取相对成绩
    for (int i = 0; i < [self.weightedScores count]; i++) {
        float temp = [self.weightedScores[i] floatValue] - self.lowestScore;
        relativeScores[i] = temp;
    }
    
    for (int i = 0; i < [self.weightedScores count]; i++) {
        if (fabsf(point.x-(50+self.widthSpace*i)) <= 40 && fabsf(point.x-(50+self.widthSpace*i)) >= 0 && fabsf(point.y-(self.frame.size.height-40-relativeScores[i]*self.heightSpace)) <= 40 && fabsf(point.y-(self.frame.size.height-40-relativeScores[i]*self.heightSpace)) >= 0)
        {
            self.selectedItem = i;
        }
    }
    [self setNeedsDisplay];
}


@end
