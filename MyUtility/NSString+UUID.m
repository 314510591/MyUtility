//
//  NSString+UUID.m
//  QiXin
//
//  Created by dinner on 13-7-10.
//
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString*) stringWithUUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (NSString*) stringWithSimpleUUID
{
    NSString* uuid = [NSString stringWithUUID];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return [uuid lowercaseString];
}

@end
