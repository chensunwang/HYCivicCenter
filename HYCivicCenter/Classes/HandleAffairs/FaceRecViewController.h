//
//  FaceRecViewController.h
//  HelloFrame
//
//  Created by 谌孙望 on 2023/5/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FaceRecResultDelegate <NSObject>

- (void)getFaceResult:(BOOL)result;

@end

@interface FaceRecViewController : UIViewController

@property (nonatomic, weak) id<FaceRecResultDelegate>delegate;
@property (nonatomic, copy) NSString *certifyId;
@property (nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
