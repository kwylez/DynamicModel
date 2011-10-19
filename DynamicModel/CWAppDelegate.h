//
//  CWAppDelegate.h
//  DynamicModel
//
//  Created by Cory Wiles on 9/21/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CWViewController;
@class CWListViewController;

@interface CWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CWListViewController *viewController;

@end
