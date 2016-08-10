//
//  PhotosCollectionCell.m
//  Fanner
//
//  Created by ZHANGMIA on 8/10/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "PhotosCollectionCell.h"
#import "Status+CoreDataProperties.h"
#import "Photo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PhotosCollectionCell

- (void)configureCellWithStatus:(Status *)status
{
    NSURL *photoUrl = [NSURL URLWithString:status.photo.thumburl];
    //SDWebImageProgressiveDownload : 此标志可以进行渐进式下载
    [_photoImageView sd_setImageWithURL:photoUrl placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"] options:SDWebImageProgressiveDownload];
}



@end
