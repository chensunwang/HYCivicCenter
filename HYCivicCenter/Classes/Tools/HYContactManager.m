//
//  HYContactManager.m
//  HelloFrame
//
//  Created by nuchina on 2021/8/26.
//

#import "HYContactManager.h"
#import <ContactsUI/ContactsUI.h>

@implementation HYContactManager

- (void)getContactAuthorization:(ContactAuthorization)contactAuthotization {
    
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                //第一次获取权限判断，点击 “不允许” 则 granted = NO；点击 “好” 则 granted = YES；
                if (contactAuthotization) {
                    contactAuthotization(granted);
                }
            }];
        } else if (status == CNAuthorizationStatusAuthorized) {//有权限
            if (contactAuthotization) {
                contactAuthotization(YES);
            }
        } else {//无权限
            //NSLog(@"iOS 9 later 您未开启通讯录权限,请前往设置中心开启");
            if (contactAuthotization) {
                contactAuthotization(NO);
            }
        }
    }
    
}

@end
