//
//  EditBusinessCardTableViewCell.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditBusinessCardTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UITextField *rightTF;
@property (nonatomic, strong) UIImageView *headerIV;
@property (nonatomic, strong) UIImageView *holderIV;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@interface EditBusinessCardModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *createBy;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *duty; // 职位
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *emailEncrypt;// emial加密
@property (nonatomic, copy) NSString *fansNumber;
@property (nonatomic, copy) NSString *headPhoto;
@property (nonatomic, copy) NSString *industryId; // 行业id
@property (nonatomic, copy) NSString *industryName; // 行业name
@property (nonatomic, copy) NSString *qrCodeUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *nameEncrypt;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *phoneEncrypt;
@property (nonatomic, copy) NSString *weChat;
@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *collectId;


@end

NS_ASSUME_NONNULL_END
