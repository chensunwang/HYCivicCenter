//
//  HYGuessBusinessModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYGuessBusinessModel : NSObject

@property (nonatomic, copy) NSString *agentTitleList;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *littleTitle;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *needFaceRecognition;
@property (nonatomic, copy) NSString *onlyEnterpriseFlag;
@property (nonatomic, copy) NSString *orgCode;
@property (nonatomic, copy) NSString *orgName;
@property (nonatomic, copy) NSString *outLinkFlag;
@property (nonatomic, copy) NSString *outType;
@property (nonatomic, copy) NSString *serviceObjType;
@property (nonatomic, strong) NSArray *serviceObjTypeList;
@property (nonatomic, copy) NSString *servicePersonFlag;
@property (nonatomic, copy) NSString *canHandle;

@end

NS_ASSUME_NONNULL_END
