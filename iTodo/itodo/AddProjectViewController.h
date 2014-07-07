//
//  AddProjectViewController.h
//  itodo
//
//  Created by ramesh on 25/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddProjectViewController : UIViewController
@property (strong,nonatomic) NSString *currentUser;
@property (strong, nonatomic) NSMutableArray *projectList;
@property (strong, nonatomic) IBOutlet UILabel *projectNameTextField;
- (IBAction)addProjectButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *addTaskUnderProjectView;
@property (strong, nonatomic) IBOutlet UITextField *task;
@property (strong, nonatomic) IBOutlet UITextField *date;
@property (strong, nonatomic) IBOutlet UITextField *priority;
@property (strong, nonatomic) IBOutlet UIButton *addTaskButton;
@property (strong, nonatomic) IBOutlet UIView *CancelButtonVIew;
@property (strong, nonatomic) IBOutlet  UIPickerView *myPickerView;
@property (strong, nonatomic) IBOutlet UIView *priorityView;
@property (strong, nonatomic) IBOutlet UIView *priorityToggler;

@end
