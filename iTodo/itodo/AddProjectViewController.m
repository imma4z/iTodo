//
//  AddProjectViewController.m
//  itodo
//
//  Created by ramesh on 25/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "AddProjectViewController.h"
#import "ParseDataService.h"
#import "ListViewController.h"
#import "ParseCronService.h"

@interface AddProjectViewController ()

@end

@implementation AddProjectViewController
{
    NSMutableArray *allProjects;
}

@synthesize projectList;
@synthesize currentUser;
@synthesize myPickerView;

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
  //  self._currentUser=__currentUser;
    self.addTaskUnderProjectView.hidden=YES;
    self.priorityView.hidden=YES;

    NSUserDefaults *userCredentials=[NSUserDefaults standardUserDefaults];
    currentUser=[userCredentials objectForKey:@"username"];
   // self.currentUser =[ParseCronService getUserName];
    

    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    myPickerView.showsSelectionIndicator = YES;
  //  self.projectNameTextField.inputView = myPickerView;
    
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.date setInputView:datePicker];
    [self getProjectListFromParseDataService];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.date.inputView;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d LLL yyyy HH:mm"];
    NSTimeZone *local = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:local];
    self.date.text = [formatter stringFromDate:picker.date];
}


- (IBAction)save:(id)sender {
    NSLog(@"PFUser name is %@",currentUser);
    if(!(([self.task.text isEqual:@""])||([self.date.text isEqual:@""])||([self.priority.text isEqual:@""])||([self.projectNameTextField.text isEqual:@""])))
    {
        NSLog(@"user %@",currentUser);
    
    //Adding just project name to another table (ProjectList table)
        PFObject *addProject=[[PFObject alloc]initWithClassName:[NSString stringWithFormat:@"ProjectList%@",currentUser]];
        [PFQuery clearAllCachedResults];
        NSNumber  *aNum = [NSNumber numberWithInteger: [self.priority.text integerValue]];

        [addProject setObject:_projectNameTextField.text forKey:@"project"];
        [addProject setObject:_task.text forKey:@"task"];
        [addProject setObject:_date.text  forKey:@"date"];
        [addProject setObject:aNum forKey:@"priority"];
        
        [addProject save];
        
        
        //Adding task
        
        PFObject *add=[[PFObject alloc]initWithClassName:[NSString stringWithFormat:@"TaskList%@",currentUser]];
    [PFQuery clearAllCachedResults];
      
    
                [add setObject:_projectNameTextField.text forKey:@"project"];
                [add setObject:_task.text forKey:@"task"];
                [add setObject:_date.text  forKey:@"date"];
                [add setObject:aNum forKey:@"priority"];
                [add  save];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                ListViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
                iv.currentUser=self.currentUser;
    
            [self presentViewController:iv animated:YES completion:nil];
    
        
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Field(s) are missing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void)getProjectListFromParseDataService
{
    allProjects=[[NSMutableArray alloc]init];
    allProjects=[ParseDataService getProjectListFromParseService:currentUser];
    NSLog(@"Projects are:%@",allProjects);
    
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

- (IBAction)addProjectButton:(id)sender {
    if ([self.projectNameTextField.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please enter the project name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([allProjects containsObject:self.projectNameTextField.text]) {
        UIAlertView *view=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Project name already exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [view show];
    }
    
    else{
        PFObject *addProject=[[PFObject alloc]initWithClassName:[NSString stringWithFormat:@"ProjectList%@",currentUser]];
        [PFQuery clearAllCachedResults];
        
        [addProject setObject:_projectNameTextField.text forKey:@"project"];
        
        [addProject save];

        
    self.addTaskUnderProjectView.hidden=NO;
        self.CancelButtonVIew.hidden=YES;
    }
}


#pragma mark priority buttons
- (IBAction)viewPriority:(id)sender {
    self.priorityView.hidden=NO;
    self.priorityToggler.hidden=YES;
}
- (IBAction)priority1:(id)sender {
    self.priority.text=@"1";
    
    self.priorityView.hidden=YES;
    self.priorityToggler.hidden=NO;
    
}

- (IBAction)priority2:(id)sender {
    self.priority.text=@"2";
    self.priorityView.hidden=YES;
    self.priorityToggler.hidden=NO;
}
- (IBAction)priority3:(id)sender {
    self.priority.text=@"3";
    self.priorityView.hidden=YES;
    self.priorityToggler.hidden=NO;
}
- (IBAction)priority4:(id)sender {
    self.priority.text=@"4";
    self.priorityView.hidden=YES;
    self.priorityToggler.hidden=NO;
}

- (IBAction)priority5:(id)sender {
    self.priority.text=@"5";
    self.priorityView.hidden=YES;
    self.priorityToggler.hidden=NO;
}




@end
