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
#import "DebugLayer.h"

@implementation BackgroundLayer

-(void)addBackground:(ccTime)dt
{
	CCSprite *burger = [CCSprite spriteWithFile:@"burger.png"];
	burger.tag = 1;
	//[_backgroundDecals addObject:burger];
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	int minX = burger.contentSize.width/2;
	int maxX = screenSize.width - burger.contentSize.width/2;
	int rangeX = maxX - minX;
	int actualX = (arc4random() % rangeX) + minX;
	
	burger.position = ccp(actualX, 0);
	
	int minTravelDuration = 5;
	int maxTravelDuration = 12;
	int rangeTravelDuration = maxTravelDuration - minTravelDuration;
	int actualTravelDuration = (arc4random() % rangeTravelDuration) + minTravelDuration;
	
	int minWidth = burger.contentSize.width * 0.5;
	int maxWidth = burger.contentSize.width * 3;
	int rangeWidth = maxWidth - minWidth;
	int sizeFactor = (arc4random() % rangeWidth) * 0.1;
	burger.scale = sizeFactor;
	burger.opacity = 95;
	
	[self addChild:burger];

	id actionMove = [CCMoveTo actionWithDuration:actualTravelDuration 
		position:ccp(actualX, 400)];
	id actionMoveDone = [CCCallFunc actionWithTarget:self
		selector:@selector(decalMoveFinished:)];
		
	[burger runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)decalMoveFinished:(id)sender
{
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
}

-(id)init 
{
	if( (self=[super initWithColor:ccc4(100,200,255,255)])) 
	{
		[self schedule:@selector(addBackground:)interval:0.7f];
	}
	return self;
}

-(void)dealloc
{
	
	[super dealloc];		
}
@end


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	BackgroundLayer *backlayer = [BackgroundLayer node];
	// add layer as a child to scene
	[scene addChild:backlayer];
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!armIsWaiting) 
	{
		raiseArms = TRUE;
	}
}



-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	raiseArms = FALSE;
	arms.visible = YES;
	player1.state = playerStateIdle;
}

-(void)cacheSprites
{
	[[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:
		@"EatArt.plist"];
	artSpriteSheet = [CCSpriteBatchNode
					batchNodeWithFile:@"EatArt.png"];
	[self addChild:artSpriteSheet];
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
	DebugLayer *debug = [DebugLayer node];
	[debug.randomNumberLimitLabel setString:[NSString stringWithFormat:@"%i",RANDOM_NUMBER_LIMIT]];
	[debug.armUpSpeedLabel setString:[NSString stringWithFormat:@"%i",ARM_UP_SPEED]];
	[debug.armDownSpeedLabel setString:[NSString stringWithFormat:@"%i",ARM_DOWN_SPEED]];
	[debug.armWaitLengthLabel setString:[NSString stringWithFormat:@"%i",ARM_WAIT_LENGTH]];

	[debug addControls];
	[self addChild:debug];
	
	
	//NSLog(@"RNDERPLL:%i %i",RANDOM_NUMBER_LIMIT, [[debug.debug_layer.randomNumberLimitLabel string]intValue]);

	//RANDOM_NUMBER_LIMIT = [[debug.debug_layer.randomNumberLimitLabel string]intValue];
}

-(void)setRandomLimit:(int) limit
{
	RANDOM_NUMBER_LIMIT = limit;
}

-(void)setArmUpSpeed:(int) speed
{
	ARM_UP_SPEED = speed;
}

-(void)setArmDownSpeed:(int) speed
{
	ARM_DOWN_SPEED = speed;
}

-(void)setArmWaitLength:(int) time
{
	ARM_WAIT_LENGTH = time;
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
	if( (self=[super init])) 
	{
		self.isTouchEnabled = YES;
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		[self cacheSprites];
		[self cacheBossSprites];
		[self cachePlayerSprites];
		
		raiseArms = FALSE;
		score = 0;
		
		RANDOM_NUMBER_LIMIT = 5;
		ARM_UP_SPEED = 10;
		ARM_DOWN_SPEED = 5;
		ARM_WAIT_LENGTH = 70;
		
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
		boss1.scale = 0.8;
		
		player1 = [[Player alloc]initWithPosition:ccp(0,0)];
		player1.position = ccp(player1.contentSize.width/2, player1.contentSize.height/2);
		player1.scale = 0.8;
		

		arms = [CCSprite spriteWithFile:@"pArms.png"]; 
		arms.position = ccp(100,0);
		arms.scale = 0.8;

		[artSpriteSheet addChild:boss1];
		[artSpriteSheet addChild:player1];
		
		[self addChild:arms];
		[self addChild:table];

		[self createDebugButton];

		[self schedule:@selector(armsCheck:)interval:0.7f];
		[self schedule:@selector(scoreCheck:)interval:0.1f];
		[self schedule:@selector(eatCheck:)interval:0.1f];
		[self schedule:@selector(nextFrame:)interval:1.0f];

		
	}
	return self;
}

-(void)armsCheck:(ccTime)dt
{
	if (raiseArms == TRUE && arms.position.y <= player1.position.y && !armIsWaiting) 
	{
		arms.position = ccp(arms.position.x,arms.position.y + ARM_UP_SPEED);
		player1.state = playerStateAnticipation;
		[self schedule:@selector(armsCheck:)interval:0.1f];
	}
	else if (raiseArms == TRUE && arms.position.y > player1.position.y && !armIsWaiting)
	{
		arms.visible = NO;
		player1.state = playerStateEating;
		armIsWaiting = TRUE;
		NSLog(@"ARM IS WAITING");
		
		float waitLength = ARM_WAIT_LENGTH * 0.01;
		[self schedule:@selector(armsCheck:)interval:waitLength];
	}
	else if (raiseArms == FALSE && arms.position.y >= 0 && !armIsWaiting) 
	{
		arms.position = ccp(arms.position.x,arms.position.y - ARM_DOWN_SPEED);
		player1.state = playerStateIdle;
		[self schedule:@selector(armsCheck:)interval:0.1f];
	}
	else if (armIsWaiting == TRUE)
	{
		armIsWaiting = FALSE;
		NSLog(@"ARM IS NO LONGER WAITING");
		return;
	}
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
	
	double random_int = 50 + arc4random() % 150;
	float random_float = random_int * 0.01;
	NSLog(@"%i",random_int);
	NSLog(@"%f",random_float);
	[self schedule:@selector(nextFrame:)interval:random_float];
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
