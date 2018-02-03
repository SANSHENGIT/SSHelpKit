//
// Created by 李飞恒 on 2018/2/3.
// Copyright (c) 2018 SANSHENG TECHONLOGY LLC admin@sansehngit.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSApiConfiguration.h"

typedef void (^UtilCompletioBlock)(id data, NSURLResponse *response, NSError *error);
typedef void (^UtilSuccessBlock)(id data);
typedef void (^UtilFailureBlock)(NSError *error);

#define CZOLCMUtilCompletioBlock    UtilCompletioBlock
#define CZOLCMUtilSuccessBlock      UtilSuccessBlock
#define CZOLCMUtilFailureBlock      UtilFailureBlock

#define CZOLCMRespondHandler success:(CZOLCMUtilSuccessBlock)successBlock failure:(CZOLCMUtilFailureBlock)failureBlock

#define CZOLMethodGET (0)
#define CZOLMethodPOST (1)
typedef NS_ENUM(NSInteger, CZOLMethod) {
    GET = CZOLMethodGET,
    POST = CZOLMethodPOST
};


#define kAPIHOST setHost:[[SSApiConfiguration sharedInstance] getHost]

@interface SSHTTP : NSObject


/** HOST */
@property (copy,   nonatomic, readonly) NSString *host;
/** URL路由 */
@property (copy,   nonatomic, readonly) NSString *url;
/** 请求参数 */
@property (strong, nonatomic, readonly) NSDictionary *parameters;

/** 用于无key参数请求 */
@property (copy, nonatomic) NSString *requestPara;

- (instancetype)initWithMethod:(CZOLMethod)method url:(NSString *)url CZOLCMRespondHandler;
- (instancetype)initWithMethod:(CZOLMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters CZOLCMRespondHandler;

+ (instancetype)GETMethodWithUrl:(NSString *)url CZOLCMRespondHandler;
+ (instancetype)GETMethodWithUrl:(NSString *)url parameters:(NSDictionary *)parameters CZOLCMRespondHandler;
+ (instancetype)POSTMethodWithUrl:(NSString *)url CZOLCMRespondHandler;
+ (instancetype)POSTMethodWithUrl:(NSString *)url parameters:(NSDictionary *)parameters CZOLCMRespondHandler;

/**
 无key参数请求

 @param url 请求地址
 @param parameter NSString *
 @return [self class]
 */
+ (instancetype)POSTMethodWithUrl:(NSString *)url parameter:(NSString *)parameter CZOLCMRespondHandler;

- (void)setHost:(NSString *)host;

@end
