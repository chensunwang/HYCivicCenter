//
//  ChooseIndustryModel.h
//  HelloFrame
//
//  Created by nuchina on 2021/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseIndustryModel : NSObject

//createBy = "";
//createTime = "";
//delFlg = 0;
//id = "";
//parentId = "";
//parentName = "";
//remark = "";
//searchValue = "";
//typeId = 11;
@property (nonatomic, copy) NSString *typeId;
//typeName = " \U5236\U836f|\U533b\U7597";
@property (nonatomic, copy) NSString *typeName;
//updateBy = "";
//updateTime = "";
@property (nonatomic, strong) NSMutableArray *children;

@end

NS_ASSUME_NONNULL_END
