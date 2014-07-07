//
//  AddTaskViewController.m
//  itodo
//
//  Created by ramesh on 10/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "AddTaskViewController.h"
#import "ListViewController.h"
#import "ParseDataService.h"
#import "ParseCronService.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController
{
    NSArray *allProjects;
}
@synthesize objectId;
@synthesize myPickerView;
@synthesize priorities;
@synthesize currentUser;
@synthesize priorityView;
int count1=1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      // priorities = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.priorityView.hidden=YES;
    self.myPickerView.hidden=YES;
    
    [self getProjectListFromParseDataService];
    
  //  self.currentUser=[ParseCronService getUserName];
    self.currentUser=[[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSLog(@"Username is %@",currentUser);


    // Do any additional setup after loading the view.
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY MM d"];
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [myPickerView setDataSource: self];
    [myPickerView setDelegate: self];
    myPickerView.showsSelectionIndicator = YES;
    self.projectTextField.inputView = myPickerView;
    
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dateTextField.inputView;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d LLL yyyy HH:mm"];
    NSTimeZone *local = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:local];
    self.dateTextField.text = [formatter stringFromDate:picker.date];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ListViewController *addTask = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"addCancel"])
    addTask.currentUser=self.currentUser;
}*/


#pragma mark - pickerView dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [allProjects count];
}


#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [allProjects objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    NSString *num=[NSString stringWithFormat:@"%@",[allProjects objectAtIndex:row] ];
    self.projectTextField.text=num;
    NSLog(@"Chosen item: %@", [allProjects objectAtIndex:row]);
}





- (IBAction)save:(id)sender {
    
    if(!(([self.task.text isEqual:@""])||([self.dateTextField.text isEqual:@""])||([self.priority.text isEqual:@""])||([self.projectTextField.text isEqual:@""])))
    {
        
    PFObject *add=[[PFObject alloc]initWithClassName:[NSString stringWithFormat:@"TaskList%@",currentUser]];
    [PFQuery clearAllCachedResults];
    NSNumber  *aNum = [NSNumber numberWithInteger: [self.priority.text integerValue]];

    [add setObject:_task.text forKey:@"task"];
    [add setObject:_dateTextField.text  forKey:@"date"];
    [add setObject:aNum forKey:@"priority"];
    [add setObject:_projectTextField.text forKey:@"project"];
    [add  save];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
    ListViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    //iv.currentUser=self.currentUser;

    [self presentViewController:iv animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Some Field(s) are missing" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }


}




- (IBAction)cancel:(id)sender {
}


#pragma mark - priority buttons
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

#pragma mark - getting Project list
-(void)getProjectListFromParseDataService
{
     allProjects=[[NSMutableArray alloc]init];
   allProjects=[ParseDataService getProjectListFromParseService:currentUser];
    NSLog(@"Projects are:%@",allProjects);
   
}

  //  for (int i=0; i<[allProjects count]; i++) {

  //  }
    



@end
