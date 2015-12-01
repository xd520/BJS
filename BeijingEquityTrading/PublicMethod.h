//
//  PublicMethod.h
//  常用方法集合
//
//  Created by mac on 15/9/11.
//  Copyright (c) 2015年 ApexSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PublicMethod : NSObject

+ (NSString *)convertArrayToString:(NSArray *)array;
+ (NSArray *)convertURLToArray:(NSString *)string;
+ (NSURL *)suburlString:(NSURL *)urlString;
+ (NSArray *)convertStringToArray:(NSString *)string;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)validateCellPhone:(NSString *)candidate;
+ (long)getDocumentSize:(NSString *)documentsDirectory;
+ (NSArray *)getLetters;
+ (NSArray *)getUpperLetters;
+ (NSString *)getIPAddress;
+ (NSString *)getFreeMemory;
+ (NSString *)getDiskUsed;
+ (NSString *)getStringValue:(id)value;
+ (BOOL)createDirectorysAtPath:(NSString *)path;
+ (NSString*)getDirectoryPathByFilePath:(NSString *)filepath;
+ (NSString *)GetImageIdentify;
+ (NSString *)MD5:(NSString *)srcString;
+ (UIView *)getSepratorLine:(CGRect )rect alpha:(CGFloat)alpha;



+ (float) getStringWidth:(NSString *)str font:(UIFont *)font;
+ (float) getStringHeight:(NSString *)str font:(UIFont *)font;
+ (float) getStringHeight:(NSString *)str font:(UIFont *)font with:(float)witht;
+ (CGSize) getStringSize:(NSString *)str font:(UIFont *)font;

//还没开始测试
+ (UIControl *) CreateControl:(CGRect)frame tag:(int)tag target:(id)target;
+ (void) trimSpecialCharacters:(NSString **)unFilterString;
+ (void) saveToUserDefaults:(id) object key: (NSString *)key;
+ (id) userDefaultsValueForKey:(NSString*) key;
+ (void) filterString:(NSString **)unfilteredString;
+ (void) filterNumber:(NSString **)unfilteredString;

+ (NSData *) convertImageToCapacity:(UIImage *)image capacity:(int)capacity;
+ (BOOL) validateIdentityCard: (NSString *)sPaperId;
+ (BOOL) isAdultManByIdentifyCard:(NSString *)identifyCard;
+ (BOOL) isCardValidByYXQ:(NSString *)yxqText;
+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger )value1 Value2:(NSInteger )value2;
+ (BOOL)areaCode:(NSString *)code;
+ (void) CaculateImageKBs:(UIImage *)image capacity:(int)capacity;
+ (NSData *) compressImage:(UIImage *)image;
+ (void) hideGradientBackground:(UIView*)theView;
+ (BOOL) fileManageCopyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
+ (NSString*) getDeviceType;
+ (NSString *) getSysInfoByName:(char *)typeSpecifier;
+ (NSString*) GetMacAddress;
+ (NSArray *)backtrace;
+ (NSString *)getOperationName;
+ (NSInteger) getOPeratorType;
+ (NSString *)sha1:(NSString *)str;
+ (NSString *)md5Hash:(NSString *)str;
+ (NSString *)trimSpaceAndNewLine:(NSString *)text;
+ (int) onGetDaysInPreviousMonth;
+ (NSString *)onGetJSONStringWithDictionary:(NSDictionary *)dic;
+ (CGSize)makeSize:(CGSize)originalSize fitInSize:(CGSize)boxSize;
+ (NSMutableArray *)getUserContacts;
+ (CGPoint)getBd:(double) longitude andwd:(double) latitude;

@end
