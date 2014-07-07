//
//  ParseCronService.h
//  itodo
//
//  Created by Rajeev Kumar on 26/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseCronService : NSObject

+(void)setUserName:(NSString *)loggedInUserName;
+(void)startCronJobForTimeOutTasks;

+(NSString *)getUserName;
@end