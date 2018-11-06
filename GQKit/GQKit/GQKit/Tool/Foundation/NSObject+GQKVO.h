//
//  NSObject+GQKVO.h
//  GQKit
//
//  Created by 刘耿群 on 2019/11/14.
//  Copyright © 2019 GQKit. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GQKVO)

- (void)gq_addObserverBlockForKeyPath:(NSString*_Nonnull)keyPath block:(void (^_Nonnull)(id _Nonnull obj, _Nullable id oldVal, _Nullable id newVal))block;

- (void)gq_removeObserverBlocksForKeyPath:(NSString*_Nonnull)keyPath;

- (void)gq_removeObserverBlocks;
@end

NS_ASSUME_NONNULL_END
