//
//  gpaHeaderView.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-5-10.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "gpaHeaderView.h"

@implementation gpaHeaderView

@synthesize gpaText;
@synthesize gpaLabel;
@synthesize avgText;
@synthesize scoreLabel;
@synthesize termLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self = [[[NSBundle mainBundle]loadNibNamed:@"gpaHeaderView" owner:self options:nil] objectAtIndex:0];
        
        self.backgroundColor = [UIColor colorWithRed:255/255.0f green:85/255.0f blue:95/255.0f alpha:1.0f];
        
        gpaText = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width/2-10, 22)];
        gpaText.text = @"GPA";
        gpaText.textAlignment = NSTextAlignmentRight;
        
        avgText = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2+10, 60, self.frame.size.width/2-10, 22)];
        avgText.text = @"平均分";
        avgText.textAlignment = NSTextAlignmentLeft;
        
        gpaLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 86, self.frame.size.width/2-10, 56)];
        gpaLabel.textAlignment = NSTextAlignmentRight;
        gpaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:42];
        
        scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2+10, 86, self.frame.size.width/2-10, 56)];
        scoreLabel.textAlignment = NSTextAlignmentLeft;
        scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:42];
        
        termLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, self.frame.size.width, 30)];
        termLabel.textAlignment = NSTextAlignmentCenter;
        
        gpaText.textColor = [UIColor whiteColor];
        avgText.textColor = [UIColor whiteColor];
        gpaLabel.textColor = [UIColor whiteColor];
        scoreLabel.textColor = [UIColor whiteColor];
        termLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:gpaText];
        [self addSubview:avgText];
        [self addSubview:gpaLabel];
        [self addSubview:scoreLabel];
        [self addSubview:termLabel];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
