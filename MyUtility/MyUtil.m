//
//  MyUtil.m
//  HotelManager
//
//  Created by Dragon Huang on 13-4-26.
//  Copyright (c) 2013年 baiwei.Yuan Wen. All rights reserved.
//

#import "MyUtil.h"
#import <objc/runtime.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>
#import "sys/utsname.h"
@import CoreText;

#pragma mark - StringUtils

@implementation StringUtils
+ (BOOL)isEmptyOrNull:(NSString *)string
{
    
    BOOL isEmptyOrNull = YES;
    if (![string isEqual:[NSNull null]] && string != nil && string.length != 0) {
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        NSArray *parts = [string componentsSeparatedByString:@" "];
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        string = [filteredArray componentsJoinedByString:@""];
        if (string.length > 0) {
            isEmptyOrNull = NO;
        }
    }
    return isEmptyOrNull;
}
@end

@implementation UIColor (YMQ_Utilities)
#pragma mark 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:1.0f];
    
}

@end

#pragma mark UIImage (YMQ_Utilities)

@implementation UIImage (YMQ_Utilities)

+ (UIImage *)imageWithJPGName:(NSString *)name
{
    NSString *path = nil;
    if ( [name isAbsolutePath] ) {
        path = name;
    } else {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    }
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageWithPNGName:(NSString *)name
{
    NSString *path = nil;
    if ( [name isAbsolutePath] ) {
        path = name;
    } else {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    }
    return [UIImage imageWithContentsOfFile:path];
}

- (UIImage *)stretchableImage
{
    CGFloat hSpacing = floor((self.size.width+1.0)/2.0)-1.0;
    hSpacing = MAX(0.0, hSpacing);
    CGFloat vSpacing = floor((self.size.height+1.0)/2.0)-1.0;
    vSpacing = MAX(0.0, vSpacing);
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vSpacing, hSpacing, vSpacing, hSpacing);
    return [self stretchableImageWithCapInsets:edgeInsets];
}

- (UIImage *)stretchableImageWithCenterSize:(CGSize)centerSize
{
    CGFloat hSpacing = floor((self.size.width - centerSize.width)/2.0);
    CGFloat vSpacing = floor((self.size.height - centerSize.height)/2.0);
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(vSpacing, hSpacing, vSpacing, hSpacing);
    return [self stretchableImageWithCapInsets:edgeInsets];
}

- (UIImage *)stretchableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(floor(capInsets.top),
                                               floor(capInsets.left),
                                               floor(capInsets.bottom),
                                               floor(capInsets.right));
    
    CGFloat systemVersion = [[[[UIDevice class] currentDevice] systemVersion] floatValue];
    if ( systemVersion < 5.0 ) {
        return [self stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top];
    }

    return [self resizableImageWithCapInsets:edgeInsets];
}

- (UIImage *)scaleImageWithScale:(CGFloat)scaleSize {
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)tintedImageUsingColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(self.size);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    [self drawInRect:rect];
    
    [color set];
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceAtop);
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (UIImage *)resizeWithSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)stretchImageForCenter
{
    UIImage *newImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height/2, self.size.width/2, self.size.height/2, self.size.width/2)];
    return newImage;
}

- (UIImage *)stretchImageForVertical
{
    UIImage *newImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height, self.size.width/2, 0, self.size.width/2)];
    return newImage;
}

- (UIImage *)stretchImageForAcross
{
    UIImage *newImage = [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height/2, self.size.width, self.size.height/2, 0)];
    return newImage;
}

- (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius WithSize:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     path.CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}

@end

#pragma mark - UIButton (YMQ_Utilities)

@implementation UIButton (YMQ_Utilities)

static char const * const sectionKey = "kUIButtonSectionKey";

@dynamic section;

- (NSInteger)section{
    NSNumber *section = objc_getAssociatedObject(self, sectionKey);
    return [section intValue];
}

