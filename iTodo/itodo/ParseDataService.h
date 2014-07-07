//
//  ParseDataService.h
//  itodo
//
//  Created by ramesh on 23/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseDataService : NSObject
+(NSMutableArray *)getAlreadyLoadedTasks:(NSString *)currentUser;
+(NSMutableArray *)getTaskListFromParseService:(NSString *)currentUser;
 
+(NSMutableArray *)getProjectListFromParseService:(NSString *)currentUser;

+(NSMutableSet *)getTaskListFromParseService:(NSString *)currentUser withProject:(NSString *)project;
 

@end
