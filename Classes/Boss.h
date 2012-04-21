//
//  Boss.h
//  EatPrototype
//
//  Created by Michael Ramirez on 4/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

typedef enum {
		bossStateIdle,
		bossStateLook,
		bossStateShock,
		}
		BossState;

@interface Boss : CCSprite {
		BossState state;
		CCAction *bossIdleAction;
}

@property (nonatomic,assign) BossState state;
-(id)initWithPosition:(CGPoint)pos;
-(void)createAnimation;

@property (nonatomic, retain) CCAction *bossIdleAction;

@end
