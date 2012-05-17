//
//  Player.m
//  EatPrototype
//
//  Created by Michael Ramirez on 4/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player
@synthesize state,playerEatingAction,playerIdleAction,playerAnticipationAction;

-(id)initWithPosition:(CGPoint)pos
{
	if ((self = [super initWithSpriteFrameName:@"pIdle0.png"])) 
	{
		[self createAnimation];
		self.position = pos;
		self.state = playerStateIdle;
	}
	return self;
}


-(void)setState:(PlayerState)s
{
	if (state == s) 
		return;
	if (state == playerStateEating)
	{
		[self stopAction:playerEatingAction];
	}
	if (state == playerStateAnticipation)
	{
		[self stopAction:playerAnticipationAction];
	}
	if (state == playerStateIdle) 
	{
		[self stopAction:playerIdleAction];
	}
	state = s;
	switch (state) {
		case playerStateEating:
			[self runAction:playerEatingAction];
			break;
		case playerStateAnticipation:
			[self runAction:playerAnticipationAction];
			break;
		default:
			[self runAction:playerIdleAction];
			break;
	}
	
}

-(void)createAnimation
{
	NSMutableArray *eatingAnimFrames = [[NSMutableArray alloc]init];
	for (int i = 0; i<=1;i++)
	{
		[eatingAnimFrames addObject:
			[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:
			[NSString stringWithFormat:@"pEat%d.png",i]]];
	}
	CCAnimation *eatingAnim = [[CCAnimation alloc]initWithFrames:
				eatingAnimFrames delay:0.1f];
				[eatingAnimFrames release];
	playerEatingAction = [[CCRepeatForever alloc]initWithAction:
				[[CCAnimate alloc] initWithAnimation:eatingAnim restoreOriginalFrame:NO]];
				[eatingAnim release];
				
	NSMutableArray *anticipationAnimFrames = [[NSMutableArray alloc]init];
	for (int i = 0; i<=1;i++)
	{
		[anticipationAnimFrames addObject:
			[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:
			[NSString stringWithFormat:@"pAnti%d.png",i]]];
	}
	CCAnimation *anticipationAnim = [[CCAnimation alloc]initWithFrames:
				anticipationAnimFrames delay:0.7f];
				[anticipationAnimFrames release];
	playerAnticipationAction = [[CCRepeatForever alloc]initWithAction:
				[[CCAnimate alloc] initWithAnimation:anticipationAnim restoreOriginalFrame:NO]];
				[anticipationAnim release];
				
	NSMutableArray *idleAnimFrames = [[NSMutableArray alloc]init];
	for (int i = 0; i<=1;i++)
	{
		[idleAnimFrames addObject:
			[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:
			[NSString stringWithFormat:@"pIdle%d.png",i]]];
	}
	CCAnimation *idleAnim = [[CCAnimation alloc]initWithFrames:
				idleAnimFrames delay:1.0f];
				[idleAnimFrames release];
	playerIdleAction = [[CCRepeatForever alloc]initWithAction:
				[[CCAnimate alloc] initWithAnimation:idleAnim restoreOriginalFrame:NO]];
				[idleAnim release];
}

@end
