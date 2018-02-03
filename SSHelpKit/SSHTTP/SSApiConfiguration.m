//
// Created by 李飞恒 on 2018/2/3.
// Copyright (c) 2018 SANSHENG TECHONLOGY LLC admin@sansehngit.com. All rights reserved.
//

#import "SSApiConfiguration.h"

@interface SSApiConfiguration ()

@property (nonatomic, copy) NSString *host;

@end
@implementation SSApiConfiguration {

}

/** 单例 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static SSApiConfiguration *instance;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (NSString *)getHost
{
    return self.host;
}

- (void)setHostWith:(NSString *)host
{
    self.host = host;
}

@end
