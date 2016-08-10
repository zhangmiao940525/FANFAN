//
//  SpliashViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 7/25/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "SpliashViewController.h"
#import "User.h"
//#import "CoreDataStack.h"
#import "CoreDataStack+User.h"
@interface SpliashViewController ()

@end

@implementation SpliashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        //  根据数据库是否有用户做判断
        User *user = [CoreDataStack sharedCoreDataStack].currentUser;
        NSLog(@"%@", user);

        if (user) {
            [self performSegueWithIdentifier:@"MainSegue" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
        }
    });
}

@end
