//
//  AutoSerializeObject.m
//  QiXin
//
//  Created by dinner on 13-10-14.
//
//

#import "AutoSerializeObject.h"
#import "NSObject+AutoSerialization.h"

@implementation AutoSerializeObject


- (NSString*) memberPrefix
{
    return nil;
}


- (void) dealloc
{
    [self clearAllMemberObjects];
}

+ (id) fromJson:(NSDictionary*)jsonObj
{
   // NSLog(@"class: %@", NSStringFromClass([self class]));
    
    
    id item = [[[self class] alloc] init];
    
    for(NSString* key in jsonObj.allKeys)
    {
        id value = [jsonObj objectForKey:key];
        
        if (ISNULL(value))
        {
            value = @"";
        }
        
        if ([value isKindOfClass:[NSNumber class]])//防止服务器会返回number类型 转换一下
        {
            value = [NSString stringWithFormat:@"%@",value];
        }
        NSString* memberName = key;
        NSString* memberPrefix = [item memberPrefix];
        
        if(memberPrefix && memberPrefix.length > 0)
        {
            memberName = [NSString stringWithFormat:@"%@_%@", memberPrefix, memberName];
        }
        
        [item setValue:value forKey:memberName];
    }
    
    return item;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        [self autoDecodeWithDecoder:aDecoder];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self autoCopyWithZone:zone];
}

@end
