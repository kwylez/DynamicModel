//
//  CWDetailViewController.h
//  DynamicModel
//
//  Created by Cory Wiles on 9/30/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <objc/message.h>

@class ModelContentDefaultManager;

@interface CWDetailViewController : UIViewController {
  
  UILabel *titleProp;
  UILabel *heading;
  UILabel *subheading;
  id dynObj;
}

@property (nonatomic, retain) IBOutlet UILabel *titleProp;
@property (nonatomic, retain) IBOutlet UILabel *heading;
@property (nonatomic, retain) IBOutlet UILabel *subheading;
@property (nonatomic, retain) id dynObj;

@end
