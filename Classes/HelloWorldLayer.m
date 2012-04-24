//
//  HelloWorldLayer.m
//  EatPrototype
//
//  Created by Michael Ramirez on 4/19/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Boss.h"
#import "Player.h"
#import "DebugScene.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	player1.state = playerStateEating;
}



-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	player1.state = playerStateIdle;
}

-(void)cacheBossSprites
{
	[[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:
	 @"Boss_Sprite_Sheet.plist"];
	bossSpriteSheet = [CCSpriteBatchNode 
					   batchNodeWithFile:@"Boss_Sprite_Sheet.png"];
	[self addChild:bossSpriteSheet];
}

-(void)cachePlayerSprites
{
	[[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:
	 @"Player_Sprite_Sheet.plist"];
	playerSpriteSheet = [CCSpriteBatchNode 
						 batchNodeWithFile:@"Player_Sprite_Sheet.png"];
	[self addChild:playerSpriteSheet];	
}

-(void)debugButtonTapped:(id)sender
{
	DebugScene *debug = [DebugScene node];
	[debug.debug_layer.randomNumberLimitLabel setString:[NSString stringWithFormat:@"%i",RANDOM_NUMBER_LIMIT]];
	[debug.debug_layer addControls];
	NSLog(@"RNDERPLL:%i %i",RANDOM_NUMBER_LIMIT, [[debug.debug_layer.randomNumberLimitLabel string]intValue]);

	[[CCDirector sharedDirector] pushScene:debug];
	//RANDOM_NUMBER_LIMIT = [[debug.debug_layer.randomNumberLimitLabel string]intValue];
}

-(void)setRandomLimit:(int) limit
{
	RANDOM_NUMBER_LIMIT = limit;
}

-(void)createDebugButton
{
	debugButton = [CCMenuItemImage
		itemFromNormalImage:@"debug.png" selectedImage:@"debugSel.png"
		target:self selector:@selector(debugButtonTapped:)];
	debugButton.position = ccp(430,300);
	CCMenu *debugMenu = [CCMenu menuWithItems:debugButton, nil];
	debugMenu.position = CGPointZero;
	[self addChild:debugMenu];
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)])) 
	{
		self.isTouchEnabled = YES;
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		[self cacheBossSprites];
		[self cachePlayerSprites];
		
		score = 0;
		RANDOM_NUMBER_LIMIT = 5;
		scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:64];
		randomNumberLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:15];
		[scoreLabel setString:[NSString stringWithFormat:@"%i",score]];
		randomNumberLabel.color = ccc3(0,0,0);
		scoreLabel.color = ccc3(0,0,0);
		scoreLabel.position = ccp(screenSize.width/2, screenSize.height - 30);
		randomNumberLabel.position = ccp(screenSize.width - 50, screenSize.height - 50);
		[self addChild:randomNumberLabel];
		[self addChild:scoreLabel];
		
		
		CCSprite *table = [CCSprite spriteWithFile:@"table.png"];
		table.position = ccp(table.contentSize.width/2, 5);
		
		boss1 = [[Boss alloc]initWithPosition:ccp(0,0)];
		boss1.position = ccp(480 - (boss1.contentSize.width/2), boss1.contentSize.height/2);
		
		player1 = [[Player alloc]initWithPosition:ccp(0,0)];
		player1.position = ccp(player1.contentSize.width/2, player1.contentSize.height/2);
				
		[bossSpriteSheet addChild:boss1];
		[playerSpriteSheet addChild:player1];
		[self addChild:table];

		[self createDebugButton];

		[self schedule:@selector(scoreCheck:)interval:0.1f];
		[self schedule:@selector(eatCheck:)interval:0.1f];
		[self schedule:@selector(nextFrame:)interval:1.0f];

		
	}
	return self;
}
-(void)scoreCheck:(ccTime)dt
{
	if (player1.state == playerStateEating && !boss1.state == bossStateLook) 
	{
		scoreLabel.color = ccc3(0,255,0);
		score++;
		if (score > 100) 
		{
			score = 100;
		}
		[scoreLabel setString:[NSString stringWithFormat:@"%i",score]];
	}
	else if (!player1.state == playerStateEating && !boss1.state == bossStateLook)
	{
		scoreLabel.color = ccc3(0,0,0);
	}

}
-(void)eatCheck:(ccTime)dt
{
	if (player1.state == playerStateEating && boss1.state == bossStateLook) 
	{
		boss1.state = bossStateShock;
		[self schedule:@selector(nextFrame:)interval:0.1f];
	}
}

-(void)nextFrame:(ccTime)dt
{
	if (player1.state == playerStateEating && boss1.state == bossStateShock) {
		scoreLabel.color = ccc3(255,0,0);
		score -= 5;
		if (score < 0) 
		{
			score = 0;
		}
		[scoreLabel setString:[NSString stringWithFormat:@"%i",score]];
		[self schedule:@selector(nextFrame:)interval:0.1f];
		return;
	}
	int random_number = arc4random() % RANDOM_NUMBER_LIMIT;
	NSLog(@"%i", random_number);
	[randomNumberLabel setString:[NSString stringWithFormat:@"RNG:%i",random_number]];
	if (random_number == 0) 
	{
		boss1.state = bossStateLook;
	}
	else 
	{
		boss1.state = bossStateIdle;
	}
	
	[self schedule:@selector(nextFrame:)interval:1.0f];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[player1 release];
	[boss1 release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
