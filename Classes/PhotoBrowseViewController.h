//
//  PhotoBrowseViewController.h
//  Fanner
//
//  Created by ZHANGMIA on 8/10/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARSegmentPager/ARSegmentPageController.h>
#import <CoreData/CoreData.h>

@interface PhotoBrowseViewController : UICollectionViewController<ARSegmentControllerDelegate,NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSFetchedResultsController *frc;

@end
