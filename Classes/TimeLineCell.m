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
#import <DTCoreText/DTCoreText.h>
#import "CellToolbarView.h"

@interface TimeLineCell ()

@end

@implementation TimeLineCell

@synthesize cellToolbar;

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
    //self.contentsLabel.text = status.text;
    
    NSData *data = [status.text dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{DTDefaultFontName: @"HelveticalNeue-Light",
                              DTDefaultFontSize: @16,
                              DTDefaultLinkColor: [UIColor blueColor]};
    
    // options[DTDefaultFontName] = HelveticalNeue-Light;
    
    NSAttributedString *attribStr = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:nil];
    self.contentsLabel.attributedString = attribStr;
    self.contentsLabel.numberOfLines = 0;
    
    NSURL *url = [NSURL URLWithString:status.user.iconURL];
    // SDWebImageRefreshCached 已经下载过一次的就不需要再下载了
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"BackgroundAvatar"] options:SDWebImageRefreshCached];
    
    
        NSURL *photoURL = [NSURL URLWithString:status.photo.imageurl];
        if (photoURL) {
            _imageHeightConstraint.constant = 200;
            
//            [self.photoImageView sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"BackgroundImage"] options:SDWebImageRefreshCached];
            [self.photoImageView sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"BackgroundImage"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                _imageHeightConstraint.constant = image.size.height;
            }];

        } else {
            _imageHeightConstraint.constant = 0;
            self.photoImageView.image = nil;
        }
    
    
    cellToolbar = [self createCellToolbar];
    
    cellToolbar.translatesAutoresizingMaskIntoConstraints = NO;
    cellToolbar.backgroundColor = [UIColor blueColor];
    [self.toolbar addSubview:cellToolbar];
    
    NSLayoutConstraint *top = [cellToolbar.topAnchor constraintEqualToAnchor:self.toolbar.topAnchor];
    NSLayoutConstraint *bottom = [cellToolbar.bottomAnchor constraintEqualToAnchor:self.toolbar.bottomAnchor];
    NSLayoutConstraint *left = [cellToolbar.leftAnchor constraintEqualToAnchor:self.toolbar.leftAnchor];
    NSLayoutConstraint *right = [cellToolbar.rightAnchor constraintEqualToAnchor:self.toolbar.rightAnchor];
    
    top.active = YES;
    bottom.active = YES;
    left.active = YES;
    right.active = YES;
    
    
}

/**
 *   做代码布局要注意2点
 *
 *   1. 关闭自动布局 这两个是冲突的
 *   2. 视图层次结构要加好
 */
// 创建cell tool bar
- (CellToolbarView *)createCellToolbar
{
    // 从bundle里面根据xib创建views
    CellToolbarView *cellToolBar = [[[NSBundle mainBundle] loadNibNamed:@"CellToolbarView" owner:nil options:nil] lastObject];
    
    return cellToolBar;
}



@end
