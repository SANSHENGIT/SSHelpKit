//
// Created by 李飞恒 on 2018/2/3.
// Copyright (c) 2018 SANSHENG TECHONLOGY LLC admin@sansehngit.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SSApiConfiguration : NSObject

+ (instancetype)sharedInstance;

- (void)setHostWith:(NSString *)host;

- (NSString *)getHost;

@end
