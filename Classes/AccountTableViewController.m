//
//  AccountTableViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "AccountTableViewController.h"
#import "CoreDataStack+User.h"

@interface AccountTableViewController ()

@end

@implementation AccountTableViewController

- (void)configureFetch
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self configureFetch];
    //
    [self performFetch];
}

@end
