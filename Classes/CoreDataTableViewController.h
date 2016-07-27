//
//  CoreDataTableViewController.h
//  Fanner
//
//  Created by ZHANGMIA on 7/27/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController

@property (nonatomic,strong)NSFetchedResultsController *frc;


- (void)performFetch;

@end
