//
//  LoginViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 7/25/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()


@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginBarButtonItem;


@end

@implementation LoginViewController

- (IBAction)login:(UIBarButtonItem *)sender
{
    // 1. 登录成功
    
    [self performSegueWithIdentifier:@"ShowAccountSegue" sender:nil];
    
    // 2. 登录失败
    
   // UIAlertController
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
