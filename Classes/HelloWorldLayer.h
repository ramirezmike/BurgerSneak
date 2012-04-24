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
	
	int score;
	int RANDOM_NUMBER_LIMIT;


	
	CCSpriteBatchNode *bossSpriteSheet;
	CCSpriteBatchNode *playerSpriteSheet;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)setRandomLimit:(int) limit;


@end