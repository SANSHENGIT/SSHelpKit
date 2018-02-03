//
// Created by 李飞恒 on 2018/2/3.
// Copyright (c) 2018 SANSHENG TECHONLOGY LLC admin@sansehngit.com. All rights reserved.
//

#import "SSHTTP.h"
#import <AFNetworking.h>

@interface SSHTTP ()
/** 请求方式 */
@property (assign ,nonatomic) CZOLMethod method;
/** 成功回调 */
@property (copy, nonatomic) CZOLCMUtilSuccessBlock successBlock;
/** 失败回调 */
@property (copy, nonatomic) CZOLCMUtilFailureBlock failureBlock;

@end

@implementation SSHTTP {

}

+ (instancetype)GETMethodWithUrl:(NSString *)url CZOLCMRespondHandler
{
    return [[self class] GETMethodWithUrl:url parameters:nil success:successBlock failure:failureBlock];
}

+ (instancetype)GETMethodWithUrl:(NSString *)url parameters:(NSDictionary *)parameters CZOLCMRespondHandler
{
    return [[SSHTTP alloc] initWithMethod:CZOLMethodGET url:url parameters:parameters success:successBlock failure:failureBlock];
}

+ (instancetype)POSTMethodWithUrl:(NSString *)url CZOLCMRespondHandler
{
    return [SSHTTP POSTMethodWithUrl:url parameters:nil success:successBlock failure:failureBlock];
}

+ (instancetype)POSTMethodWithUrl:(NSString *)url parameters:(NSDictionary *)parameters CZOLCMRespondHandler
{
    return [[SSHTTP alloc] initWithMethod:CZOLMethodPOST url:url parameters:parameters success:successBlock failure:failureBlock];
}

+ (instancetype)POSTMethodWithUrl:(NSString *)url parameter:(NSString *)parameter CZOLCMRespondHandler
{
    return [[SSHTTP alloc] initWithMethod:CZOLMethodPOST url:url parameter:parameter success:successBlock failure:failureBlock];
}

- (instancetype)initWithMethod:(CZOLMethod)method url:(NSString *)url parameter:(NSString *)parameter CZOLCMRespondHandler
{
    if (self = [super init]) {
        [self addObservers];
        //赋值
        self.method = method;
        [self setValue:url forKey:@"url"];
        [self setValue:parameter forKey:@"requestPara"];

        //添加监听回调
        if (successBlock) {
            self.successBlock = successBlock;
        }
        if (failureBlock) {
            self.failureBlock = failureBlock;
        }

    }
    return self;
}


- (instancetype)initWithMethod:(CZOLMethod)method url:(NSString *)url CZOLCMRespondHandler
{
    return [[SSHTTP alloc] initWithMethod:method url:url parameters:nil success:successBlock failure:failureBlock];
}

- (instancetype)initWithMethod:(CZOLMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters CZOLCMRespondHandler
{
    if (self = [super init]) {
        [self addObservers];
        //赋值
        self.method = method;
        [self setValue:url forKey:@"url"];
        [self setValue:parameters forKey:@"parameters"];

        //添加监听回调
        if (successBlock) {
            self.successBlock = successBlock;
        }
        if (failureBlock) {
            self.failureBlock = failureBlock;
        }

    }
    return self;
}

- (void)dealloc
{

    [self removeObserver];
    if (_successBlock) {
        _successBlock = nil;
    }
    if (_failureBlock) {
        _failureBlock = nil;
    }
    _method = -1;
}

- (void)addObservers
{
    [self addObserver:self forKeyPath:@"host" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)removeObserver
{
    [self removeObserver:self forKeyPath:@"host"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"host"]) {
        [self setup];
    }
}

- (void)setHost:(NSString *)host
{
    _host = host;
}


- (void)setup
{
    switch (self.method) {
        case GET:
        {
            [self getWithUrlString:self.url parameters:self.parameters];
            break;
        }
        case POST:
        {
            if (self.parameters) {
                [self postWithUrlString:self.url parameters:self.parameters];
            } else {
                [self postWithUrlString:self.url parameters:self.requestPara];
            }

            break;
        }
        default:
            break;
    }
}

//POST请求 使用NSMutableURLRequest可以加入请求头
- (void)postWithUrlString:(NSString *)url parameters:(id)parameters
{
    NSString *urlString = [self.host stringByAppendingString:url];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;//是否只使用https://

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setAllowsCellularAccess:YES];



    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.successBlock) {

//            id obj = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:&error];
//            id jsonObject = [data yy_modelToJSONObject];
            self.successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError * error) {
        if (self.failureBlock) {
            NSLog(@"网络超时");
            if (error.code == 500) NSLog(@"服务器挂了:500");
            self.failureBlock(error);
        }
    }];

}


//GET请求
- (void)getWithUrlString:(NSString *)url parameters:(id)parameters
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];

    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.successBlock) {
            self.successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.failureBlock) {
            self.failureBlock(error);
        }
    }];
}


//重新封装参数 加入app相关信息
+ (NSDictionary *)parseParams:(NSDictionary *)params
{
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
//    NSLog(@"请求参数:%@",parameters);
//
//    NSString *keyValueFormat;
//    NSMutableString *result = [NSMutableString new];
//    //实例化一个key枚举器用来存放dictionary的key
//
//    //加密处理 将所有参数加密后结果当做参数传递
//    //parameters = @{@"i":@"加密结果 抽空加入"};
//
//    NSEnumerator *keyEnum = [parameters keyEnumerator];
//    id key;
//    while (key = [keyEnum nextObject]) {
//        keyValueFormat = [NSString stringWithFormat:@"%@=%@&", key, [params valueForKey:key]];
//        [result appendString:keyValueFormat];
//    }
//    return [NSDictionary dictionaryWithDictionary:parameters];
    return params;
}



@end