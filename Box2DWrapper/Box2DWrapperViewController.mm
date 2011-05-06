//
//  Box2DWrapperViewController.m
//  Box2DWrapper
//
//  Created by wmr on 5/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Box2DWrapperViewController.h"

@implementation Box2DWrapperViewController

- (void)dealloc
{
    [tickTimer invalidate], tickTimer=nil;
    [super dealloc];
}


#pragma mark - Box2D utility functions
- (void)createWorld
{
    CGSize screenSize = self.view.bounds.size;
    b2Vec2 gravityVector(.0f, -9.81f); // Earth gravity
    world = new b2World(gravityVector, true);
    world->SetContinuousPhysics(true);
    
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(.0f,.0f);
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    b2EdgeShape groundBox;
    
    groundBox.Set(b2Vec2(.0f,.0f), b2Vec2(screenSize.width/PTM_RATIO,.0f));
	groundBody->CreateFixture(&groundBox, .0f);
    
	// top
	groundBox.Set(b2Vec2(.0f,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox, .0f);
    
	// left
	groundBox.Set(b2Vec2(.0f,screenSize.height/PTM_RATIO), b2Vec2(.0f,.0f));
	groundBody->CreateFixture(&groundBox, .0f);
    
	// right
	groundBox.Set(b2Vec2(screenSize.width/PTM_RATIO,screenSize.height/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,.0f));
	groundBody->CreateFixture(&groundBox, .0f);
}

- (void)addPhysicalBodyForView:(UIView *)targetView 
{
    
        // Define the dynamic body.
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        
        CGPoint p = targetView.center;
        CGPoint boxDimensions = CGPointMake(targetView.bounds.size.width/PTM_RATIO/2.0,targetView.bounds.size.height/PTM_RATIO/2.0);
        
        bodyDef.position.Set(p.x/PTM_RATIO, (460.0 - p.y)/PTM_RATIO);
        bodyDef.userData = targetView;
        
        // Tell the physics world to create the body
        b2Body *body = world->CreateBody(&bodyDef);
        
        // Define another box shape for our dynamic body.
        b2PolygonShape dynamicBox;
        
        dynamicBox.SetAsBox(boxDimensions.x, boxDimensions.y);
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicBox;
        fixtureDef.density = 3.0f;
        fixtureDef.friction = 0.3f;
        fixtureDef.restitution = 0.5f; // 0 is a lead ball, 1 is a super bouncy ball
        body->CreateFixture(&fixtureDef);
        
        // a dynamic body reacts to forces right away
        body->SetType(b2_dynamicBody);
        
        // we abuse the tag property as pointer to the physical body
        targetView.tag = (int)body;
    
}

- (void)tick:(NSTimer *)aTimer
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(1.0f/60.0f, velocityIterations, positionIterations);
    
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL)
		{
			UIView *oneView = (UIView *)b->GetUserData();
            
			// y Position subtracted because of flipped coordinate system
			CGPoint newCenter = CGPointMake(b->GetPosition().x * PTM_RATIO,
                                            self.view.bounds.size.height - b->GetPosition().y * PTM_RATIO);
			oneView.center = newCenter;
            
			CGAffineTransform transform = CGAffineTransformMakeRotation(- b->GetAngle());
            
			oneView.transform = transform;
		}
	}
}

- (void)viewDidLoad
{
    [self createWorld];
    
    for (UIView* aView in self.view.subviews) {
        [self addPhysicalBodyForView:aView];        
    }
    
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
