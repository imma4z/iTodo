//
//  ListViewController.m
//  itodo
//
//  Created by ramesh on 17/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "ListViewController.h"
#import <Parse/Parse.h>
#import "AddTaskViewController.h"
#import "EditTaskViewController.h"
#import "ViewController.h"
#import "ParseDataService.h"
#import "AddProjectViewController.h"
#import "ParseCronService.h"


@interface ListViewController ()
@property (strong, nonatomic) IBOutlet UIView *actionView;
@property NSString *objectID;
//@property int selectedRow;

@end

@implementation ListViewController
{
    UIActivityIndicatorView *_spinner;
    NSInteger _selectedRow;
    NSMutableArray *_editStatusForRows;
    //Date objects
    NSMutableArray *today;
    NSMutableArray *tomorrow;
    NSMutableArray *nextSevenDays;
    NSDateFormatter* formatter;
}
@synthesize currentUser;
long flag=0;
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
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d LLL yyyy HH:mm"];
    
    NSUserDefaults *userCredentials=[NSUserDefaults standardUserDefaults];
    currentUser=[userCredentials objectForKey:@"username"];
    [self returnTasksBasedOnDates];

    
    [self.TableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];

    
    self.actionView.hidden=YES;
    self.dropdownView.hidden=YES;
    NSLog(@"User:%@",currentUser);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    _spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(160, 240) ;
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    [self returnTasksBasedOnDates];

  
    
    
    
//    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"TaskList%@",currentUser]];
//    [query clearCachedResult];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    
//            sleep(0.06);
//            self.list=[objects mutableCopy];
//            self.list = [ParseDataService getTaskListFromParseService:currentUser];
//            [self.TableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            //[query setLimit:1000];
            

//            [spinner stopAnimating];
         //   [self refreshData:nil];
            //[self performSelector:@selector(addTaskButtonPressed) withObject:nil afterDelay:2];
            
            self.TableView.scrollEnabled=YES;
         //   [self.TableView addSubview:self.actionView];
        }
//    }];

//}

-(void)viewWillAppear:(BOOL)animated
{
    [self initializeDefaultEditValues];
    [self loadDataFromServer];
}





#pragma mark- Getting data from the database(Parse)
-(void)loadDataFromServer
{
    [_spinner startAnimating];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"user in tasklist %@",currentUser);
        self.list  =  [ParseDataService getTaskListFromParseService:currentUser];
        [self initializeDefaultEditValues];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_spinner stopAnimating];
            [self.TableView reloadData];
        });
//    });
}

-(void)initializeDefaultEditValues
{
     NSInteger  count = self.list.count;
    _editStatusForRows = [[NSMutableArray alloc]initWithCapacity:self.list.count];
    for(NSInteger i  =0 ;i<count;i++){
        _editStatusForRows[i] = @YES;
    }
}

-(void)reloadTable
{
    NSLog(@"realoding table after receiving notification");
    [self.TableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- Sorting and storing tasks in an array based on dates to display in different sections

-(void)returnTasksBasedOnDates
{
     today=[[NSMutableArray alloc]init];
     tomorrow=[[NSMutableArray alloc]init];
     nextSevenDays=[[NSMutableArray alloc]init];
    NSDate *todaysDate=[NSDate date];
    NSDate *tomorrowsDate = [todaysDate dateByAddingTimeInterval: 86400.0];

    for(PFObject *day in self.list) {
        if (day[@"date"]==todaysDate) {
            [today addObject:day[@"date"]];
            NSLog(@"Date::::%@",day[@"date"]);

        }
        else if(day[@"date"]==tomorrowsDate){
            [tomorrow addObject:day];
        }
        else{
            [nextSevenDays addObject:day];
        }
    }


    

}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    /*[self returnTasksBasedOnDates];//calling date function method to sort sections

    if (section==0) {
        return [today count];
    }
    else if(section==1){
        return [tomorrow count];
}
    else{
        return [nextSevenDays count];
    }*/
    return [self.list count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *taskLength=nil;
    NSString *projectLength=nil;
    NSString *priorityBold=nil;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ]; //forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
        
        
    }
    // Configure the cell...
    cell.textLabel.textColor=[UIColor blackColor];
    cell.detailTextLabel.textColor=[UIColor grayColor];
    cell.detailTextLabel.font=[UIFont fontWithName:@"Arial" size:10];
    cell.detailTextLabel.textColor=[UIColor colorWithRed:14.0f/255.0f green:51.0f/255.0f blue:76.0f/255.0f alpha:1.0f];
    

    
    PFObject *listData=[self.list objectAtIndex:indexPath.row];
        taskLength=listData[@"task"];
        projectLength=listData[@"project"];
        priorityBold=listData[@"priority"];
    
    if (taskLength.length<=20) {
        cell.textLabel.text=taskLength;
        
    }
 
    else{
        cell.textLabel.text=[[taskLength substringToIndex:20]stringByAppendingString:@"..."];
    }
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
        }

    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@:%@",[projectLength uppercaseString],priorityBold ];

    
    UIView *bgColorView = [[UIView alloc] init];
  //  bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    UIView* timerView = (id)[cell viewWithTag:111];
    
    NSString* dateString = listData[@"date"];
    NSDate* date = [formatter dateFromString:dateString];
    if([date compare:[NSDate date]] == NSOrderedAscending) {
        timerView.hidden = NO;
    } else {
        timerView.hidden = YES;
    }
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected RowIndex is:%ld",(long)indexPath.row);
    _selectedRow = indexPath.row;
    
    //for the first click, set the hide status to NO. for the next click, set its status to YES in array
    bool actionViewHideStatus = [_editStatusForRows[indexPath.row] intValue];
    if(actionViewHideStatus && actionViewHideStatus == YES){
        _editStatusForRows[indexPath.row] = @NO;
    }else{
        _editStatusForRows[indexPath.row] = @YES;
    }
    
    self.actionView.hidden = [_editStatusForRows[indexPath.row] intValue];
    
    PFObject *edit=[self.list objectAtIndex:indexPath.row];
    
    self.objectID=edit.objectId;
