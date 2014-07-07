//
//  ProjectListViewController.m
//  itodo
//
//  Created by ramesh on 27/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "ProjectListViewController.h"
#import "ParseDataService.h"
#import "TaskListViewController.h"
#import "ListViewController.h"

@interface ProjectListViewController ()

@end

@implementation ProjectListViewController{
    UIActivityIndicatorView *_spinner;
    NSInteger _selectedRow;
    NSMutableArray *_editStatusForRows;
    NSMutableArray *projectListArray;
    NSString * _selectedProjectName;
}
@synthesize currentUser;
@synthesize projectList;
@synthesize projectListSet;


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
    self.actionView.hidden=YES;
    
    [self.TableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    [self initializeDefaultEditValues];
    [self loadDataFromServer];
}

-(void)loadDataFromServer
{
    [_spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.projectList  =  [ParseDataService getProjectListFromParseService:currentUser];
       //         NSLog(@"list:%@",projectListSet);
     //   projectListArray=[[projectListSet allObjects]mutableCopy];

     //   NSLog(@"projs:%@",projectList[@"project"]);
      //  NSString *string=projectList[@"project"];
        [self initializeDefaultEditValues];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_spinner stopAnimating];
            [self.TableView reloadData];
        });
    });}

-(void)initializeDefaultEditValues
{
    NSInteger  count = self.projectList.count;
    _editStatusForRows = [[NSMutableArray alloc]initWithCapacity:self.projectList.count];
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




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.projectList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ]; //forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
    }
    // Configure the cell...
   // PFObject *listData=[projectListArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text=[self.projectList objectAtIndex:indexPath.row];
    
    
   // cell.textLabel.text=[listData objectAtIndex:indexPath.row];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor grayColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showTasksSegue"])
    {
        TaskListViewController *controller = (id)segue.destinationViewController;
        controller.userName = self.currentUser;
        controller.projectName = _selectedProjectName;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected RowIndex is:%ld",(long)indexPath.row);
    _selectedProjectName = [self.projectList objectAtIndex:indexPath.row];;
    NSLog(@"project name => %@", _selectedProjectName);
    [self performSegueWithIdentifier:@"showTasksSegue" sender:self];
//    _selectedRow = indexPath.row;
    
 
//    [ParseDataService getTaskListFromParseService:self.currentUser withProject:projectName];
//    
//    //    flag=indexPath.row;
//    //    if (flag==0) {
//    //        NSLog(@"in if block");
//    //        self.actionView.hidden=NO;
//    //        NSLog(@"after call");
//    //     }
//    //    if (flag!=0 && flag==flag1)
//    //    {
//    //        self.actionView.hidden=YES;
//    //    }
//    //    if (flag!=flag1) {
//    //        self.actionView.hidden=NO;
//    //    }
//    //
//    //    else{
//    //        self.actionView.hidden=YES;
//    //    }
//    //self.selectedRow=indexPath.row;
//    
//    //    self.actionView.hidden = !self.actionView.hidden;
//    
//    //for the first click, set the hide status to NO. for the next click, set its status to YES in array
//    bool actionViewHideStatus = [_editStatusForRows[indexPath.row] intValue];
//    if(actionViewHideStatus && actionViewHideStatus == YES){
//        _editStatusForRows[indexPath.row] = @NO;
//    }else{
//        _editStatusForRows[indexPath.row] = @YES;
//    }
//    
//    self.actionView.hidden = [_editStatusForRows[indexPath.row] intValue];
//    
//    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//    self.projectName = selectedCell.textLabel.text;
//    [self updateBackGroundColorOfStatus:tableView withIndexPath:indexPath];
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
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    else{
        cell.selectedBackgroundView.backgroundColor = [UIColor blueColor];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self.projectList objectAtIndex:indexPath.row];
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


- (IBAction)deleteTask:(id)sender {
    //    [self.TableView beginUpdates];
    [self.projectList removeObjectAtIndex: _selectedRow];

    PFQuery *query=[PFQuery queryWithClassName:[NSString stringWithFormat:@"TaskList%@",currentUser]];
    [query whereKey:@"project" equalTo:self.projectName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i=0; i<objects.count; i++) {
                [objects[i] deleteEventually];
                NSLog(@"object %@",objects[i]);
                
            }
            }
    }];

    [self viewDidAppear:YES];

    if(_selectedRow >= 0){
       // [self.projectList removeObjectAtIndex: _selectedRow];
        [self.TableView reloadData];
    }
    //    NSLog(@"task:%@",_objectID);
    //    [self.TableView endUpdates];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    
    //      [self loadDataFromServer];
}



/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"edit"])
    {
        EditTaskViewController *editTask = segue.destinationViewController;
        editTask.objectId=self.objectID;
        editTask.currentUser=self.currentUser;
        // UIAlertView *alert=[[UITableView alloc]initwith]
    }
    if ([segue.identifier isEqualToString:(@"addTask")]) {
        AddTaskViewController *at=segue.destinationViewController;
        at.currentUser=self.currentUser;
    }
    if ([segue.identifier isEqualToString:@"addProject"]) {
        AddProjectViewController *adprjct=segue.destinationViewController;
        adprjct.currentUser=self.currentUser;
        
    }
}*/



- (IBAction)refreshData:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshTable" object:self];
    
    [self.TableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    
    [self viewDidLoad];
    
    
}


- (IBAction)dropDownButton:(id)sender {
 //   self.dropdownView.hidden=NO;
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

- (IBAction)showTasksList:(id)sender {
    ListViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    [self presentViewController:iv animated:YES completion:nil];
}
@end
