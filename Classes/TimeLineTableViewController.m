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
#import <JTSImageViewController.h>
#import "Photo.h"
#import <SDImageCache.h>

@interface TimeLineTableViewController ()<JTSImageViewControllerInteractionsDelegate>

@end

@implementation TimeLineTableViewController


// 设置请求
- (void)configureFetch
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Status"];
    // 设置排序
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"sid" ascending:YES];
    
    NSArray *descriptors = @[descriptor];
    fr.sortDescriptors = descriptors;
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    // 设置代理
    self.frc.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeLineCell" bundle:nil] forCellReuseIdentifier:@"TimelineCell"];
    // cell预估高度
    self.tableView.estimatedRowHeight = 100;
    
    [[Service sharedInstance] requestStatusWithSuccess:^(NSArray *result) {
        [[CoreDataStack sharedCoreDataStack] insertStatusWithArrayProfile:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [self configureFetch];
            // 执行查询
            [self performFetch];
        });
      
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)showPhotoWithCell:(TimeLineCell *)cell photo:(Photo *)photo
{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:photo.largeurl];
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    if (image) {
         imageInfo.image = image;
    } else {
        imageInfo.imageURL = [NSURL URLWithString:photo.largeurl];
    }
    
    JTSImageViewController *imageViewController = [[JTSImageViewController alloc] initWithImageInfo:imageInfo mode:JTSImageViewControllerMode_Image backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled | JTSImageViewControllerBackgroundOption_Blurred];
    [imageViewController showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
    imageViewController.interactionsDelegate = self;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineCell"];
    
    Status *status = [self.frc objectAtIndexPath:indexPath];
    
    [cell configureWithStatus:status];
    
    cell.didSelectPhotoBlock = ^(TimeLineCell *cell){
        [self showPhotoWithCell:cell photo:status.photo];
    };
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // UITableViewAutomaticDimension 是自适应
    return UITableViewAutomaticDimension;
}

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect
{
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"ok" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 将图片保存至相册
        UIImageWriteToSavedPhotosAlbum(imageViewer.image, nil, nil, nil);
    }];
    UIAlertAction *cancelSave = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCtr addAction:save];
    [alertCtr addAction:cancelSave];
    
    [imageViewer presentViewController:alertCtr animated:YES completion:nil];
}




@end
