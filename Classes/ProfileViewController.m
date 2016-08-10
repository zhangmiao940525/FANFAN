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
//#import "PhotoBrowseViewController.h"
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
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:nil options:nil];
#warning   这里为什么返回的是数组中的元素
    return [views lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //取到已经生成的TimelineTableViewController对象
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TimeLine" bundle:nil];
    
    TimeLineTableViewController *timelineTVC = [storyboard instantiateViewControllerWithIdentifier:@"TimelineTableViewController"];
    // 取到已经生成的PhotoBrowseViewController对象
    
    
    
}


@end
