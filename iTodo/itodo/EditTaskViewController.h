//
//  EditTaskViewController.h
//  itodo
//
//  Created by ramesh on 17/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTaskViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *task;
@property (strong, nonatomic) IBOutlet UITextField *priority;
@property (nonatomic,strong) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *projectTextField;

@property NSString *objectId;
- (IBAction)cancel:(id)sender;
- (IBAction)EditTask:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *saveView;
@property (strong, nonatomic) IBOutlet UIPickerView *myPickerView;
@property (strong, nonatomic) NSArray *priorities;
@property (strong, nonatomic) NSString *currentUser;

@property (strong, nonatomic) IBOutlet UIView *priorityVIew;
@property (strong, nonatomic) IBOutlet UIView *priorityToggler;

@end