- (void)setSection:(NSInteger)section
{
    objc_setAssociatedObject(self, sectionKey, [NSNumber numberWithInteger:section], OBJC_ASSOCIATION_ASSIGN);
}

+ (UIButton *)creatBtnWithFram:(CGRect)frame WithNBGIamge:(NSString *)nIamgeName WithHBGImage:(NSString *)hImageName WithTarget:(id)target WithSEL:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setNormalBgImage:[UIImage imageWithPNGName:nIamgeName]];
    [btn setHighlightedBgImage:[UIImage imageWithPNGName:hImageName]];
    [btn touchUpInsideTarget:target action:selector];
    return btn;
}

+ (UIButton *)creatBtnWithFram:(CGRect)frame WithNBGTitle:(NSString *)nTitle WithHTitle:(NSString *)hTitle WithTarget:(id)target WithSEL:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setNormalTitle:nTitle];
    [btn setHighlightedTitle:hTitle];
    [btn touchUpInsideTarget:target action:selector];
    return btn;
}

- (void)setNormalTitle:(NSString *)normalTitle
{
    [self setTitle:normalTitle forState:UIControlStateNormal];
}

- (void)setHighlightedTitle:(NSString *)highlightedTitle
{
    [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
}

- (void)setDisabledTitle:(NSString *)disabledTitle
{
    [self setTitle:disabledTitle forState:UIControlStateDisabled];
}

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (void)setNormalImage:(UIImage *)normalImage
{
    [self setImage:normalImage forState:UIControlStateNormal];
}

- (void)setHighlightedImage:(UIImage *)highlightedImage
{
    [self setImage:highlightedImage forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    [self setImage:selectedImage forState:UIControlStateSelected];
}

- (void)setNormalBgImage:(UIImage *)normalBackgroundImage
{
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
}

- (void)setHighlightedBgImage:(UIImage *)highlightedBackgroundImage
{
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (void)setDisabledBgImage:(UIImage *)disabledBackgroundImage
{
    [self setBackgroundImage:disabledBackgroundImage forState:UIControlStateDisabled];
}

- (void)setSelectedBgImage:(UIImage *)selectedBackgroundImage
{
    [self setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (UIColor *)normalTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateNormal];
}
- (void)setNormalTitleShadowColor:(UIColor *)normalTitleShadowColor
{
    [self setTitleShadowColor:normalTitleShadowColor forState:UIControlStateNormal];
}

- (UIColor *)highlightedTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateHighlighted];
}
- (void)setHighlightedTitleShadowColor:(UIColor *)highlightedTitleShadowColor
{
    [self setTitleShadowColor:highlightedTitleShadowColor forState:UIControlStateHighlighted];
}

- (UIColor *)disabledTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateDisabled];
}
- (void)setDisabledTitleShadowColor:(UIColor *)disabledTitleShadowColor
{
    [self setTitleShadowColor:disabledTitleShadowColor forState:UIControlStateDisabled];
}

- (UIColor *)selectedTitleShadowColor
{
    return [self titleShadowColorForState:UIControlStateSelected];
}
- (void)setSelectedTitleShadowColor:(UIColor *)selectedTitleShadowColor
{
    [self setTitleShadowColor:selectedTitleShadowColor forState:UIControlStateSelected];
}

- (void)setControlStateTitleColor:(UIColor *)stateTitleColor
{
    [self setNormalTitleColor:stateTitleColor];
    [self setHighlightedTitleColor:stateTitleColor];
    [self setSelectedTitleColor:stateTitleColor];
}

- (void)touchUpInsideTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchDownTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
}

- (void)touchUpOutsideTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpOutside];
}

@end

#pragma mark - UIImageView (YMQ_Utilities)

@implementation UIImageView (YMQ_Utilities)

- (void)setImageName:(NSString *)imageName
{
    UIImage *newImage = [UIImage imageWithPNGName:imageName];
    self.image = newImage;
}

- (void)fillImageView:(NSString *)imageName
{
    UIImage *newImage = [UIImage imageWithPNGName:imageName];
    self.backgroundColor = [UIColor colorWithPatternImage:newImage];
}

