//
//  ProfileViewController.m
//  Fanner
//
//  Created by ZHANGMIA on 8/9/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "ProfileViewController.h"
#import "CoreDataTableViewController.h"
#import "TimeLineTableViewController.h"
#import "PhotoBrowseViewController.h"
#import "CoreDataStack+User.h"
#import "User+CoreDataProperties.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (NSString *)userID
{
    if (_userID) {
        return _userID;
    }
    return [CoreDataStack sharedCoreDataStack].currentUser.uid;
}

- (UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView
{
    UIView <ARSegmentPageControllerHeaderProtocol> *views = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil] lastObject];
    return views;
}

- (void)viewDidLoad {
    // 1. 取到已经生成的TimelineTableViewController对象
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TimeLine" bundle:nil];
    TimeLineTableViewController *timelineTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineTVC"];
    // 2. 取到已经生成的PhotoBrowseViewController对象
    UIStoryboard *photoBrowse = [UIStoryboard storyboardWithName:@"PhotoBrowse" bundle:nil];
//    PhotoBrowseViewController *photoBrowseViewController = [photoBrowse instantiateViewControllerWithIdentifier:@"PhotoBrowseViewController"];
     PhotoBrowseViewController *photoBrowseViewController = [photoBrowse instantiateInitialViewController];
    photoBrowseViewController.userID = self.userID;
    
    // 3. 把要放在segment的控制器加进来
    [self setViewControllers:@[timelineTableViewController,photoBrowseViewController]];
    self.segmentMiniTopInset = 64;//
    self.headerHeight = 264;
    [super viewDidLoad];
    
}


@end
