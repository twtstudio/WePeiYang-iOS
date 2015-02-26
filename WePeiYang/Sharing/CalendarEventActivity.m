//
//  CalendarEventActivity.m
//  WePeiYang
//
//  Created by 秦昱博 on 15/2/11.
//  Copyright (c) 2015年 Qin Yubo. All rights reserved.
//

#import "CalendarEventActivity.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "MsgDisplay.h"

@implementation CalendarEventActivity {
    NSDictionary *dic;
}

- (NSString *)activityType {
    return NSStringFromClass([self class]);
}

- (NSString *)activityTitle {
    return NSLocalizedString(@"Save to Calendar", @"");
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:@"calendar.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];

    for (id item in activityItems) {
        if ([item isKindOfClass:[NSData class]] &&
            (status == EKAuthorizationStatusNotDetermined || status == EKAuthorizationStatusAuthorized)) {
            return YES;
        }
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id tmp in activityItems) {
        if ([tmp isKindOfClass:[NSData class]]) {
            dic = [(NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:tmp] copy];
        } else {
            continue;
        }
    }
}

- (void)performActivity {
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        if (error) {
            
            NSLog(@"%@", error.localizedDescription);
            
        } else if (granted) {
            
            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
            event.title = dic[@"title"];
            event.location = dic[@"place"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat: @"yyyy-MM-dd HH:mm"];
            NSString *dateTimeStr = [NSString stringWithFormat:@"%@ %@", dic[@"date"], dic[@"time"]];
            event.startDate = [formatter dateFromString:dateTimeStr];
            event.endDate = [[NSDate alloc]initWithTimeInterval:2*60*60 sinceDate:event.startDate];
            event.allDay = NO;
            
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
            
            [MsgDisplay showSuccessMsg:@"添加到日历成功"];
        } else {
            [MsgDisplay showErrorMsg:@"添加到日历失败\n用户未授权访问日历"];
        }
        
    }];
    
    [self activityDidFinish:YES];
}

@end