- (void)addCorner:(CGFloat)radius
{
    if (self.image)
    {
        self.image = [self.image drawRectWithRoundedCorner:radius WithSize:self.bounds.size];
    }
}

@end

#pragma mark - UILabel (YMQ_Utilities)

@implementation UILabel (YMQ_Utilities)

+ (UILabel *)creatLabelWithFrame:(CGRect)frame WithText:(NSString *)text WithFont:(CGFloat)font WithTextColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    [label setTextTypeWithFont:font WithColor:textColor WithLineHeight:0];
    return label;
}


- (CGRect)autoResizeAcross
{
    CGFloat width = self.frame.size.width;
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    return rect;
}

- (void)SetTextWithColor:(UIColor *)color WithRange:(NSRange)range
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.attributedText = str;
}

- (void)setTextTypeWithFont:(CGFloat)font WithColor:(UIColor *)textColor WithLineHeight:(CGFloat)lineHeight
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineHeight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, [self.text length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
    
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(self.bounds.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    CGRect frame = self.frame;
    frame.size.height = rect.size.height;
    self.frame = frame;
    
    [self sizeToFit];
}

@end

#pragma mark - NSString (YMQ_Utilities)

@implementation NSString (YMQ_Utilities)

//身份证号
+ (BOOL) validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}

//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//账号
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];

    return [carTest evaluateWithObject:carNo];
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL) validateNum:(NSString *)str
{
    //^-?(0|[1-9]\d*)(\.\d+[^0])?$ 合法实数
    NSString *regex = @"^-?(0|[1-9]\\d*)(\\.\\d{0,2})?$"; //保留两位小数
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        
        return NO;
    }
    return YES;
}

- (CGFloat)widthWithFont:(UIFont *)font WithHeight:(CGFloat)height
{

    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
    CGFloat width = rect.size.width;
    return width;
}

- (CGFloat)heightWithFont:(UIFont *)font WithWidth:(CGFloat)width
{

    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    CGFloat height = rect.size.height;
    return height;
}

- (BOOL)isEmptyOrNull
{
    BOOL isEmptyOrNull = YES;
    if (![self isEqual:[NSNull null]] && self != nil && self.length != 0) {
        NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
        NSArray *parts = [self componentsSeparatedByString:@" "];
        NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
        NSString *tempString = [filteredArray componentsJoinedByString:@""];
        if (tempString.length > 0) {
            isEmptyOrNull = NO;
        }
    }
    return isEmptyOrNull;
}

- (NSDate *)changeToDateWithFormat:(NSString *)format;
{
    NSDateFormatter *formattor = [[NSDateFormatter alloc]init];
    [formattor setDateFormat:format];
    NSDate *date = [formattor dateFromString:self];
    return date;
}

- (NSString *)subStringAtLoc:(NSInteger)loc leng:(NSInteger)len
{
    return [self substringWithRange:NSMakeRange(loc, len)];
}

- (NSString *)UTFEncoded {
    if (![self canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        
        return [[NSString alloc] initWithData:[self dataUsingEncoding:NSNonLossyASCIIStringEncoding] encoding:NSASCIIStringEncoding];
    }
    return self;
}

- (NSString *)UTFDecoded {
    return [[NSString alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding] encoding:NSNonLossyASCIIStringEncoding];
}

- (NSString *)UFT8Decoded
{
    return [[NSString alloc] initWithData:[self dataUsingEncoding:NSUTF8StringEncoding] encoding:NSUTF8StringEncoding];
    
}

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
	return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));

	return result;
}

@end

#pragma mark - UIView (DH_Utilities)

@implementation UIView (HL_Utilities)

- (void)addSwipeWithTarget:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:recognizer];
    recognizer.delegate = target;
	
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:recognizer];
    
}


- (void)removeAllSubviews
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end

#pragma mark - UINavigationController

