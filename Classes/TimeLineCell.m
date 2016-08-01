//
//  TimeLineCell.m
//  Fanner
//
//  Created by ZHANGMIA on 7/28/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import "TimeLineCell.h"
#import "Status.h"
#import "User+CoreDataProperties.h"
#import <UIImageView+WebCache.h>
#import "Photo.h"

@interface TimeLineCell ()

@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

@implementation TimeLineCell


- (IBAction)showLargePhoto:(UIButton *)sender
{
    
    _didSelectPhotoBlock(self);
}


- (void)configureWithStatus:(Status *)status
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSFormattingUnitStyleShort;
    formatter.timeStyle = NSFormattingUnitStyleShort;
    
    self.dateCreatedLabel.text = [formatter stringFromDate:status.created_at];
    self.nameLabel.text = status.user.name;
    self.contentLabel.text = status.text;
    
    NSURL *url = [NSURL URLWithString:status.user.iconURL];
    // SDWebImageRefreshCached 已经下载过一次的就不需要再下载了
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"] options:SDWebImageRefreshCached];
   
    NSURL *photoURL = [NSURL URLWithString:status.photo.imageurl];
    if (status.photo.imageurl) {
        
        [self.photoImageView sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"BackgroundImage"] options:SDWebImageRefreshCached];
    } else {
        [self.photoImageView sd_setImageWithURL:nil placeholderImage:nil  options:SDWebImageRefreshCached];
    
        self.btn.hidden = YES;
    }
    
    
}

@end
