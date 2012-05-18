//
//  HelloWorldLayer.h
//  EatPrototype
//
//  Created by Michael Ramirez on 4/19/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
@class Boss;
@class Player;

@interface BackgroundLayer : CCLayer
{
	BackgroundLayer *_layer;
	NSMutableArray *_burgers;
	CCTMXTiledMap* background1;
	CCTMXTiledMap* background2;

}

-(void)addBackground:(ccTime)dt;

@end


@interface HelloWorldLayer : CCLayer
{	
	Boss* boss1;
	Player* player1;
	
	CCMenuItem *debugButton;

	CCLabelTTF *scoreLabel;
	CCLabelTTF *randomNumberLabel;
	
	CCSprite *arms;
	CCSprite *scoreBar;
	CCSprite *table;
	
	int score;
	int RANDOM_NUMBER_LIMIT;
	int ARM_UP_SPEED;
	int ARM_DOWN_SPEED;
	int ARM_WAIT_LENGTH;
	int SCORE_INCREASE_SPEED;
	int SCORE_DECREASE_SPEED;
	
	BOOL raiseArms;
	BOOL armIsWaiting;
	BOOL HOLD_CONTROL;

	CCSpriteBatchNode *artSpriteSheet;
	CCSpriteBatchNode *bossSpriteSheet;
	CCSpriteBatchNode *playerSpriteSheet;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)setRandomLimit:(int) limit;
-(void)setArmUpSpeed:(int) speed;
-(void)setArmDownSpeed:(int) speed;
-(void)setArmWaitLength:(int) time;
-(void)setControls:(BOOL) holdControl;


@end