@implementation UINavigationController (YMQ_Utilities)
- (void)setBgImageName:(NSString *)name
{
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageWithPNGName:name] forBarMetrics:UIBarMetricsDefault];
        
    }
}
@end

@implementation UINavigationItem (YMQ_Utilities)

- (void)setCustomTitle:(NSString *)name
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    title.textColor = RGBCOLOR(80, 103, 116);
    title.text = name;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.backgroundColor = [UIColor clearColor];
    self.titleView = title;
    
}

- (void)setCustomTitleViewWithImage:(NSString *)imageName
{
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:self.titleView.frame];
    [titleImageView setImageName:imageName];
    self.titleView = titleImageView;
    
}

@end

@implementation UINavigationBar (YMQ_Utilities)

- (void)drawRect:(CGRect)rect {
    
    [[self barBackground] drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height )];
	
	
}
- (UIImage *)barBackground
{
    if ([MyUtil isIOS7OrLater])
    {
        return [UIImage imageWithPNGName:@"top_xingshiguiji120"];
    }
    else
    {
        return [UIImage imageWithPNGName:@"top_xingshiguiji88"];
    }
    
}

- (void)didMoveToSuperview
{

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    if ([MyUtil isIOS7OrLater])
    {
        [[UINavigationBar appearance] setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    } else
    {
        
        [[UINavigationBar appearance] setBackgroundImage:[self barBackground]
                                           forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:4.0f
                                                          forBarMetrics:UIBarMetricsDefault];
        
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:51.0/255.0
                                                                   green:143.0/255.0
                                                                    blue:210.0/255.0
                                                                   alpha:1]];
        
    }

}

@end

@implementation UIViewController (YMQ_Utilities)

- (void)setBackBarBtnImage
{

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] init];
    [backBarButton setBackButtonBackgroundImage:[[UIImage imageWithPNGName:@"back_01"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 15, 4)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backBarButton setBackButtonBackgroundImage:[[UIImage imageWithPNGName:@"back_02"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 15, 4)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    
    self.navigationController.navigationItem.backBarButtonItem = backBarButton;
}

- (void)setBackButton
{
    [self setLeftBarBtnName:@"返回" Image:nil selector:@selector(back)];
}


- (void)setLeftBarBtnName:(NSString *)title Image:(NSString *)name selector:(SEL)sel
{
    self.navigationItem.leftBarButtonItem = [self barBtnWithTitle:title Image:name action:sel];
    
}


- (UIBarButtonItem *)barBtnWithTitle:(NSString *)title Image:(NSString *)name action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setNormalBgImage:[UIImage imageWithPNGName:name]];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchCancel];
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return btnItem;
}


- (void)setRightBarBtnName:(NSString *)title Image:(NSString *)name selector:(SEL)sel
{
    self.navigationItem.rightBarButtonItem  = [self barBtnWithTitle:title Image:name action:sel];
}

- (void)back
{
    if (self.navigationController.viewControllers[0] == self)
    {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setCustomTitle:(NSString *)name
{
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    title.textColor = RGBCOLOR(80, 103, 116);
    title.text = name;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:22];
    title.backgroundColor = [UIColor clearColor];
    title.textColor=[UIColor whiteColor];
    self.navigationItem.titleView = title;
    
}


- (void)setLandscapeTitle:(NSString *)name
{
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    title.textColor = RGBCOLOR(80, 103, 116);
    title.text = name;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:17];
    title.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = title;
    
}


- (void)loadNormalBG
{
    self.view.backgroundColor = RGBCOLOR(236, 236, 236);
}

@end
#pragma mark - NSDate (YMQ_Utilities)
static NSDateFormatter *_internetDateTimeFormatter = nil;
@implementation NSDate (YMQ_Utilities)

- (NSString *)timeString
{
    NSString *string = [self timeStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    return string;
}

- (NSString *)timeStringWithFormat:(NSString *)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSString *string = [df stringFromDate:self];
    
    return string;
}

