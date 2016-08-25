//
//  NSObject+AutoSerialization.m
//  QiXin
//
//  Created by dinner on 13-6-19.
//
//

#import <objc/message.h>
#import "NSObject+AutoSerialization.h"

@implementation NSObject (AutoSerialization)

- (void) clearAllMemberObjects
{
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList([self class], &ivarsCnt);
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        const char* type = ivar_getTypeEncoding(ivar);
        
        if(type[0] == '@')
        {
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:nil forKey:key];
        }
    }
    free(ivars);
}

- (id) autoCopyWithZone:(NSZone*)zone
{
    id another = [[[self class] allocWithZone:zone] init];
    
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList([self class], &ivarsCnt);
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        
        if([value isKindOfClass:[NSArray class]])
        {
            NSArray* copiedArray = [[[value class] alloc] initWithArray:value copyItems:YES];
            [another setValue:copiedArray forKey:key];
        }
        else if([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dict = [[[value class] alloc] initWithDictionary:value copyItems:YES];
            [another setValue:dict forKey:key];
        }
        else if([value isKindOfClass:[NSSet class]])
        {
            NSSet* set = [[[value class] alloc] initWithSet:value copyItems:YES];
            [another setValue:set forKey:key];
        }
        else if([value isKindOfClass:[NSOrderedSet class]])
        {
            NSOrderedSet* orderedSet = [[[value class] alloc] initWithOrderedSet:value copyItems:YES];
            [another setValue:orderedSet forKey:key];
        }
        else
        {
            [another setValue:value forKey:key];
        }
    }
    
    free(ivars);
    
    return another;
}

- (void) autoEncodeWithCoder:(NSCoder *)aCoder
{
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList([self class], &ivarsCnt);
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKey:key];
        const char* type = ivar_getTypeEncoding(ivar);
        
        switch (type[0]) {
            case '@':
                [aCoder encodeObject:value forKey:key];
                break;
            case _C_UCHR:
            case _C_CHR:
            case _C_SHT:
            case _C_USHT:
            case _C_INT:
            case _C_UINT:
            case _C_LNG:
            case _C_ULNG:
            case _C_BOOL:
                [aCoder encodeInt:[value intValue] forKey:key];
                break;
            case _C_LNG_LNG:
            case _C_ULNG_LNG:
                [aCoder encodeInt64:[value longLongValue] forKey:key];
                break;
            case _C_DBL:
                [aCoder encodeDouble:[value doubleValue] forKey:key];
                break;
            case _C_FLT:
                [aCoder encodeFloat:[value floatValue] forKey:key];
                break;
            default:
                break;
        }
    }
    
    free(ivars);
}


- (void) autoDecodeWithDecoder:(NSCoder*)aDecoder
{
    unsigned int ivarsCnt = 0;
    Ivar *ivars = class_copyIvarList([self class], &ivarsCnt);
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        const char* type = ivar_getTypeEncoding(ivar);
        
        switch (type[0]) {
            case '@':
                [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
                break;
            case _C_UCHR:
            case _C_CHR:
            case _C_SHT:
            case _C_USHT:
            case _C_INT:
            case _C_UINT:
            case _C_LNG:
            case _C_ULNG:
            case _C_BOOL:
                [self setValue:[NSNumber numberWithInt:[aDecoder decodeIntForKey:key]] forKey:key];
                break;
            case _C_LNG_LNG:
            case _C_ULNG_LNG:
                [self setValue:[NSNumber numberWithLongLong:[aDecoder decodeInt64ForKey:key]] forKey:key];
                break;
            case _C_DBL:
                [self setValue:[NSNumber numberWithDouble:[aDecoder decodeDoubleForKey:key]] forKey:key];
                break;
            case _C_FLT:
                [self setValue:[NSNumber numberWithFloat:[aDecoder decodeFloatForKey:key]] forKey:key];
                break;
            default:
                break;
        }
    }
    
    free(ivars);
}

@end
