//
//  Resolver.h
//  NodeResolver-Demo
//
//  Created by ios on 2024/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface Resolver : NSObject

@property (nonatomic, strong) NSString *body;

- (void)readWithQuery:(NSString *)quert encoding:(nullable NSString *)encoding;
@end

NS_ASSUME_NONNULL_END