- (NSString *)monthDayFromString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd"];
    NSString *dateString = [df stringFromDate:self];
    
    return dateString;
}

- (NSString *)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [df stringFromDate:self];
    
    return dateString;
}


//month个月后的日期
- (NSDate *)dateafterMonth:(NSInteger)month
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	[componentsToAdd setMonth:month];
	NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	
	return dateAfterMonth;
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(NSInteger)day
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	// Get the weekday component of the current date
	// NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:day];
	NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
	
	return dateAfterDay;
}

//获取月
- (NSUInteger)getMonth
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self];
	return [dayComponents month];
}

//获取年
- (NSUInteger)getYear
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self];
	return [dayComponents year];
}

//获取该月是第几周
- (NSInteger)getWeekOfMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self];
	return [dayComponents weekOfMonth];
}

//获取该年是第几周
- (NSInteger)getWeekOfYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self];
    return [dayComponents weekOfYear];
}

//获取日
- (NSUInteger)getDay{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:self];
	return [dayComponents day];
}

//返回该月的第一天
- (NSDate *)beginningOfMonth
{
	return [self dateAfterDay:-[self getDay] + 1];
}

//该月的最后一天
- (NSDate *)endOfMonth
{
	return [[[self beginningOfMonth] dateafterMonth:1] dateAfterDay:-1];
}

//返回一周的第几天(周末为第一天)
- (NSUInteger)weekday {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
	return [weekdayComponents weekday];
}

//是闰年
- (BOOL)isLeapYear
{
    BOOL isLeapYear = NO;
    
    NSInteger year = [self getYear];
    //被400乘除
    if (year % 400 == 0 )
    {
        isLeapYear = YES;
    }
    else
    {
        //不被100整除但被4整除
        if (year % 100 != 0 && year % 4 == 0) {
            isLeapYear = YES;
        }
    }
    
    return isLeapYear;
}

+ (NSString *)getMonthBeginAndEndWith:(NSDate *)newDate Type:(NSCalendarUnit)type
{
    if (newDate == nil) {
        newDate = [NSDate date];
    }
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:type startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    
    
    NSString *resultStr = [NSString stringWithFormat:@"%@~%@",beginString,endString];
    
    return resultStr;
}

