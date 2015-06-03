//
//  NSObject+AutoSerialization.h
//  QiXin
//
//  Created by dinner on 13-6-19.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (AutoSerialization)

- (void) clearAllMemberObjects;
- (id) autoCopyWithZone:(NSZone*)zone;

- (void) autoEncodeWithCoder:(NSCoder *)aCoder;
- (void) autoDecodeWithDecoder:(NSCoder*)aDecoder;

@end
