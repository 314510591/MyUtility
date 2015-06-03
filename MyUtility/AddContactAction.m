//
//  AddContactAction.m
//  MyUtility
//
//  Created by tracetion on 14/11/13.
//  Copyright (c) 2014年 YMQ. All rights reserved.
//

#import "AddContactAction.h"
#import <AddressBook/AddressBook.h>
@implementation PersonDetailInfo

- (void)dealloc
{
    [_info_name release];
    [_info_position release];
    [_info_department release];
    [_info_mobile release];
    [_info_tel release];
    [_info_email release];
    [_info_company release];
    [_info_fax release];
    [_info_address release];
    [_info_url release];
    [super dealloc];
}


@end


@implementation AddContactAction

+ (BOOL)addEditContact:(PersonDetailInfo *)person
{
    ABAddressBookRef addressBook = nil;
    
    addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                             {
                                                 dispatch_semaphore_signal(sema);
                                             });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_release(sema);

    
    CFArrayRef records;
    if (addressBook) {
        records = ABAddressBookCopyArrayOfAllPeople(addressBook);
        
    }else{
        
        return NO;
    }
    
    BOOL exist = NO;
    
    ABRecordRef record = NULL;
    for (NSInteger i=0; i<CFArrayGetCount(records); i++) {
        record = CFArrayGetValueAtIndex(records, i);
        NSString *firstName = (NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
        [firstName autorelease];
        if (firstName && [firstName isEqualToString:person.info_name])
        {
            exist = YES;

            break;
        }
    }
    
    
    if (exist && record)
    {
        CFErrorRef error;
        
        //CFStringRef cf_name = (CFTypeRef)name;
        CFStringRef cf_num = (CFTypeRef)person.info_mobile;
        CFStringRef cf_telNum = (CFTypeRef)person.info_tel;
        ABMutableMultiValueRef multi = ABRecordCopyValue(record, kABPersonPhoneProperty);
        
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutableCopy(multi);
        
        NSArray *phones = (NSArray *)ABMultiValueCopyArrayOfAllValues(multiPhone);
        [phones autorelease];
        BOOL phoneInRecord = NO;
        for (NSString* phone in phones)
        {
            if ([phone isEqualToString:person.info_mobile])
            {
                phoneInRecord = YES;
            }
        }
        
        BOOL telInRecord = NO;
        for (NSString* phone in phones)
        {
            if ([phone isEqualToString:person.info_tel])
            {
                telInRecord = YES;
            }
        }
        
        if (!phoneInRecord || !telInRecord)
        {
            
            if (!phoneInRecord)
            {
                ABMultiValueAddValueAndLabel(multiPhone, cf_num, kABPersonPhoneMobileLabel, NULL);
                ABRecordSetValue(record, kABPersonPhoneProperty, multiPhone, &error);
                
            }
            
            if (!telInRecord)
            {
                ABMultiValueAddValueAndLabel(multiPhone, cf_telNum, kABWorkLabel, NULL);
                ABRecordSetValue(record, kABPersonPhoneProperty, multiPhone, &error);
            }
            
            
            CFRelease(multi);
            CFRelease(multiPhone);
            
            BOOL success = ABAddressBookAddRecord(addressBook, record, &error);
            if (!success)
            {
                //CFRelease(record);
                CFRelease(records);
                CFRelease(addressBook);
                return NO;
            }
            else
            {
                success = ABAddressBookSave(addressBook, &error);
                //CFRelease(record);
                CFRelease(records);
                
                if(addressBook)
                    CFRelease(addressBook);
                return success;
            }
        }
        
        else
        {
            CFRelease(multi);
            CFRelease(multiPhone);
            
            CFRelease(records);
            CFRelease(addressBook);
            return YES;
        }
    }
    else
    {
        
        ABRecordRef record = ABPersonCreate();
        CFErrorRef error;
        
        CFStringRef cf_name = (CFTypeRef)person.info_name;
        CFStringRef cf_num = (CFTypeRef)person.info_tel;
        CFStringRef cf_mobile = (CFTypeRef)person.info_mobile;
        CFStringRef cf_email = (CFTypeRef)person.info_email;
        CFStringRef cf_postion = (CFTypeRef)person.info_position;
        CFStringRef cf_company = (CFTypeRef)person.info_company;
        CFStringRef cf_url = (CFTypeRef)person.info_url;
        
        //存名字
        ABRecordSetValue(record, kABPersonFirstNameProperty, cf_name, &error);
        //存公司
        ABRecordSetValue(record, kABPersonOrganizationProperty, cf_company, &error);
        //存职称
        ABRecordSetValue(record, kABPersonJobTitleProperty, cf_postion, &error);
        
        //存电话号码  kABPersonPhoneProperty
        ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABPersonPhoneProperty);
           //存工作电话 kABWorkLabel
        ABMultiValueAddValueAndLabel(multi, cf_num, kABWorkLabel, NULL);
           //存移动电话 kABPersonPhoneMobileLabel
        ABMultiValueAddValueAndLabel(multi, cf_mobile, kABPersonPhoneMobileLabel, NULL);
        ABRecordSetValue(record, kABPersonPhoneProperty, multi, &error);
        CFRelease(multi);
        
        //存邮箱 kABMultiStringPropertyType
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiEmail, cf_email, kABWorkLabel, NULL);
        ABRecordSetValue(record, kABPersonEmailProperty, multiEmail, &error);
        CFRelease(multiEmail);
        
        
        //存网址 kABMultiStringPropertyType    工作 kABWorkLabel
        ABMutableMultiValueRef multiURL = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiURL, cf_url, kABWorkLabel, NULL);
        ABRecordSetValue(record, kABPersonURLProperty, multiURL, &error);
        CFRelease(multiURL);
        
        //存地址 kABMultiDictionaryPropertyType
        ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        
        //地址要用NSMutableDictionary存
        NSMutableDictionary *addressDictionary = [[[NSMutableDictionary alloc] init]autorelease];
        [addressDictionary setObject:person.info_address forKey:(NSString *) kABPersonAddressStreetKey];
        
        //工作 kABWorkLabel
        ABMultiValueAddValueAndLabel(multiAddress, addressDictionary, kABWorkLabel, NULL);
        ABRecordSetValue(record, kABPersonAddressProperty, multiAddress, &error);
        CFRelease(multiAddress);
        
        
        
        BOOL success = ABAddressBookAddRecord(addressBook, record, &error);
        if (!success) {
            CFRelease(record);
            CFRelease(records);
            CFRelease(addressBook);
            return NO;
        }else{
            success = ABAddressBookSave(addressBook, &error);
            CFRelease(record);
            CFRelease(records);
            CFRelease(addressBook);
            return success ? YES : NO;
        }
        return success;
        
    }
    
    return NO;
}

@end
