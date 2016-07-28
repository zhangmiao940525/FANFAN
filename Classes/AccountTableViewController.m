//
//  AccountTableViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 7/26/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "AccountTableViewController.h"
#import "CoreDataStack+User.h"
#import "UserTableViewCell.h"
#import "User.h"

@interface AccountTableViewController ()

@end

@implementation AccountTableViewController

- (void)configureFetch
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSArray *descriptors = @[descriptor];
    fr.sortDescriptors = descriptors;
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    NSLog(@"self.frc.sections.count:%lu",self.frc.sections.count);
    
    self.frc.delegate = self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self configureFetch];
    //
    [self performFetch];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    
    User *user = [self.frc objectAtIndexPath:indexPath];
    cell.nameLabel.text = user.name;
    cell.idLabel.text = user.uid;
    [cell configureWithUser:user];
    
    return cell;
}

@end
