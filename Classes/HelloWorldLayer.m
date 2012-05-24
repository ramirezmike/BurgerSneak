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

-(void)scrollBackground:(ccTime)dt
{	
	if (background1.position.y - background1.contentSize.height/2 < 0 - background1.contentSize.height) 
	{
        background1.position = ccp(0, background2.position.y + background2.contentSize.height/2);
    }
    else if (background2.position.y - background2.contentSize.height/2 < 0 - background2.contentSize.height) 
	{
        background2.position = ccp(0, background1.position.y + background1.contentSize.height/2);
    }
	else
	{
		background1.position = ccp( background1.position.x, background1.position.y - 40*dt);
		background2.position = ccp( background2.position.x, background2.position.y - 40*dt);
	}
}

-(void)removeDecals:(ccTime)dt
{
	for (CCSprite *burger in _burgers) 
	{
		if (burger.position.y > 380) 
		{
			[self removeChild:burger cleanup:YES];
		}
	}
}

-(void)addBackground:(ccTime)dt
{
	CCSprite *burger = [CCSprite spriteWithFile:@"burger1.png"];	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	int minX = burger.contentSize.width/2;
	int maxX = screenSize.width - burger.contentSize.width/2;
	int rangeX = maxX - minX;
	int actualX = (arc4random() % rangeX) + minX;
	
	burger.position = ccp(actualX, 0);
	[_burgers addObject:burger];
	
	int minTravelDuration = 5;
	int maxTravelDuration = 12;
	int rangeTravelDuration = maxTravelDuration - minTravelDuration;
	int actualTravelDuration = (arc4random() % rangeTravelDuration) + minTravelDuration;
	
	int minWidth = burger.contentSize.width * 0.5;
	int maxWidth = burger.contentSize.width * 3;
	int rangeWidth = maxWidth - minWidth;
	int sizeFactor = (arc4random() % rangeWidth) * 0.1;
	burger.scale = sizeFactor;
	//burger.opacity = 95;
	
	[self addChild:burger];

	id actionMove = [CCMoveTo actionWithDuration:actualTravelDuration 
		position:ccp(actualX, 400)];

	[burger runAction:[CCSequence actions:actionMove, nil]];
}

-(id)init 
{
	if( (self=[super init])) 
	{
		_burgers = [[NSMutableArray alloc]init];
		background1 = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
		background2 = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
		
		background1.position = ccp(0, 0);
		background2.position = ccp(0, 160);

		[self schedule:@selector(scrollBackground:)];
		[self schedule:@selector(addBackground:)interval:0.7f];
		[self schedule:@selector(removeDecals:)interval:10.0f];
		[self addChild:background1];
		[self addChild:background2];
	}
	return self;
}

-(void)dealloc
{
	[background1 release];
	[background2 release];
	[_burgers release];
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
	if (!armIsWaiting && !raiseArms) 
	{
		raiseArms = TRUE;
	}
	
	else if (raiseArms && !HOLD_CONTROL)
	{
		raiseArms = FALSE;
		arms.visible = YES;
		player1.state = playerStateIdle;
	}
}



-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (HOLD_CONTROL) 
	{
		raiseArms = FALSE;
		arms.visible = YES;
		player1.state = playerStateIdle;
	}
}

-(void)cacheSprites
{
	[[CCSpriteFrameCache sharedSpriteFrameCache]addSpriteFramesWithFile:
		@"EatArt.plist"];
	artSpriteSheet = [CCSpriteBatchNode
					batchNodeWithFile:@"EatArt.png"];
	[self addChild:artSpriteSheet];
}


