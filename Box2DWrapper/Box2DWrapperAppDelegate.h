//
//  Box2DWrapperAppDelegate.h
//  Box2DWrapper
//
//  Created by wmr on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Box2DWrapperViewController;

@interface Box2DWrapperAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Box2DWrapperViewController *viewController;

@end
