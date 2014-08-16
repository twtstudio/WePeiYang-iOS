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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle]loadNibNamed:@"gpaHeaderView" owner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [UIColor colorWithRed:255/255.0f green:85/255.0f blue:95/255.0f alpha:1.0f];
        gpaLabel.textColor = [UIColor whiteColor];
        scoreLabel.textColor = [UIColor whiteColor];
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
