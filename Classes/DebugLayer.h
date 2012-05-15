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
	CCLabelTTF *armUpSpeedLabel;
	CCLabelTTF *armDownSpeedLabel;
	CCLabelTTF *armWaitLengthLabel;
	CCMenuItem *debugButton;
}

-(void)addControl:(CCLabelTTF *) controlLabel withHeight:(int)height;
-(void)addControls;


@property (nonatomic, retain) CCLabelTTF *label;
@property (nonatomic, retain) CCLabelTTF *randomNumberLimitLabel;
@property (nonatomic, retain) CCLabelTTF *armUpSpeedLabel;
@property (nonatomic, retain) CCLabelTTF *armDownSpeedLabel;
@property (nonatomic, retain) CCLabelTTF *armWaitLengthLabel;

@end