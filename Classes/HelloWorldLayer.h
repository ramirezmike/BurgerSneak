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

@interface HelloWorldLayer : CCLayerColor
{	
	Boss* boss1;
	Player* player1;
	
	CCMenuItem *debugButton;

	CCLabelTTF *scoreLabel;
	CCLabelTTF *randomNumberLabel;
	
	CCSprite *arms;
	
	int score;
	int RANDOM_NUMBER_LIMIT;
	int ARM_UP_SPEED;
	int ARM_DOWN_SPEED;
	int ARM_WAIT_LENGTH;
	
	BOOL raiseArms;
	BOOL armIsWaiting;


	
	CCSpriteBatchNode *bossSpriteSheet;
	CCSpriteBatchNode *playerSpriteSheet;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)setRandomLimit:(int) limit;
-(void)setArmUpSpeed:(int) speed;
-(void)setArmDownSpeed:(int) speed;
-(void)setArmWaitLength:(int) time;


@end