//    NSLog(@"Object id:%@",_objectID);
    [self updateBackGroundColorOfStatus:tableView withIndexPath:indexPath];
    
//    flag1=flag;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _editStatusForRows[indexPath.row] = @YES;
    [self updateBackGroundColorOfStatus:tableView withIndexPath:indexPath];
}

-(void)updateBackGroundColorOfStatus:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([_editStatusForRows[indexPath.row] intValue] == 1){
        //cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    else{
       //cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    }
}

-(void)clearData
{
 //   [self.list removeAllObjects];
}


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Today", @"Today");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Tomorrow", @"Tomorrow");
            break;
            // ...
        default:
            sectionName = @"Next Seven Days";
            break;
    }
    return sectionName;
}
*/


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *edit=[self.list objectAtIndex:indexPath.row];
    NSString *ObjectID=edit.objectId;
    NSLog(@"ObjectID is:%@",ObjectID);
    PFQuery *query = [PFQuery queryWithClassName:@"TaskList"];
    //  [self EditTask:ObjectID];
    self.objectID=ObjectID;
    // Retrieve the object by id
    
    
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self.list objectAtIndex:indexPath.row];
        [object delete];
        [object saveInBackground];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
        [self viewDidLoad];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.TableView reloadData];
    //[self.list removeAllObjects];
}
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)deleteTask:(id)sender {
//    [self.TableView beginUpdates];
    PFObject *object = [PFObject objectWithoutDataWithClassName:[NSString stringWithFormat:@"TaskList%@",currentUser]
                                                       objectId:_objectID];
    [object deleteEventually];

    if(_selectedRow >= 0){
        [self.list removeObjectAtIndex: _selectedRow];
        [self.TableView reloadData];
    }
    self.actionView.hidden=YES;
//    NSLog(@"task:%@",_objectID);
//    [self.TableView endUpdates];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];

//      [self loadDataFromServer];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"edit"])
    {
        EditTaskViewController *editTask = segue.destinationViewController;
        editTask.objectId=self.objectID;
        editTask.currentUser=self.currentUser;
       // UIAlertView *alert=[[UITableView alloc]initwith]
    }else
    if ([segue.identifier isEqualToString:(@"addTask")]) {
        AddTaskViewController *at=segue.destinationViewController;
        at.currentUser=self.currentUser;
    }else
    if ([segue.identifier isEqualToString:@"addProject"]) {
        AddProjectViewController *adprjct=segue.destinationViewController;
        adprjct.currentUser=self.currentUser;
    }
}



- (IBAction)refreshData:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTable" object:self];
    
    [self.TableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    
    [self viewDidLoad];
}


- (IBAction)dropDownButton:(id)sender {
    if (flag%2==0) {
        self.dropdownView.hidden=NO;
    }
    else{
        self.dropdownView.hidden=YES;
    }
    flag++;
}



- (IBAction)Logout:(id)sender {
    [PFUser logOut];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
    
    [ParseCronService setUserName:nil];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    
    ViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    //iv.currentUser=self.currentUser;
    
    [self presentViewController:iv animated:YES completion:nil];
    
    
}
@end
