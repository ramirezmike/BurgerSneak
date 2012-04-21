//
//  Player.h
//  EatPrototype
//
//  Created by Michael Ramirez on 4/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
		playerStateIdle,
		playerStateEating,
		}
		PlayerState;

@interface Player : CCSprite {
		PlayerState state;
		CCAction *playerEatingAction;
}

@property (nonatomic,assign) PlayerState state;
-(id)initWithPosition:(CGPoint)pos;
-(void)createAnimation;

@property (nonatomic, retain) CCAction *playerEatingAction;

@end
