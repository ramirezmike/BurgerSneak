//
//  DebugScene.h
//  EatPrototype
//
//  Created by Michael Ramirez on 4/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface DebugLayer : CCLayerColor {
	CCLabelTTF *label;
	CCLabelTTF *randomNumberLimitLabel;
	CCMenuItem *debugButton;


}
-(void)addControl:(CCLabelTTF *) controlLabel withHeight:(int)height;
-(void)addControls;


@property (nonatomic, retain) CCLabelTTF *label;
@property (nonatomic, retain) CCLabelTTF *randomNumberLimitLabel;

@end

@interface DebugScene : CCScene
{
	DebugLayer *debug_layer;	
}


@property (nonatomic, retain) DebugLayer *debug_layer;
@end