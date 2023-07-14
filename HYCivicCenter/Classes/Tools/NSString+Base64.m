//
//  NSString+Base64.m
//  HelloFrame
//
//  Created by nuchina on 2021/9/6.
//

#import "NSString+Base64.h"

@implementation NSString (Base64)

- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding: NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
}

- (NSString *)stringEncode {
    
    NSString *encodeString = [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet]];
    return encodeString;
    
}

@end