+ (NSDateFormatter *)internetDateTimeFormatter {
    @synchronized(self) {
        if (!_internetDateTimeFormatter) {
            NSLocale *en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            _internetDateTimeFormatter = [[NSDateFormatter alloc] init];
            [_internetDateTimeFormatter setLocale:en_US_POSIX];
            [_internetDateTimeFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
        }
    }
    return _internetDateTimeFormatter;
}

// Get a date from a string - hint can be used to speed up
+ (NSDate *)dateFromInternetDateTimeString:(NSString *)dateString formatHint:(DateFormatHint)hint {
    // Keep dateString around a while (for thread-safety)
    NSDate *date = nil;
    if (dateString) {
        if (hint != DateFormatHintRFC3339) {
            // Try RFC822 first
            date = [NSDate dateFromRFC822String:dateString];
            if (!date) date = [NSDate dateFromRFC3339String:dateString];
        } else {
            // Try RFC3339 first
            date = [NSDate dateFromRFC3339String:dateString];
            if (!date) date = [NSDate dateFromRFC822String:dateString];
        }
    }
    // Finished with date string
    return date;
}

// See http://www.faqs.org/rfcs/rfc822.html
+ (NSDate *)dateFromRFC822String:(NSString *)dateString {
    // Keep dateString around a while (for thread-safety)
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [NSDate internetDateTimeFormatter];
        @synchronized(dateFormatter) {
            
            // Process
            NSString *RFC822String = [[NSString stringWithString:dateString] uppercaseString];
            if ([RFC822String rangeOfString:@","].location != NSNotFound) {
                if (!date) { // Sun, 19 May 2002 15:21:36 GMT
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21 GMT
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21:36
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // Sun, 19 May 2002 15:21
                    [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
            } else {
                if (!date) { // 19 May 2002 15:21:36 GMT
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21 GMT
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm zzz"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21:36
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm:ss"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
                if (!date) { // 19 May 2002 15:21
                    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
                    date = [dateFormatter dateFromString:RFC822String];
                }
            }
            if (!date) NSLog(@"Could not parse RFC822 date: \"%@\" Possible invalid format.", dateString);
            
        }
    }
    // Finished with date string
    return date;
}

// See http://www.faqs.org/rfcs/rfc3339.html
+ (NSDate *)dateFromRFC3339String:(NSString *)dateString {
    // Keep dateString around a while (for thread-safety)
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [NSDate internetDateTimeFormatter];
        @synchronized(dateFormatter) {
            
            // Process date
            NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
            RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
            // Remove colon in timezone as it breaks NSDateFormatter in iOS 4+.
            // - see https://devforums.apple.com/thread/45837
            if (RFC3339String.length > 20) {
                RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":"
                                                                         withString:@""
                                                                            options:0
                                                                              range:NSMakeRange(20, RFC3339String.length-20)];
            }
            if (!date) { // 1996-12-19T16:39:57-0800
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27.87+0020
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) { // 1937-01-01T12:00:27
                [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
                date = [dateFormatter dateFromString:RFC3339String];
            }
            if (!date) NSLog(@"Could not parse RFC3339 date: \"%@\" Possible invalid format.", dateString);
            
        }
    }
    // Finished with date string
    return date;
}

@end

#pragma mark - MyUtil

@implementation MyUtil

+ (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);    
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                       target:target
                  title:(NSString *)title
                 action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


+ (BOOL)isValidURL:(NSString *)urlString
{
    
    NSString * regex = @"(https?:\\/\\/)?([A-Za-z0-9\\.-]+\\.[A-Za-z]{2,3}|\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})(\\/[A-Za-z0-9\\._]*)*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:urlString];
    
    return isMatch;
}


//判断本地网络是否打开
+(BOOL)checkNetIsConnect
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"dipinkrishna.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
        return TRUE;
    }
}

+(CGFloat)screenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}
+(CGFloat)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height - 20;
    
}
+ (CGRect)screenFrame
{
    return [[UIScreen mainScreen] bounds];
}
+ (CGFloat)viewHeight
{
    return [self screenHeight];
}

+ (NSString *)timeIntervalString
{
    NSDate* now = [NSDate date];

    NSTimeInterval timeIntervalString = [now timeIntervalSince1970];
 
    return [NSString stringWithFormat:@"%.0lf",timeIntervalString];
}

+(NSString *)GetNowTime{
    
    NSDateFormatter *tempDate = [[NSDateFormatter alloc]init];
    [tempDate setLocale:[NSLocale currentLocale]];
    
    [tempDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//24小时制
    
    NSDate* now = [NSDate date];
    NSString *tempDatestring = [tempDate stringFromDate:now];
    
    
    return tempDatestring;

}

+(NSString *)GetNowDate
{
    NSDateFormatter *tempDate = [[NSDateFormatter alloc]init];
    [tempDate setLocale:[NSLocale currentLocale]];
    
    [tempDate setDateFormat:@"yyyy-MM-dd"];//
    
    NSDate* now = [NSDate date];
    NSString *tempDatestring = [tempDate stringFromDate:now];
    
    
    return tempDatestring;
}

+(NSString *)GetNowYear
{
    NSDateFormatter *tempDate = [[NSDateFormatter alloc]init];
    [tempDate setLocale:[NSLocale currentLocale]];
    
    [tempDate setDateFormat:@"yyyy年"];//
    
    NSDate* now = [NSDate date];
    NSString *tempDatestring = [tempDate stringFromDate:now];
    
    
    return tempDatestring;
}

+(NSString *)GetNowYearAndMonth
{
    NSDateFormatter *tempDate = [[NSDateFormatter alloc]init];
    [tempDate setLocale:[NSLocale currentLocale]];
    
    [tempDate setDateFormat:@"yyyy年MM月"];//
    
    NSDate* now = [NSDate date];
    NSString *tempDatestring = [tempDate stringFromDate:now];
    

    return tempDatestring;
}


+ (NSString *)threeDaysAfter
{
    NSDateFormatter *tempDate = [[NSDateFormatter alloc]init];
    [tempDate setLocale:[NSLocale currentLocale]];
    
    [tempDate setDateFormat:@"yyyy-MM-dd"];//
    
    NSDate* threeDaysAfter = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 2];
    NSString *tempDatestring = [tempDate stringFromDate:threeDaysAfter];
    
    
    return tempDatestring;
}

