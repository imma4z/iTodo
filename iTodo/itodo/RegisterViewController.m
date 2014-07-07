//
//  iViewController.m
//  Registration
//
//  Created by ramesh on 04/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "RegisterViewController.h"
#import "HomepageViewController.h"
#import "LoginViewController.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end

@implementation RegisterViewController






-(IBAction)register:(id)sender {
    if(!(([self.username.text isEqual:@""])||([self.password.text isEqual:@""])||([self.email.text isEqual:@""])))
    {
        NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
        
        if ([emailTest evaluateWithObject:self.email.text] == NO)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"enter the Valid Mail id" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
            [alert show];
        }
        else{
            PFUser *newuser=[PFUser user];
            newuser.username=self.username.text;
            newuser.password=self.password.text;
            newuser.email=self.email.text;
            [newuser signUpInBackgroundWithBlock:^(BOOL Succeeded, NSError *error){
                if(!error){
                    
                    NSUserDefaults *userCredentials=[NSUserDefaults standardUserDefaults];
                    [userCredentials setObject:self.username.text forKey:@"username"];
                    [userCredentials setObject:self.password.text forKey:@"password"];
                    [userCredentials synchronize];
                    NSLog(@"Success");
                    HomepageViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"HomepageViewController"];
                        iv.username1=self.username.text;
                    [self presentViewController:iv animated:YES completion:nil];
                }
                else{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Registration Failed" message:@"Username already exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
            
        }
    }
    
    else
    {
        
        UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Registration Failed" message:@"Please fill all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msg show];
        
    }
    
}

    
            /* LoginViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        iv.username=self.username.text;
        iv.password=self.password.text;
        iv.email=self.email.text;
        [self presentViewController:iv animated:YES completion:nil];*/
        
        
       /* UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Registration is Successfull" message:@"Now you can access the app " delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [msg show];*/
      //  [self performSegueWithIdentifier:@"newUser" sender:self];
           // HomepageViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"HomepageViewController"];
           // iv.username=self.username.text;
           // iv.password=self.password.text;
            //iv.email=self.email.text;
          //  [self presentViewController:iv animated:YES completion:nil];
        
 

-(void)load
{
    NSUserDefaults *load=[NSUserDefaults standardUserDefaults];
    LoginViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    iv.username=[load objectForKey:@"username"];
    iv.password=[load objectForKey:@"password"];
    iv.email=[load objectForKey:@"email"];
    
    
    
    
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.username becomeFirstResponder];
	// Do any additional setup after loading the view, typically from a nib.
    
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}   


@end
