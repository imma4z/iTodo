//
//  ListViewController.h
//  itodo
//
//  Created by ramesh on 17/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *TableView;

@property (strong,nonatomic) NSMutableArray *list;
@property (strong,nonatomic) UITableView *myView;
- (IBAction)deleteTask:(id)sender;
-(void)clearData;
@property (strong, nonatomic) NSString *currentUser;
@property (strong, nonatomic) IBOutlet UIView *dropdownView;
- (IBAction)dropDownButton:(id)sender;
@end
