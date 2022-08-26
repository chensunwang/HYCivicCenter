//
//  HYServiceProgressModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYServiceProgressModel : NSObject

//@property (nonatomic, copy) NSString *APPLY_SUBJECT;
//@property (nonatomic, copy) NSString *ASSORT;
//@property (nonatomic, copy) NSString *FARESTATE;
//@property (nonatomic, copy) NSString *ITEM_CODE;
//@property (nonatomic, copy) NSString *ITEM_NAME;
//@property (nonatomic, copy) NSString *ORG_CODE;
//@property (nonatomic, copy) NSString *ORG_NAME;
//@property (nonatomic, copy) NSString *RECEIVE_NUMBER;
//@property (nonatomic, copy) NSString *REGION_CODE;
//@property (nonatomic, copy) NSString *REGION_NAME;
//@property (nonatomic, copy) NSString *STATE;
//@property (nonatomic, copy) NSString *FINISH_TIME;
//@property (nonatomic, copy) NSString *SUBMIT_TIME;

@property (nonatomic, copy) NSString * applySubject;
@property (nonatomic, copy) NSString * finishTime;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * itemName;
@property (nonatomic, copy) NSString * orgName;
@property (nonatomic, copy) NSString * regionCode;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * stateColor;
@property (nonatomic, copy) NSString * stateName;
@property (nonatomic, copy) NSString * submitTime;
@property (nonatomic, copy) NSString * timeLimit;

@end

NS_ASSUME_NONNULL_END
