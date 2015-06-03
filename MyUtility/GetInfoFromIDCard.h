//
//  GetInfoFromIDCard.h
//  Test111
//
//  Created by hgcm on 15/5/12.
//  Copyright (c) 2015年 hgcm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetInfoFromIDCard : NSObject

@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *cityNum;


- (id)initWithIDCrad:(NSString *)IDCard;
- (NSString *)changeToNewIDCard:(NSString *)IDcard;

@end
