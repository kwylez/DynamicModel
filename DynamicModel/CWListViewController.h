//
//  CWListViewController.h
//  DynamicModel
//
//  Created by Cory Wiles on 9/23/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <objc/message.h>

#import "CWDetailViewController.h"


@interface CWListViewController : UITableViewController {
  NSMutableArray *objectList;
  NSDictionary *jsonObjectAsDictionary;
}

@property (nonatomic, retain) NSMutableArray *objectList;
@property (nonatomic, copy) NSDictionary *jsonObjectAsDictionary;

@end

static void ReportFunction(id self, SEL _cmd) {

  NSLog(@"This object is %p.", self);
  NSLog(@"Class is %@, and super is %@.", [self class], [self superclass]);
  
  NSLog(@"NSObject's class is %p", [NSObject class]);
  NSLog(@"NSObject's meta class is %p", object_getClass([NSObject class]));

  unsigned int outCount, i;
  
  Ivar *vars	= class_copyIvarList([self class], &outCount);
  
  /**
   * Need to check encoding for better scalable output.  Primatives won't 
   * do so well.
   */
  for (i = 0; i < outCount; i++) {
    
    Ivar var	= vars[i];

    id value = object_getIvar(self, var);

    NSLog(@"value: %@", value);
    
    fprintf(stdout, "%s %s\n", ivar_getName(var),ivar_getTypeEncoding(var));
  }
  
  if (vars != NULL) { free(vars); }
}

static void myDeallocImplementation(id self, SEL _cmd) {

  unsigned int outCount, i;
  
  Ivar *vars	= class_copyIvarList([self class], &outCount);
  
  for (i = 0; i < outCount; i++) {

    Ivar var	= vars[i];

    NSString *iVarName = [NSString stringWithUTF8String:ivar_getName(var)];

    [iVarName release];
    
    object_setIvar(self, var, nil);    
  }
  
  if (vars != NULL) { free(vars); }
  
  struct objc_super obS;

  obS.super_class = [self superclass];
  
  obS.receiver = self;
  
  objc_msgSendSuper(&obS, @selector(dealloc));
}

