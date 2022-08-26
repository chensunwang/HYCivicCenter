//
//  HYContactManager.h
//  HelloFrame
//
//  Created by nuchina on 2021/8/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYContactManager : NSObject

typedef void(^ContactAuthorization)(BOOL isAuthorization);

- (void)getContactAuthorization:(ContactAuthorization)contactAuthotization;

@end

NS_ASSUME_NONNULL_END
