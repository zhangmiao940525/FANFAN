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
#import "JTSImageViewController.h"
#import "Photo.h"
#import <SDImageCache.h>
#import "CellToolbarView.h"

@interface TimeLineTableViewController ()<JTSImageViewControllerInteractionsDelegate>

@end

@implementation TimeLineTableViewController


// 设置请求
- (void)configureFetch
{
    NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:@"Status"];
    // 设置排序
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    
    NSArray *descriptors = @[descriptor];
    fr.sortDescriptors = descriptors;
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fr managedObjectContext:[CoreDataStack sharedCoreDataStack].context sectionNameKeyPath:nil cacheName:nil];
    
    // 设置代理
    self.frc.delegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
// 增加下拉刷新
     [self createRefrenshControl];
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TimeLineCell" bundle:nil] forCellReuseIdentifier:@"TimelineCell"];
    // cell预估高度
    self.tableView.estimatedRowHeight = 100;
    
    [self requestData];
   
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
    // 配置收藏按钮
    [cell.cellToolbar setupStarButtonWithBOOL:status.favorited.boolValue];
    
    
    cell.didSelectPhotoBlock = ^(TimeLineCell *cell){
        [self showPhotoWithCell:cell photo:status.photo];
    };
    // 设置代理
    cell.cellToolbar.delegate = self;
    
    
    
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
// TableViewController 特有的属性refreshControl
// 增加下拉刷新
- (void)createRefrenshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在加载数据..."];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshData
{
    [self requestData];
    
    [self.refreshControl endRefreshing];
}

- (void)requestData
{
    
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

- (void)starWithCellToolbar:(CellToolbarView *)toolbar sender:(id)sender forEvent:(UIEvent *)event
{
    // 取到收藏所用的indexPath，也就是所在的cell
    // 取到所有的touches
    NSSet *touches = [event allTouches];
    // 取到某一个touch
    UITouch  *touch = [touches anyObject];
    // 取到这个touch所在的位置location
    CGPoint point = [touch locationInView:self.tableView];
    // 最后获取到这个位置所在的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    // 用frc取到这个cell下的status对象
    Status *status = [self.frc objectAtIndexPath:indexPath];
    
    // 请求收藏接口
    [[Service sharedInstance] starWithStatusID:status.sid success:^(NSArray *result) {
        
        NSLog(@"result = %@", result);
        [[CoreDataStack sharedCoreDataStack] insertOrUpdateWithStatusProfile:result];
        
        [toolbar setupStarButtonWithBOOL:status.favorited.boolValue];
      
    } failure:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
    
}


@end
