//
//  DebugScene.m
//  EatPrototype
//
//  Created by Michael Ramirez on 4/23/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugScene.h"
#import "HelloWorldLayer.h"


@implementation DebugScene
@synthesize debug_layer = debug_layer;


-(id)init
{
	if ((self = [super init]))
	{
		self.debug_layer = [DebugLayer node];
		[self addChild:debug_layer];
	}
	return self;
}

-(void)dealloc
{
	[debug_layer release];
	[super dealloc];
}
@end

@implementation DebugLayer
@synthesize label;
@synthesize randomNumberLimitLabel = randomNumberLimitLabel;

-(void)increaseControl:(id)sender
{
	int controlLabelNumber = [[(id)[sender userData]string]intValue];
	controlLabelNumber++;
	NSString* controlLabelNumberString = [NSString stringWithFormat:@"%i",controlLabelNumber];
	[(id)[sender userData] setString: controlLabelNumberString];
}

-(void)decreaseControl:(id)sender
{
	int controlLabelNumber = [[(id)[sender userData]string]intValue];
	controlLabelNumber--;
	NSString* controlLabelNumberString = [NSString stringWithFormat:@"%i",controlLabelNumber];
	[(id)[sender userData] setString: controlLabelNumberString];
}

-(void)addControl:(CCLabelTTF *) controlLabel withHeight:(int)height
{
	CCMenuItem* plusButton = [CCMenuItemImage
		itemFromNormalImage:@"plus.png" selectedImage:@"plus.png"
		target:self selector:@selector(increaseControl:)];
	plusButton.userData = controlLabel;
	plusButton.position = ccp(100,height);
	
	CCLabelTTF* debugControlLabel = controlLabel;
	debugControlLabel.position = ccp (60, height);
	
	NSLog(@"%s",[controlLabel string]);
	
	CCMenuItem* minusButton = [CCMenuItemImage
		itemFromNormalImage:@"minus.png" selectedImage:@"minus.png"
		target:self selector:@selector(decreaseControl:)];
	minusButton.userData = controlLabel;
	minusButton.position = ccp(20,height-2);
	
	CCMenu *control = [CCMenu menuWithItems:plusButton, minusButton, nil];
	control.position = CGPointZero;
	[self addChild:control];
	[self addChild:debugControlLabel];
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

-(void)debugButtonTapped:(id)sender
{
	//[self.parent setRandomLimit:[[randomNumberLimitLabel string]intValue]];
//	[[[CCDirector sharedDirector]runningScene] RANDOM_NUMBER_LIMIT] = [[randomNumberLimitLabel string]intValue];
	[[CCDirector sharedDirector] popScene];
}

-(id) init
{
	if ((self=[super initWithColor:ccc4(225,225,225,225)]))
	{
		CGSize winSize = [[CCDirector sharedDirector]winSize];
		self.label = [CCLabelTTF labelWithString:@"DEBUG" fontName:@"Arial" fontSize:32];
		label.color = ccc3(0,0,0);
		
		self.randomNumberLimitLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:18];
		randomNumberLimitLabel.color = ccc3(0,0,0);
		
		label.opacity = 40;
		label.position = ccp(winSize.width/2, winSize.height/2);
		
		[self addChild:label];
		
		[self createDebugButton];
		
	}
	return self;
}

-(void)addControls
{
	[self addControl:randomNumberLimitLabel withHeight:300];
	NSLog(@"In AddControls: %s",[randomNumberLimitLabel string]);

}

-(void)dealloc
{
	[label release];
	label = nil;
	[super dealloc];
}

@end
