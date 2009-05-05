//
//  Callback.m
//  
//
//  Created by Mohammed Shalaby on 1/28/09.
/*
 * Copyright (c) 2008, eSpace.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice, 
 * this list of conditions and the following disclaimer in the documentation 
 * and/or other materials provided with the distribution.
 * 
 * Neither the name of eSpace nor the names of its contributors may be used 
 * to endorse or promote products derived from this software without specific 
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "Callback.h"


@implementation Callback
@synthesize target;
@synthesize action;
@synthesize object1;
@synthesize object2;


-(id) initWithTarget:(id) aTarget action:(SEL) anAction withObject:(id) objectOne withObject:(id) objectTwo {
	if (!(self = [super init]))
		return nil;
	
	self.target = aTarget;
	self.action = anAction;
	self.object1 = objectOne;
	self.object2 = objectTwo;
	return self;
	
}

-(id) initWithTarget:(id) aTarget action:(SEL) anAction withObject:(id) objectOne {
	if (!(self = [self initWithTarget:aTarget action:anAction withObject:objectOne withObject:nil]))
		return nil;
	return self;
}

-(id) initWithTarget:(id) aTarget action:(SEL) anAction {
	if (!(self = [self initWithTarget:aTarget action:anAction withObject:nil withObject:nil]))
		return nil;
	return self;
}


-(void) invoke {
	if (!object1)
		[self.target performSelector:self.action];
	else if (!object2)
		[self.target performSelector:self.action withObject:object1];
	else
		[self.target performSelector:self.action withObject:object1 withObject:object2];
}

-(void) dealloc {
	self.target = nil;
	self.action = 0;
	[super dealloc];
}

@end