+ (NSString *)dayStringAfter:(NSInteger)days
{
    NSDateFormatter *tempDate = [[NSDateFormatter alloc]init];
    [tempDate setLocale:[NSLocale currentLocale]];
    
    [tempDate setDateFormat:@"yyyy-MM-dd"];//
    
    NSDate* threeDaysAfter = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * days];
    NSString *tempDatestring = [tempDate stringFromDate:threeDaysAfter];
    
    
    return tempDatestring;
}

+ (BOOL)isIphone5
{
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO);
}

+ (BOOL)isIOS7OrLater
{
    return [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0;
}

+ (void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (UIAlertView *)showAlert:(NSString *)message
         delegate:(id <UIAlertViewDelegate>)delegate
          button1:(NSString *)button1
          button2:(NSString *)button2
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message delegate:delegate
                                          cancelButtonTitle:button1
                                          otherButtonTitles:button2, nil];
    
    [alert show];
    return alert;
}

+ (void)showAlert:(NSString *)message
         delegate:(id <UIAlertViewDelegate>)delegate
           button:(NSString *)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message delegate:delegate
                                          cancelButtonTitle:button
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

+ (void)showAlert:(NSString *)message delegate:(id <UIAlertViewDelegate>)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message delegate:delegate
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    
    [alert show];
}

+ (void)showMessageBox:(NSString *)message
{
    if ([theAppWindow viewWithTag:99999]) {
        [[theAppWindow viewWithTag:99999] removeFromSuperview];
    }
    [self initAlertLabel:message hidden:YES];
}

+ (void)initAlertLabel:(NSString *)message hidden:(BOOL)hidden
{
    UIFont *font = [UIFont systemFontOfSize:14];
    //CGFloat width = [message widthWithFont:font];
    CGFloat height = [message heightWithFont:font WithWidth:300];
    if (height > 30) {
        height+= 10;
    }else {
        height = 30;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64, 300, height)];
    label.backgroundColor = [UIColor grayColor];
    label.alpha = 1.0;
    label.text = message;
    label.font = font;
    label.layer.cornerRadius = 5.0f;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label.layer.borderWidth = 1.0f;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.tag = 99999;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    //label.center = theAppWindow.center;
    [theAppWindow addSubview:label];

    if (hidden) {
        [UIView animateWithDuration:4.5
                         animations:^{
                             if (label) {
                                 label.alpha = 0.2;
                             }
                         }
                         completion:^(BOOL finish){
                             if (label) {
                                 [label removeFromSuperview];
                             }
                         }];
    }
}

+ (void)createProgressDialog:(UIView *)superView
{
    UIImageView *bg = (UIImageView *) [superView viewWithTag:999999];
    
    if (bg)
    {
        return;
    }
    
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(superView.frame))];
    bg.backgroundColor = [UIColor blackColor];
    bg.tag = 999999;
    bg.alpha = 0.2;
    //    bg.image = [UIImage imageNamed:@"bg_subviews"];
    bg.userInteractionEnabled = YES;
    [superView addSubview:bg];
    
    
    UIActivityIndicatorView *progressdialog = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    progressdialog.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    progressdialog.center = bg.center;
    [bg addSubview:progressdialog];
    
    [progressdialog startAnimating];
}

