//
//  Boss.m
//  EatPrototype
//
//  Created by Michael Ramirez on 4/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Boss.h"


@implementation Boss
@synthesize state,bossIdleAction;

-(id)initWithPosition:(CGPoint)pos
{
	if ((self = [super initWithSpriteFrameName:@"bIdle0.png"])) 
	{
		[self createAnimation];
		self.position = pos;
		self.state = bossStateLook;
	}
	return self;
}


-(void)setState:(BossState)s
{
	if (state == s) 
		return;
	if (state == bossStateIdle)
	{
		[self stopAction:bossIdleAction];
	}
	state = s;
	switch (state) {
		case bossStateShock:
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
					spriteFrameByName:@"bShock0.png"]];
			break;
		case bossStateLook:
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
					spriteFrameByName:@"bLook0.png"]];
			break;
		default:
			[self runAction:bossIdleAction];
			break;
	}
	
}

-(void)createAnimation
{
	NSMutableArray *idleAnimFrames = [[NSMutableArray alloc]init];
	for (int i = 0; i<=2;i++)
	{
		[idleAnimFrames addObject:
			[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:
			[NSString stringWithFormat:@"bIdle%d.png",i]]];
	}
	CCAnimation *idleAnim = [[CCAnimation alloc]initWithFrames:
				idleAnimFrames delay:1.0f];
				[idleAnimFrames release];
	bossIdleAction = [[CCRepeatForever alloc]initWithAction:
				[[CCAnimate alloc] initWithAnimation:idleAnim restoreOriginalFrame:NO]];
				[idleAnim release];
}

@end
