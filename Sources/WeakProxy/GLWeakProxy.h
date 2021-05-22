//
//  GLWeakProxy.h
//  SwiftTool
//
//  Created by galaxy on 2020/12/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLWeakProxy : NSProxy
@property (nullable, nonatomic, weak, readonly) id target;
+ (instancetype)proxyWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
