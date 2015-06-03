//
//  MyUtil.h
//  HotelManager
//
//  Created by Dragon Huang on 13-4-26.
//  Copyright (c) 2013年 baiwei.Yuan Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+Blocks.h"


#define ISNULL(__pointer)           (__pointer == nil || [[NSNull null] isEqual:__pointer])


#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ALPHAWITHCOLOR(color)       [[UIColor color] colorWithAlphaComponent:a]
#define ALPHAWITHRGBCOLOR(r,g,b,a)  [RGBCOLOR(r,g,b) colorWithAlphaComponent:a]

#define theAppWindow	            [[UIApplication sharedApplication] keyWindow]
#define theApp                      [[UIApplication sharedApplication] delegate]


#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"function:%s line:%d", __func__,__LINE__)
#else
#define debugLog(...)
#define debugMethod()
#endif

#define SINGLETON_IMPLE(className) \
static className* s_pInstance = nil; \
+ (className*)sharedInstance { \
@synchronized(self) { \
if (nil == s_pInstance) { \
[[self alloc] init]; \
} \
return s_pInstance; \
} \
} \
+(id)allocWithZone:(NSZone *)zone { \
@synchronized(self) { \
if (nil == s_pInstance) {\
s_pInstance = [super allocWithZone:zone]; \
}\
return s_pInstance; \
} \
}



#pragma mark - string Utils
@interface StringUtils : NSObject
+ (BOOL)isEmptyOrNull:(NSString *)string;
@end

#pragma mark - UIColor (YMQ_Utilities)
@interface UIColor (YMQ_Utilities)
+ (UIColor *)colorWithHexString: (NSString *)color;
@end

#pragma mark - UIImage (YMQ_Utilities)

@interface UIImage (YMQ_Utilities)
+ (UIImage *)imageWithPNGlName:(NSString *)name;
+ (UIImage *)imageWithJPGName:(NSString *)name;

/*
 * Stretchable image
 */
- (UIImage *)stretchableImage;
- (UIImage *)stretchableImageWithCenterSize:(CGSize)centerSize;
- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets;
- (UIImage *)scaleImageWithScale:(CGFloat)scaleSize;

- (UIImage *)tintedImageUsingColor:(UIColor *)color;

- (UIImage *)resizeWithSize:(CGSize)newSize;

- (UIImage *)stretchImageForCenter;
- (UIImage *)stretchImageForVertical;
- (UIImage *)stretchImageForAcross;

@end

#pragma mark - UIButton (YMQ_Utilities)

@interface UIButton (YMQ_Utilities)

@property (nonatomic, assign) NSInteger section;

+ (UIButton *)creatBtnWithFram:(CGRect)frame WithNBGIamge:(NSString *)nIamgeName WithHBGImage:(NSString *)hImageName WithTarget:(id)target WithSEL:(SEL)selector;

+ (UIButton *)creatBtnWithFram:(CGRect)frame WithNBGTitle:(NSString *)nTitle WithHTitle:(NSString *)hTitle WithTarget:(id)target WithSEL:(SEL)selector;

- (void)setNormalTitle:(NSString *)normalTitle;
- (void)setHighlightedTitle:(NSString *)highlightedTitle;
- (void)setDisabledTitle:(NSString *)disabledTitle;
- (void)setSelectedTitle:(NSString *)selectedTitle;

- (void)setNormalImage:(UIImage *)normalImage;
- (void)setHighlightedImage:(UIImage *)highlightedImage;
- (void)setSelectedImage:(UIImage *)selectedImage;

- (void)setNormalBgImage:(UIImage *)normalBackgroundImage;
- (void)setHighlightedBgImage:(UIImage *)highlightedBackgroundImage;
- (void)setDisabledBgImage:(UIImage *)disabledBackgroundImage;
- (void)setSelectedBgImage:(UIImage *)selectedBackgroundImage;

- (void)setNormalTitleColor:(UIColor *)normalTitleColor;
- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor;
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor;
- (void)setControlStateTitleColor:(UIColor *)stateTitleColor;

- (UIColor *)normalTitleShadowColor;
- (void)setNormalTitleShadowColor:(UIColor *)normalTitleShadowColor;
- (UIColor *)highlightedTitleShadowColor;
- (void)setHighlightedTitleShadowColor:(UIColor *)highlightedTitleShadowColor;
- (UIColor *)disabledTitleShadowColor;
- (void)setDisabledTitleShadowColor:(UIColor *)disabledTitleShadowColor;
- (UIColor *)selectedTitleShadowColor;
- (void)setSelectedTitleShadowColor:(UIColor *)selectedTitleShadowColor;

///add target/action for particular event.
- (void)touchUpInsideTarget:(id)target action:(SEL)action;
- (void)touchDownTarget:(id)target action:(SEL)action;
- (void)touchUpOutsideTarget:(id)target action:(SEL)action;
@end

#pragma mark - UIImageView (YMQ_Utilities)

@interface UIImageView (YMQ_Utilities)

- (void)setImageName:(NSString *)imageName;
- (void)fillImageView:(NSString *)imageName;

@end

#pragma mark - UILabel (YMQ_Utilities)

@interface UILabel (YMQ_Utilities)

+ (UILabel *)creatLabelWithFrame:(CGRect)frame WithText:(NSString *)text WithFont:(CGFloat)font WithTextColor:(UIColor *)textColor;


- (CGRect)autoResize;
- (CGRect)autoResizeHorizontal;
- (CGRect)autoResizeAcross;
//设置label中不同字体的样式 颜色
- (void)SetTextWithColor:(UIColor *)color WithRange:(NSRange)range;
@end


