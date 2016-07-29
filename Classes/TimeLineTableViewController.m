//
//  TimeLineTableViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 7/29/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "TimeLineTableViewController.h"
#import "Status.h"
#import "TimeLineCell.h"
#import "CoreDataStack.h"
#import "Service.h"
#import "CoreDataStack+Status.h"

@interface TimeLineTableViewController ()

@end

@implementation TimeLineTableViewController



- (void)configureFetch
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Status"];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sid" ascending:YES];
    
    NSArray *descriptors = @[descriptor];
    fr.sortDescriptors = descriptors;
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    
    self.frc.delegate = self;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    //
    UINib *nib = [UINib nibWithNibName:@"TimeLineCell" bundle:nil];
    // 注册cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TimelineCell"];
    self.tableView.estimatedRowHeight = 100;
    
    [[Service sharedInstance] requestStatusWithSuccess:^(NSArray *result) {
        [[CoreDataStack sharedCoreDataStack] insertStatusWithArrayProfile:result];
        // 
        [self configureFetch];
        //
        [self performFetch];
    } failure:^(NSError *error) {
        
    }];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    Status *status = [self.frc objectAtIndexPath:indexPath];
    
    [cell configureWithStatus:status];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewAutomaticDimension 是自适应
    return UITableViewAutomaticDimension;
}



@end
