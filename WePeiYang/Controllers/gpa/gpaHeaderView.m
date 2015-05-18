//
//  gpaHeaderView.m
//  WePeiYang
//
//  Created by Qin Yubo on 14-5-10.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import "gpaHeaderView.h"

@implementation gpaHeaderView

/*
@synthesize gpaText
@synthesize gpaLabel
@synthesize avgText
@synthesize scoreLabel
@synthesize termLabel
 */

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        //self = [[[NSBundle mainBundle]loadNibNamed:@"gpaHeaderView" owner:self options:nil] objectAtIndex:0];
        
        self.backgroundColor = [UIColor colorWithRed:255/255.0f green:85/255.0f blue:95/255.0f alpha:1.0f];
        
        _gpaText = [[UILabel alloc]init];
        _gpaText.text = @"GPA";
        _gpaText.textAlignment = NSTextAlignmentRight;
        _gpaText.translatesAutoresizingMaskIntoConstraints = NO;
        
        _avgText = [[UILabel alloc]init];
        _avgText.text = @"平均分";
        _avgText.textAlignment = NSTextAlignmentLeft;
        _avgText.translatesAutoresizingMaskIntoConstraints = NO;

        _gpaLabel = [[UILabel alloc]init];
        _gpaLabel.textAlignment = NSTextAlignmentRight;
        _gpaLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:42];
        _gpaLabel.translatesAutoresizingMaskIntoConstraints = NO;

        _scoreLabel = [[UILabel alloc]init];
        _scoreLabel.textAlignment = NSTextAlignmentLeft;
        _scoreLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:42];
        _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _termLabel = [[UILabel alloc]init];
        _termLabel.textAlignment = NSTextAlignmentCenter;
        _termLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        _gpaText.textColor = [UIColor whiteColor];
        _avgText.textColor = [UIColor whiteColor];
        _gpaLabel.textColor = [UIColor whiteColor];
        _scoreLabel.textColor = [UIColor whiteColor];
        _termLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:_gpaText];
        [self addSubview:_avgText];
        [self addSubview:_gpaLabel];
        [self addSubview:_scoreLabel];
        [self addSubview:_termLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_gpaText, _gpaLabel, _avgText, _scoreLabel, _termLabel);
        NSDictionary *metrics = @{@"borderDist": @16,
                                  @"innerDist": @20};
        NSArray *vfl = @[@"|-borderDist-[_termLabel]-borderDist-|",
                         @"|-borderDist-[_gpaText]-innerDist-[_avgText(_gpaText)]-borderDist-|",
                         @"|-borderDist-[_gpaLabel]-innerDist-[_scoreLabel(_gpaLabel)]-borderDist-|",
                         @"V:|-24-[_termLabel(==30)]",
                         @"V:|-60-[_gpaText(22)]-4-[_gpaLabel]-8-|",
                         @"V:|-60-[_avgText(22)]-4-[_scoreLabel]-8-|"];
        for (NSString *tmpVFL in vfl) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:tmpVFL options:0 metrics:metrics views:views]];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
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
