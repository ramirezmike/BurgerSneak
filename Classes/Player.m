//
//  Player.m
//  EatPrototype
//
//  Created by Michael Ramirez on 4/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player
@synthesize state,playerEatingAction;

-(id)initWithPosition:(CGPoint)pos
{
	if ((self = [super initWithSpriteFrameName:@"player1.png"])) 
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
	state = s;
	switch (state) {
		case playerStateEating:
			[self runAction:playerEatingAction];
			break;
		default:
			[self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
					spriteFrameByName:@"player1.png"]];
			break;
	}
	
}

-(void)createAnimation
{
	NSMutableArray *eatingAnimFrames = [[NSMutableArray alloc]init];
	for (int i = 2; i<=3;i++)
	{
		[eatingAnimFrames addObject:
			[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:
			[NSString stringWithFormat:@"player%d.png",i]]];
	}
	CCAnimation *eatingAnim = [[CCAnimation alloc]initWithFrames:
				eatingAnimFrames delay:0.1f];
				[eatingAnimFrames release];
	playerEatingAction = [[CCRepeatForever alloc]initWithAction:
				[[CCAnimate alloc] initWithAnimation:eatingAnim restoreOriginalFrame:NO]];
				[eatingAnim release];
}

@end