-(void)debugButtonTapped:(id)sender
{
	DebugLayer *debug = [DebugLayer node];
	[debug.randomNumberLimitLabel setString:[NSString stringWithFormat:@"%i",RANDOM_NUMBER_LIMIT]];
	[debug.armUpSpeedLabel setString:[NSString stringWithFormat:@"%i",ARM_UP_SPEED]];
	[debug.armDownSpeedLabel setString:[NSString stringWithFormat:@"%i",ARM_DOWN_SPEED]];
	[debug.armWaitLengthLabel setString:[NSString stringWithFormat:@"%i",ARM_WAIT_LENGTH]];
	[debug.holdControlLabel setString:[NSString stringWithFormat:@"%i",HOLD_CONTROL]];


	[debug addControls];
	[self addChild:debug];
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

-(void)setControls:(BOOL) holdControl
{
	HOLD_CONTROL = holdControl;
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
		
		raiseArms = FALSE;
		score = 0;
		
		RANDOM_NUMBER_LIMIT = 3;
		ARM_UP_SPEED = 10;
		ARM_DOWN_SPEED = 5;
		ARM_WAIT_LENGTH = 0;
		HOLD_CONTROL = FALSE;
		SCORE_INCREASE_SPEED = 5;
		SCORE_DECREASE_SPEED = 20;
		
		randomNumberLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:15];
		randomNumberLabel.color = ccc3(0,0,0);
		randomNumberLabel.position = ccp(screenSize.width - 50, screenSize.height - 50);
		[self addChild:randomNumberLabel];
		
		
		table = [CCSprite spriteWithFile:@"table.png"];
		table.position = ccp(table.contentSize.width/2, 5);
		
		
		boss1 = [[Boss alloc]initWithPosition:ccp(0,0)];
		boss1.position = ccp(480 - (boss1.contentSize.width/2), boss1.contentSize.height/2);
		boss1.scale = 0.8;
		
		player1 = [[Player alloc]initWithPosition:ccp(0,0)];
		player1.position = ccp(player1.contentSize.width/2, player1.contentSize.height/2);
		player1.scale = 0.8;
		

		arms = [CCSprite spriteWithFile:@"pArms.png"]; 
		arms.position = ccp(100,50);
		arms.scale = 0.8;

		scoreBar = [CCSprite spriteWithFile:@"scoreBar.png"];
		scoreBar.position = ccp(50,300);
		scoreBar.anchorPoint = ccp(0,1);
		scoreBar.scale = 10;

		[artSpriteSheet addChild:boss1];
		[artSpriteSheet addChild:player1];
		
		[self addChild:scoreBar];
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
		
		float waitLength = ARM_WAIT_LENGTH * 0.01;
		[self schedule:@selector(armsCheck:)interval:waitLength];
	}
	else if (raiseArms == FALSE && arms.position.y >= 50 && !armIsWaiting) 
	{
		arms.position = ccp(arms.position.x,arms.position.y - ARM_DOWN_SPEED);
		player1.state = playerStateIdle;
		[self schedule:@selector(armsCheck:)interval:0.1f];
	}
	else if (armIsWaiting == TRUE)
	{
		armIsWaiting = FALSE;
		return;
	}
}
-(void)scoreCheck:(ccTime)dt
{
	if (player1.state == playerStateEating && !boss1.state == bossStateLook) 
	{
		score += SCORE_INCREASE_SPEED;
		if (score > 350) 
		{
			score = 350;
		}
		scoreBar.scaleX = score;
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
		score -= SCORE_DECREASE_SPEED;
		if (score < 10) 
		{
			score = 10;
		}
		scoreBar.scaleX = score;

		[self schedule:@selector(nextFrame:)interval:0.1f];
		return;
	}
	int random_number = arc4random() % RANDOM_NUMBER_LIMIT;
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

	[self schedule:@selector(nextFrame:)interval:random_float];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	[player1 release];
	[boss1 release];
	[table release];
	[debugButton release];
	[scoreLabel release];
	[randomNumberLabel release];
	[arms release];
	[scoreBar release];
	[table release];
	[artSpriteSheet release];
	[bossSpriteSheet release];
	[playerSpriteSheet release];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
