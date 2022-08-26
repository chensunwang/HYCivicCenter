//
//  CertificateLibraryTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CertificateModel : NSObject

@property (nonatomic, copy) NSString *auth_code;
@property (nonatomic, copy) NSString *issue_org_code;
@property (nonatomic, copy) NSString *issue_org_name;
@property (nonatomic, copy) NSString *license_code;
@property (nonatomic, copy) NSString *license_item_code;
@property (nonatomic, copy) NSString *holder_identity_num;
@property (nonatomic, copy) NSString *holder_identity_num_encrypt;
@property (nonatomic, copy) NSString *issue_date;
@property (nonatomic, copy) NSString *id_code;
@property (nonatomic, copy) NSString *name;

@end

@interface CertificateLibraryTableViewCell : UITableViewCell

@property (nonatomic, strong) CertificateModel *model;

@end

NS_ASSUME_NONNULL_END
