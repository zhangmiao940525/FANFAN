//
//  CoreDataTableViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 7/27/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController ()<NSFetchedResultsControllerDelegate>


@end

@implementation CoreDataTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
}

- (void)performFetch
{
    //
    if (self.frc) {
        NSError *error;
        if (![self.frc performFetch:&error]) {
            NSLog(@"error = %@",error.description);
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.frc sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[[self.frc sections] objectAtIndex:section] numberOfObjects];
}

#pragma mark - NSFetchResults Controller Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
// 删除内容
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}


@end
