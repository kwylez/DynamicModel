//
//  IVarForKey.h
//  DynamicModel
//
//  Created by Cory Wiles on 9/22/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface NSObject (InstanceVariableForKey)

- (void *)instanceVariableForKey:(NSString *)aKey;

@end
