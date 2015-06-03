//
//  AutoSerializeObject.h
//  QiXin
//
//  Created by dinner on 13-10-14.
//
//

#import <Foundation/Foundation.h>

@protocol AutoSerializeProtocol <NSObject>

@required

- (NSString*) memberPrefix;

@end

@interface AutoSerializeObject : NSObject<AutoSerializeProtocol, NSCopying>
{
}

- (NSString*) memberPrefix;
+ (id) fromJson:(NSDictionary*)jsonObj;

@end
