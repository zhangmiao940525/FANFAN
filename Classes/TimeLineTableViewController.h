//
//  TimeLineTableViewController.h
//  Fanner
//
//  Created by ZHANGMIA on 7/29/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "CellToolbarView.h"
#import <ARSegmentPager/ARSegmentPageController.h>

@interface TimeLineTableViewController : CoreDataTableViewController<ARSegmentControllerDelegate,CellToolbarDelegate>

@end
