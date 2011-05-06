//
//  Box2DWrapperViewController.h
//  Box2DWrapper
//
//  Created by wmr on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define PTM_RATIO 44

#import <UIKit/UIKit.h>
#include <Box2D/Box2D.h>


@interface Box2DWrapperViewController : UIViewController {
    b2World* world;
    NSTimer* tickTimer;
}

- (void)createWorld;
- (void)addPhysicalBodyForView:(UIView*)targetView;
- (void)tick:(NSTimer*)aTimer;

@end
    