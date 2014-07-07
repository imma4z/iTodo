//
//  TaskListViewController.m
//  itodo
//
//  Created by Rajeev Kumar on 02/07/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "TaskListViewController.h"
#import "ParseDataService.h"
#import "ParseCronService.h"

@interface TaskListViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TaskListViewController
{
    NSArray * _tasks;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userCredentials=[NSUserDefaults standardUserDefaults];
    self.currentUser=[userCredentials objectForKey:@"username"];
    NSLog(@"user in TaskListVIewcontorller:%@",self.userName);
    NSMutableSet *tasksSet  = [ParseDataService getTaskListFromParseService:self.currentUser withProject:self.projectName];
    NSLog(@"tasks in PtaslList %@",tasksSet);

    _tasks = [tasksSet allObjects];
    NSLog(@"tasks in PtaslList %@",_tasks);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
   /* PFObject *listData=[_tasks objectAtIndex:indexPath.row];
    NSLog(@"priority:::%@",listData[@"priority"]);
    if ([listData[@"priority"] isEqualToValue:@1]) {
        
        cell.backgroundColor=[UIColor colorWithRed:223.0f/255.0f green:33.0f/255.0f blue:37.0f/255.0f alpha:1.0f];
    }
    else if([listData[@"priority"] isEqualToValue:@2])
    {
        cell.backgroundColor=[UIColor colorWithRed:240.0f/255.0f green:105.0f/255.0f blue:55.0f/255.0f alpha:1.0f];
    }
    else if ([listData[@"priority"] isEqualToValue:@3]){
        
        cell.backgroundColor=[UIColor colorWithRed:245.0f/255.0f green:159.0f/255.0f blue:22.0f/255.0f alpha:1.0f];
    }
    else if ([listData[@"priority"] isEqualToValue:@4]){
        cell.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:200.0f/255.0f blue:81.0f/255.0f alpha:1.0f];
    }
    else{
        cell.backgroundColor=[UIColor colorWithRed:137.0f/255.0f green:166.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
    }*/

 /*   //configuring the cells
    [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.frame = CGRectMake(15,15,50,300);
    [cell.textLabel sizeToFit];
   */
    
    

    UILabel *taskNameLabel = (id)[cell viewWithTag:100];
    [taskNameLabel setNumberOfLines:0];
    taskNameLabel.lineBreakMode=UILineBreakModeWordWrap;
    [taskNameLabel sizeToFit];
    taskNameLabel.text = _tasks[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