#pragma mark - NSString (YMQ_Utilities)

@interface NSString (YMQ_Utilities)

+ (BOOL) validateIdentityCard:(NSString *)identityCard;
+ (BOOL) validateNickname:(NSString *)nickname;
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateUserName:(NSString *)name;
+ (BOOL) validateCarNo:(NSString *)carNo;
+ (BOOL) validateEmail:(NSString *)email;
+ (BOOL) validateMobile:(NSString *)mobile;

- (CGFloat)widthWithFont:(UIFont *)font WithHeight:(CGFloat)height;
- (CGFloat)heightWithFont:(UIFont *)font WithWidth:(CGFloat)width;

- (BOOL)isEmptyOrNull;

- (NSDate *)changeToDateWithFormat:(NSString *)format;

- (NSString *)subStringAtLoc:(NSInteger)loc leng:(NSInteger)len;

- (NSString *)UTFEncoded;
- (NSString *)UTFDecoded;
- (NSString *)UFT8Decoded;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end

#pragma mark - UIView (YMQ_Utilities)

@interface UIView (YMQ_Utilities)

- (void)addSwipeWithTarget:(id)target action:(SEL)action;

- (void)removeAllSubviews;

@end

@interface  UINavigationBar (YMQ_Utilities)

@end

#pragma mark - UINavigationController

@interface UINavigationController (YMQ_Utilities)
- (void)setBgImageName:(NSString *)name;
@end

@interface UINavigationItem (YMQ_Utilities)
- (void)setCustomTitle:(NSString *)name;
- (void)setCustomTitleViewWithImage:(NSString *)imageName;
@end


#pragma mark - UIViewController (YMQ_Utilities)

@interface UIViewController (YMQ_Utilities)

- (void)setBackButton;

- (void)setBackBarBtnImage;

- (void)setLeftBarBtnName:(NSString *)title Image:(NSString *)name selector:(SEL)sel;
- (void)setRightBarBtnName:(NSString *)title Image:(NSString *)name selector:(SEL)sel;

- (void)setCustomTitle:(NSString *)name;

- (void)setLandscapeTitle:(NSString *)name;

- (UIBarButtonItem *)barBtnWithTitle:(NSString *)title Image:(NSString *)name action:(SEL)selector;

- (void)loadNormalBG;

- (void)back;

@end

#pragma mark - NSDate (YMQ_Utilities)
@interface NSDate (YMQ_Utilities)

- (NSString *)timeString;
- (NSString *)dateString;
- (NSString *)timeStringWithFormat:(NSString *)format;
- (NSString *)monthDayFromString;

//该月的最后一天
- (NSDate *)endOfMonth;

//返回该月的第一天
- (NSDate *)beginningOfMonth;
//获取日
- (NSUInteger)getDay;
//获取该月第几周
- (NSInteger)getWeekOfMonth;
//获取该年第几周
- (NSInteger)getWeekOfYear;
//获取年
- (NSUInteger)getYear;
//获取月
- (NSUInteger)getMonth;

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(NSInteger)day;

//month个月后的日期
- (NSDate *)dateafterMonth:(NSInteger)month;
//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday ;

//是否闰年
- (BOOL)isLeapYear;//

+ (NSString *)getMonthBeginAndEndWith:(NSDate *)newDate Type:(NSCalendarUnit)type;

@end

@interface MyUtil : NSObject

+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:target
                        title:(NSString *)title
                       action:(SEL)selector;

//+ (id)chkUpdateEventHandle:(id)handle;

+ (BOOL)isValidURL:(NSString *)urlString;


+ (id)getObjectFromClassName:(NSString *)className;

+ (BOOL)checkNetIsConnect;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGRect)screenFrame;
//获取当前时间
+ (NSString *)GetNowTime;
//当前日期
+(NSString *)GetNowDate;
+(NSString *)GetNowYearAndMonth;
+(NSString *)GetNowYear;

+ (NSString *)timeIntervalString;

+ (NSString *)threeDaysAfter;
+ (NSString *)dayStringAfter:(NSInteger)days;

+ (BOOL)isIphone5;
+ (BOOL)isIOS7OrLater;

+ (void)showMessageBox:(NSString *)message;
+ (void)showAlert:(NSString *)message;
+ (void)showAlert:(NSString *)message
         delegate:(id <UIAlertViewDelegate>)delegate;
+ (void)showAlert:(NSString *)message
         delegate:(id <UIAlertViewDelegate>)delegate
           button:(NSString *)button;
+ (UIAlertView *)showAlert:(NSString *)message
                  delegate:(id <UIAlertViewDelegate>)delegate
                   button1:(NSString *)button1
                   button2:(NSString *)button2;
+ (CGFloat)viewHeight;

+ (void)createProgressDialog:(UIView *)superView;
+ (void)closeProgressDialog:(UIView *)superView;
+ (void)createLandscapeProgressDialog:(UIView *)superView;

+(NSString *)getWeekdayFromString:(NSString *)string;
+ (NSInteger)getWeekdayFlagFromString:(NSString *)string;
+ (NSString *)getStringFromFlag:(NSInteger)flag;
+ (NSString *)getStringFromDate:(NSDate *)date;
+ (NSDate *)getDateFromString:(NSString *)string;

//----对沙河目录下的操作----
+ (NSString *)getDocumentsPath;
+ (NSString *)getCachePath;
+ (NSString *)getTmpPath;
+ (void)createFileInSandboxWithName:(NSString *)name;

+ (void) showAlertWithContent:(NSString*)content BtnText1:(NSString*)text1 Action1:(void(^)(void))action1 BtnText2:(NSString*)text2 Action2:(void(^)(void))action2;
@end
