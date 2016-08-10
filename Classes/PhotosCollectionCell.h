//
//  PhotosCollectionCell.h
//  Fanner
//
//  Created by ZHANGMIA on 8/10/16.
//  Copyright © 2016 ZHANGMIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Status;

@interface PhotosCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

- (void)configureCellWithStatus:(Status *)status;

@end
