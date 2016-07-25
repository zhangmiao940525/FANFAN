//
//  SpliashViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 7/25/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "SpliashViewController.h"

@interface SpliashViewController ()

@end

@implementation SpliashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL isUserExist = NO;
        if (isUserExist) {
            [self performSegueWithIdentifier:@"MainSegue" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        }
        
        
    });
    
    
}

@end
