//
//  ParseCronService.m
//  itodo
//
//  Created by Rajeev Kumar on 26/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "ParseCronService.h"
#import "ParseDataService.h"
#import "AppDelegate.h"

@implementation ParseCronService

static NSString *_currentUserName;
static NSString* dateFormatPattern = @"d LLL yyyy HH:mm";
static NSDateFormatter *dateFormatter;

+(void)setUserName:(NSString *)loggedInUserName
{
   // _currentUserName = loggedInUserName;
    _currentUserName = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];

}

+(NSString *)getUserName
{
    return _currentUserName;
}

static dispatch_once_t once;

+(void)startCronJobForTimeOutTasks
{
    dispatch_once(&once, ^{
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lookForTimeOutTasks) userInfo:nil repeats:YES];
    });
}

+(NSDate *)getCurrentDate
{
    NSDate *currentDate  = [NSDate date];
    return currentDate;
}

+(void)lookForTimeOutTasks
{
    NSLog(@"checking tasks for timeout ones");
    
    if(dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:dateFormatPattern];
    }
    
    NSArray *taskList;
    if(_currentUserName != nil){
        taskList = [ParseDataService getAlreadyLoadedTasks:_currentUserName];
    }
    
    NSInteger notificationCount = 0;
    if(taskList && taskList.count >0){
        for(NSInteger i =0 ;i< taskList.count;i++){
            PFObject *listData = taskList[i];
            NSString *dateString = listData[@"date"];
            
            if(dateString && dateString.length > 0){
                NSDate *dateObject = [dateFormatter dateFromString:dateString];
                NSDate *currentDate = [self getCurrentDate];
                NSMutableAttributedString *tempTask=[[NSMutableAttributedString alloc] initWithString:listData[@"task"]];
                NSString *task=[tempTask string];

                if([dateObject compare:currentDate] ==  NSOrderedAscending){
                    NSLog(@"this one is expired time => date => %@", dateObject);
                    [self showNotificationMessage:listData[@"project"] withPriority:listData[@"priority"] andTask:task];
                    notificationCount ++;
                }
            }
        }
    }
    [self setNotificationOnAppIcon:notificationCount];
}

+(void)showNotificationMessage:(NSString *)taskName withPriority:(NSString *)priority andTask:(NSString *)task
{
    //    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    //        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    //        {
    //            UILocalNotification *notification = [[UILocalNotification alloc] init];
    //            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    //            notification.alertAction = @"click to see the tasks";
    //            notification.alertBody =[NSString stringWithFormat:@"taskName => %@  with priority => %@", taskName, priority];
    //            notification.timeZone = [NSTimeZone systemTimeZone];
    //            notification.soundName = UILocalNotificationDefaultSoundName;
    //            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //        }
    
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:2];
    
    //    NSLog(@"now time: %@", now);
    //    NSLog(@"fire time: %@", dateToFire);
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = [NSString stringWithFormat:@"%@\n%@ %@" , taskName,task, priority];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //    localNotification.applicationIconBadgeNumber = 1; // increment
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:taskName, @"priority", nil];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+(void)setNotificationOnAppIcon:(NSInteger)notificationCount
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = notificationCount;
}

@end