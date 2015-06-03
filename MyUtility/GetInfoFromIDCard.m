//
//  GetInfoFromIDCard.m
//  Test111
//
//  Created by hgcm on 15/5/12.
//  Copyright (c) 2015年 hgcm. All rights reserved.
//

#import "GetInfoFromIDCard.h"

@implementation GetInfoFromIDCard

- (id)initWithIDCrad:(NSString *)IDCard
{
    if (self = [super init])
    {
        self.birthday = [self birthdayStrFromIdentityCard:IDCard];
        self.sex      = [self getIdentityCardSex:IDCard];
    }
    return self;
}


//根据身份证号获取生日
-(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    if (numberStr.length < 18)
    {
        //**截取前12位
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 11)];
        
        //**检测前12位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        if(!isAllNumber)
            return result;
        
        
        year = [NSString stringWithFormat:@"19%@",[numberStr substringWithRange:NSMakeRange(6, 2)]];
        month = [numberStr substringWithRange:NSMakeRange(8, 2)];
        day = [numberStr substringWithRange:NSMakeRange(10,2)];
        

        [result appendString:year];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }
    else
    {
        //**截取前14位
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
        
        //**检测前14位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        if(!isAllNumber)
            return result;
        
        year = [numberStr substringWithRange:NSMakeRange(6, 4)];
        month = [numberStr substringWithRange:NSMakeRange(10, 2)];
        day = [numberStr substringWithRange:NSMakeRange(12,2)];
        
        [result appendString:year];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }
    
    
}

//根据身份证号性别
-(NSString *)getIdentityCardSex:(NSString *)numberStr
{
    
    int sexInt = 0;
    
    if (numberStr.length < 18)
    {
        sexInt = [[numberStr substringWithRange:NSMakeRange(14,1)] intValue];
    }
    else
    {
        sexInt = [[numberStr substringWithRange:NSMakeRange(16,1)] intValue];
    }
    
    if(sexInt%2!=0)
    {
        
        return @"男";
        
    }
    else
    {
        return @"女";
    }
}

- (NSString *)changeToNewIDCard:(NSString *)IDcard
{
    NSString *newID = IDcard;
    if (IDcard.length == 15)
    {
        NSArray *W = @[@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1"];
        NSArray *A = @[@"1",@"0",@"x",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2"];
        NSInteger i,j,s = 0;
        newID = [NSString stringWithFormat:@"%@19%@",[newID substringWithRange:NSMakeRange(0,6)],[newID substringWithRange:NSMakeRange(6,IDcard.length - 6)]];
        for (i = 0; i < newID.length; i ++)
        {
            if (i + i + 1 > newID.length)
            {
                break;
            }
            NSString *tempNum = [newID substringWithRange:NSMakeRange(i,i + 1)];
            NSInteger wNum = [W[i] integerValue];
            j = [tempNum integerValue] * wNum;
            s = s + j;
        }
        s = s % 11;
        newID = [NSString stringWithFormat:@"%@%@",newID,A[s]];
    }
    return newID;
}

@end
