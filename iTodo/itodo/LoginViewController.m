//
//  iValidationViewController.m
//  Registration
//
//  Created by ramesh on 04/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "HomepageViewController.h"
#import "ListViewController.h"
#import "ParseDataService.h"
#import "ParseCronService.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController


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
    [self.userTextField becomeFirstResponder];
    // Do any additional setup after loading the view
    
    
    
}

/*-(IBAction)display{
    RegisterViewController *vc=[[RegisterViewController alloc]init];
    [vc load];
    self.uname.text=username;
    self.pswd.text=password;
    
    
}*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.userTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self login:self];
    }
    return NO;
}

- (IBAction)login:(id)sender {
    
   // self.userTextField.text = @"h";
    //self.passwordTextField.text = @"h";
    //comment the above hard coded credentials
    
    [ParseCronService setUserName:nil];
    self.loginButton.enabled = NO;
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if(user != nil && error == nil) {
            NSUserDefaults *userCredentials=[NSUserDefaults standardUserDefaults];
            [userCredentials setObject:self.userTextField.text forKey:@"username"];
            [userCredentials setObject:self.passwordTextField.text forKey:@"password"];
            [userCredentials synchronize];
            
            //set user name in cron service
            [ParseCronService setUserName:self.userTextField.text];
            
            //After successful login, set up the cron to run regularly to alert user with timeout todo tasks
            [ParseCronService startCronJobForTimeOutTasks];
            
            ListViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
            [ParseDataService getTaskListFromParseService: self.userTextField.text];
            // iv.currentUser=self.userTextField.text;
            [self presentViewController:iv animated:YES completion:nil];
            
        } else {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Invalid Username or Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            self.loginButton.enabled = YES;
        }
    }];
    
    
//    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error){
//        if (!error)
//        {
//            NSUserDefaults *userCredentials=[NSUserDefaults standardUserDefaults];
//            [userCredentials setObject:self.userTextField.text forKey:@"username"];
//            [userCredentials setObject:self.passwordTextField.text forKey:@"password"];
//            [userCredentials synchronize];
//            ListViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
//            [ParseDataService getTaskListFromParseService: self.userTextField.text];
//           // iv.currentUser=self.userTextField.text;
//            [self presentViewController:iv animated:YES completion:nil];
//            
//            //set user name in cron service
//            [ParseCronService setUserName:self.userTextField.text];
//            
//            //After successful login, set up the cron to run regularly to alert user with timeout todo tasks
//            [ParseCronService startCronJobForTimeOutTasks];
//        }
//        else{
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Login Failed" message:@"Invalid Username or Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//        }

        
//    }];

}

    


    
    

    


-(void)move{
    HomepageViewController *ih=[self.storyboard instantiateViewControllerWithIdentifier:@"HomepageViewController"];
  //   ih.username1=username;
    
    [self presentViewController:ih animated:YES completion:nil];
    
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
