//
//  ProjectListViewController.h
//  itodo
//
//  Created by ramesh on 27/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSString *currentUser;
@property (strong,nonatomic) NSMutableArray *projectList;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong,nonatomic) NSString *objectID;
@property(strong, nonatomic) NSMutableSet *projectListSet;
@property (strong,nonatomic) NSString *projectName;
@property (strong, nonatomic) IBOutlet UIView *actionView;

- (IBAction)showTasksList:(id)sender;

@end