+ (void)createLandscapeProgressDialog:(UIView *)superView
{
    UIImageView *bg = (UIImageView *) [superView viewWithTag:999999];
    
    if (bg)
    {
        return;
    }
    
    bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(superView.frame), 320)];
    bg.backgroundColor = [UIColor blackColor];
    bg.tag = 999999;
    bg.alpha = 0.2;
    //    bg.image = [UIImage imageNamed:@"bg_subviews"];
    bg.userInteractionEnabled = YES;
    [superView addSubview:bg];
    
    
    UIActivityIndicatorView *progressdialog = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    progressdialog.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    progressdialog.center = bg.center;
    [bg addSubview:progressdialog];
    
    [progressdialog startAnimating];
}


+ (void)closeProgressDialog:(UIView *)superView
{
    UIImageView *bg = (UIImageView *) [superView viewWithTag:999999];
    if (bg)
    {
        [bg removeFromSuperview];
    }
}

+ (NSInteger)getWeekdayFlagFromString:(NSString *)string
{
    NSDate *date = [self dateFromString:string format:@"yyyy-MM-dd"];
    
    NSInteger flag = [self getWeekdayFromDate:date];
    
    return flag;
}

+ (NSString *)getStringFromFlag:(NSInteger)flag
{
    NSString *weekday = @"";
    switch (flag) {
        case 1:
            weekday = @"星期日";
            break;
        case 2:
            weekday = @"星期一";
            break;
        case 3:
            weekday = @"星期二";
            break;
        case 4:
            weekday = @"星期三";
            break;
        case 5:
            weekday = @"星期四";
            break;
        case 6:
            weekday = @"星期五";
            break;
        case 0:
            weekday = @"星期六";
            break;
            
        default:
            break;
    }
    return weekday;
}

+(NSString *)getWeekdayFromString:(NSString *)string
{
    NSDate *date = [self dateFromString:string format:@"yyyy-MM-dd"];
    
    NSUInteger flag = [self getWeekdayFromDate:date];
    
    NSString *weekday = @"";
    switch (flag) {
        case 1:
            weekday = @"周日";
            break;
        case 2:
            weekday = @"周一";
            break;
        case 3:
            weekday = @"周二";
            break;
        case 4:
            weekday = @"周三";
            break;
        case 5:
            weekday = @"周四";
            break;
        case 6:
            weekday = @"周五";
            break;
        case 0:
            weekday = @"周六";
            break;
            
        default:
            break;
    }
    return weekday;
}


+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSDate *fromdate=[df dateFromString:string];
    
    return fromdate;
}

+ (NSUInteger)getWeekdayFromDate:(NSDate *)date
{
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit;
    
    NSDateComponents* components = [calendar components:unitFlags fromDate:date];
    NSUInteger weekday = [components weekday];
    
    return weekday;
}


+ (NSString *)getStringFromDate:(NSDate *)date
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [df stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)getDateFromString:(NSString *)string
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df dateFromString:string];
    
    return date;
}

+ (NSString *)getDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    return path;
}

+ (NSString *)getCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    return path;
}

+ (NSString *)getTmpPath;
{
    NSString *path = NSTemporaryDirectory();

    return path;
}

+ (void)createFileInSandboxWithName:(NSString *)name
{
    NSString *homeDir = NSHomeDirectory();
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",homeDir,name];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath])
    {
        [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)showAlertWithContent:(NSString*)content BtnText1:(NSString*)text1 Action1:(void(^)(void))action1 BtnText2:(NSString*)text2 Action2:(void(^)(void))action2
{
    RIButtonItem* btn1 = nil;
    RIButtonItem* btn2 = nil;
    
    if(text1)
    {
        btn1 = [RIButtonItem itemWithLabel:text1 action:action1];
    }
    
    if(text1)
    {
        btn2 = [RIButtonItem itemWithLabel:text2 action:action2];
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:content cancelButtonItem:btn1 otherButtonItems:btn2, nil];
    
    [alertView show];
}

+ (NSString*)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}

@end
