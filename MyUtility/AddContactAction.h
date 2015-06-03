//
//  AddContactAction.h
//  MyUtility
//
//  Created by tracetion on 14/11/13.
//  Copyright (c) 2014年 YMQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonDetailInfo : NSObject

@property (nonatomic, retain) NSString* info_name;
@property (nonatomic, retain) NSString* info_position; // 职位
@property (nonatomic, retain) NSString* info_department;
@property (nonatomic, retain) NSString* info_mobile; // 手机号
@property (nonatomic, retain) NSString* info_tel; // 办公电话
@property (nonatomic, retain) NSString* info_email;
@property (nonatomic, retain) NSString* info_company;//所属单位
@property (nonatomic, retain) NSString* info_fax;
@property (nonatomic, retain) NSString* info_address;
@property (nonatomic, retain) NSString* info_url;

@end

@interface AddContactAction : NSObject

+ (BOOL)addEditContact:(PersonDetailInfo *)person;

@end
