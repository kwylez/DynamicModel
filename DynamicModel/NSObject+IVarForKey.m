//
//  IVarForKey.m
//  DynamicModel
//
//  Created by Cory Wiles on 9/22/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import "NSObject+IVarForKey.h"

@implementation NSObject (IVarForKey)

- (void *)instanceVariableForKey:(NSString *)aKey {
  
  if (aKey) {
  
    Ivar ivar = object_getInstanceVariable(self, [aKey UTF8String], NULL);
    
    if (ivar) {
      return (void *)((char *)self + ivar_getOffset(ivar));
    }
  }

  return NULL;
}

@end
