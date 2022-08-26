//
//  HonorWallTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/12.
//

#import <UIKit/UIKit.h>
@class HonorWallTableViewCell;

NS_ASSUME_NONNULL_BEGIN

@interface HonorWallModel :  NSObject

@property (nonatomic, copy) NSString *honorName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *honorPhotoOne;
@property (nonatomic, copy) NSString *honorPhotoTwo;
@property (nonatomic, copy) NSString *honorPhotoThree;
@property (nonatomic, copy) NSString *honorRemark;
@property (nonatomic, copy) NSString *id;

@end

@protocol HonorDeleteDelegate <NSObject>

- (void)honorCell:(HonorWallTableViewCell *)cell didDeleteWithModel:(HonorWallModel *)model;

@end

@interface HonorWallTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HonorDeleteDelegate> delegate;
@property (nonatomic, strong) HonorWallModel *model;

@end

NS_ASSUME_NONNULL_END
