//
//  HYItemTotalInfoModel.h
//  HelloFrame
//
//  Created by 谌孙望 on 2022/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYItemTotalInfoModel : NSObject

@property (nonatomic, strong) NSArray * charge;            // 收费明细
@property (nonatomic, strong) NSArray * condition;         // 受理条件
@property (nonatomic, strong) NSArray * consult;           // 咨询途径
@property (nonatomic, strong) NSArray * handlingprocess;   // 办理流程
@property (nonatomic, strong) NSArray * ItemInfo;          // 事项相关信息
@property (nonatomic, strong) NSArray * material;          // 材料列表
@property (nonatomic, strong) NSArray * outMap;            // 流程图
@property (nonatomic, strong) NSArray * question;          // 问题列表
@property (nonatomic, assign) NSInteger status;            // 状态码

@end


@interface HYChargeModel : NSObject

@property (nonatomic, copy) NSString * name;               // 名称
@property (nonatomic, copy) NSString * standard;           // 收费标准

@end


@interface HYConditionModel : NSObject

@property (nonatomic, assign) NSInteger assort;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, strong) NSDictionary * createTime;
@property (nonatomic, copy) NSString * creator;
@property (nonatomic, copy) NSString * folderId;
@property (nonatomic, copy) NSString * keyword;
@property (nonatomic, copy) NSString * lastEditor;
@property (nonatomic, strong) NSDictionary * lastTime;
@property (nonatomic, copy) NSString * name;                // 受理条件名称
@property (nonatomic, strong) NSDictionary * remark;
@property (nonatomic, assign) NSInteger status;             //
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * usualType;
@property (nonatomic, copy) NSString * usualValue;

@end


@interface HYConditionTimeModel : NSObject

@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hours;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger timezoneOffset;
@property (nonatomic, assign) NSInteger year;

@end


@interface HYConsultModel : NSObject

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * letterOrganName;
@property (nonatomic, copy) NSString * phoneNumber;         // 窗口电话
@property (nonatomic, copy) NSString * windowAddress;       // 窗口地址
@property (nonatomic, copy) NSString * windowName;          // 窗口名称

@end


@interface HYHandlingProcessModel : NSObject

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * content;             // 办理流程内容
@property (nonatomic, copy) NSString * name;                // 办理流程名称

@end


@interface HYItemInfoModel : NSObject

@property (nonatomic, copy) NSString * agentCode;           // 承办单位编码
@property (nonatomic, copy) NSString * agentName;           // 承办单位名称
@property (nonatomic, assign) NSInteger agreeTime;          // 承诺时限
@property (nonatomic, copy) NSString * agreeTimeUnit;       // 承诺时限
@property (nonatomic, copy) NSString * agreeTimeUnitValue;
@property (nonatomic, copy) NSString * assort;              // 办件类型
@property (nonatomic, copy) NSString * code;                // 事项编码
@property (nonatomic, copy) NSString * id;                  // id主键
@property (nonatomic, assign) NSInteger lawTime;            // 法定时限
@property (nonatomic, copy) NSString * lawTimeUnit;         // 法定时限单位
@property (nonatomic, copy) NSString * lawTimeUnitValue;
@property (nonatomic, copy) NSString * name;                // 事项名称
@property (nonatomic, copy) NSString * orgCode;             // 事项所属单位的编码
@property (nonatomic, copy) NSString * orgName;             // 事项所属的单位名称
@property (nonatomic, copy) NSDictionary * progress;
@property (nonatomic, copy) NSString * regionCode;          // 事项区划编码
@property (nonatomic, copy) NSString * regionName;          // 事项区划名称
@property (nonatomic, copy) NSString * serviceObject;       // 判断是个人还是企业
@property (nonatomic, assign) BOOL  servicePersonFlag;      // 判断是否是个人事项 true是 false否
@property (nonatomic, copy) NSString * type;                // 事项类型
@property (nonatomic, assign) BOOL canHandle;               // 是否可以操作
@property (nonatomic, copy) NSString * online_address;      // 在线办理

@end


@interface HYMaterialModel : NSObject

@property (nonatomic, copy) NSString * autoUploadUrl;         // 自动上传的证件照
@property (nonatomic, copy) NSString * code;                  // 材料code
@property (nonatomic, copy) NSString * docId;                 // docld
@property (nonatomic, copy) NSString * fileName;              // 文件名称
@property (nonatomic, copy) NSString * materialCode;          // 材料编码
@property (nonatomic, copy) NSString * materialId;            // 材料id
@property (nonatomic, copy) NSString * must;                  // 是否支持(=1 支持容缺受理和支持承诺审批 , =2支持容缺受理和承诺审批)
@property (nonatomic, copy) NSString * name;                  // 材料名称
@property (nonatomic, copy) NSString * type;

@end


@interface HYOutMapModel : NSObject

@property (nonatomic, copy) NSString * code;
@property (nonatomic, strong) NSDictionary * createTime;
@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, copy) NSString * itemCode;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSDictionary * remark;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, assign) NSInteger version;
@property (nonatomic, copy) NSString * webUrl;                // 流程图webUrl

@end


@interface HYQuestionModel : NSObject

@property (nonatomic, copy) NSString * answer;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * question;
@property (nonatomic, strong) NSDictionary * remark;
@property (nonatomic, strong) NSDictionary * sortOrder;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString * title;

@end


@interface HYGuideItemInfoModel : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * value;

@end


@interface HYUploadedMaterailModel : NSObject

@property (nonatomic, copy) NSString * docId;
@property (nonatomic, copy) NSString * documentId;
@property (nonatomic, copy) NSString * documentName;
@property (nonatomic, copy) NSString * fileName;
@property (nonatomic, copy) NSString * url;

@end

NS_ASSUME_NONNULL_END
