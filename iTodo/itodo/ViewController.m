//
//  ViewController.m
//  itodo
//
//  Created by ramesh on 06/06/14.
//  Copyright (c) 2014 xenovus. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "ListViewController.h"


@interface ViewController ()
#define GoogleClientID    @"paster your client id"
#define GoogleClientSecret @"paste your client secret"
#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
 /*   PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        ListViewController *iv=[self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
        iv.currentUser=currentUser.username;
        [self presentViewController:iv animated:YES completion:nil];
    }
    else {*/
        // show the signup or login screen
    

    // Do any additional setup after loading the view.
    UIImageView *imageLogo = (UIImageView *) [self.view viewWithTag:100];
    imageLogo.image = [UIImage imageNamed:@"launch-logo@2x.png"];
    
    // Set position of logo
    // Set the fadeButton hidden on beginning
    self.launchImage1.frame = CGRectMake(0, 300, 320, 100);
    self.fadeout1.hidden = YES;
    
    // Set Duration an end position of logo
    [UIView animateWithDuration:2.0 animations:^{
        self.launchImage1.frame = CGRectMake(-100, 0, 100, 100);
    }completion:^(BOOL finished){
        // Set the fade effect for the button
        [UIView transitionWithView:self.view
                          duration:1.0
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            // Set fadeButton visible
                            self.fadeout1.hidden = NO;
                        }
                        completion:nil];
    }];
    
    
}



//}

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
