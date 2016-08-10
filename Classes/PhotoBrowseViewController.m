//
//  PhotoBrowseViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 8/10/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "PhotoBrowseViewController.h"
#import "Service+Photo.h"
#import "CoreDataStack+Status.h"
#import "PhotosCollectionCell.h"
#import "Status.h"
@interface PhotoBrowseViewController ()

@end

@implementation PhotoBrowseViewController

- (void)configureFetch {
    NSFetchRequest *fr = [[CoreDataStack sharedCoreDataStack] photoFetchRequest];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
}
- (void)performFetch {
    if (self.frc) {
        NSError *error;
        if(![self.frc performFetch:&error]) {
            NSLog(@"%@",error.description);
        }
        [self.collectionView reloadData];
    }
}
- (void)requestData {
    
    [[Service sharedInstance] getPhotosUserTimelineWithUserID:_userID sucess:^(id result) {
        [[CoreDataStack sharedCoreDataStack] insertOrUpdateWithStatusProfile:result];
        [self configureFetch];
        [self performFetch];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
}

#pragma mark - Table View Datasource With FRC
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self.frc sections] objectAtIndex:section] numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PhotosCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosCollectionCell" forIndexPath:indexPath];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    Status *status = [self.frc objectAtIndexPath:indexPath];
    PhotosCollectionCell *photoCell = (PhotosCollectionCell *)cell;
    [photoCell configureCellWithStatus:status];
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            break;
        case NSFetchedResultsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;
        default:
            break;
    }
    
}

#pragma mark - ARSegmentControllerDelegate
-(NSString *)segmentTitle {
    return @"图片";
}
- (UIScrollView *)streachScrollView {
    return self.collectionView;
}
@end
