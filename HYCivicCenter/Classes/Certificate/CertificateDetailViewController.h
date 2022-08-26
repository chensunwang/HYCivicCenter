//
//  CertificateDetailViewController.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CertificateDetailViewController : UIViewController

@property (nonatomic, copy) NSString *holder_identity_num;
@property (nonatomic, copy) NSString *license_item_code;
@property (nonatomic, copy) NSString *cardName;
@property (nonatomic, copy) NSString *cardNum;
@property (nonatomic, copy) NSString *idPhoneType;

@end

NS_ASSUME_NONNULL_END
