//
//  MapMarker.m
//  
//
//  Created by Mohammed Shalaby on 1/18/09.
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
#import "MapMarker.h"
#import "MapView.h"

@implementation MapMarker

@synthesize imageView;
@synthesize lat, lng;
@synthesize x, y;
@synthesize anchor;
@synthesize data;
@synthesize mapView;
@synthesize draggable;
@synthesize delegate;

-(void) setFrame:(CGRect) frame {
	if (self.imageView) {
		self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
	}
	
	[super setFrame:frame];
}

-(id) initWithUIImageView:(UIImageView *) aImageView Lat:(double) latitude Lng:(double) longitude Anchor:(CGPoint) anAnchor {
	if(!(self = [super initWithFrame:aImageView.frame]))
		return nil;
	self.imageView = aImageView;
	[self addSubview:aImageView];
	self.lat = latitude;
	self.lng = longitude;
	self.anchor = anAnchor;
	markerActions = [[NSMutableArray alloc] initWithCapacity:5];
	return self;
}

-(id) initWithImage:(UIImage *) image Lat:(double) latitude Lng:(double) longitude Anchor:(CGPoint) anAnchor {
	UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
	MapMarker *marker = [self initWithUIImageView:imageview Lat:latitude Lng:longitude Anchor:CGPointMake(16.0, 32.0)];
	[imageview release];
	return marker;
}

+(id) defaultBlueMarkerWithLat:(double) latitude Lng:(double) longitude {
	return [[MapMarker alloc] initWithImage:[UIImage imageNamed:@"blue.png"] Lat:latitude Lng:longitude Anchor:CGPointMake(16.0, 32.0)];
}

+(id) defaultGreenMarkerWithLat:(double) latitude Lng:(double) longitude {
	return [[MapMarker alloc] initWithImage:[UIImage imageNamed:@"green.png"] Lat:latitude Lng:longitude Anchor:CGPointMake(16.0, 32.0)];	
}

+(id) defaultRedMarkerWithLat:(double) latitude Lng:(double) longitude {
	return [[MapMarker alloc] initWithImage:[UIImage imageNamed:@"red.png"] Lat:latitude Lng:longitude Anchor:CGPointMake(16.0, 32.0)];
}

+(id) defaultYellowMarkerWithLat:(double) latitude Lng:(double) longitude {
	return [[MapMarker alloc] initWithImage:[UIImage imageNamed:@"yellow.png"] Lat:latitude Lng:longitude Anchor:CGPointMake(16.0, 32.0)];
}


-(void) addTarget:(id) receiver action:(SEL) selector {
	Callback *markerAction = [[Callback alloc] initWithTarget:receiver action:selector withObject:self];
	[markerActions addObject:markerAction];
	[markerAction release];
}

- (void) pressEffect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	// TODO: some effects for pressing the marker
	[UIView commitAnimations];
}


-(void) moveToXY:(CGPoint) point {
	x = point.x;
	y = point.y;
	self.frame = CGRectMake(x - anchor.x, y - anchor.y, self.frame.size.width, self.frame.size.height);		
}

-(void) moveToLatLng:(GLatLng) latLng {
	if (mapView)
		[mapView moveMarker:self toLat:latLng.lat Lng:latLng.lng];
}


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count]) {
        case 1: {
            // potential drag
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			dragPoint = [touch locationInView:self];
			if (delegate && [delegate respondsToSelector:@selector(pressedMarker:)])
				[delegate pressedMarker:self ];

        } break;
            
            
        default:
            break;
    }
}

//------------------------------------------------------------------------------
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	if (!draggable)
		return;
	
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count]) {
        case 1: {
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
			CGPoint locationOnMapView = [touch locationInView:self.superview];
			CGPoint location = CGPointMake(locationOnMapView.x - (dragPoint.x - anchor.x), locationOnMapView.y - (dragPoint.y - anchor.y));
			
			[self moveToXY:location];
			if (delegate && [delegate respondsToSelector:@selector(draggedMarker:)])
				[delegate draggedMarker:self ];
			
        } break;
            
            
        default:
            break;
    }
}
//------------------------------------------------------------------------------
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    NSSet *allTouches = [event allTouches];
    
    switch ([allTouches count]) {
        case 1: {
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            switch (touch.tapCount) {
				case 0:
					if (draggable) {
						[self moveToLatLng:[mapView.map fromContainerPixelToLatLng:GPointMake(x, y)]];
						
						if (delegate && [delegate respondsToSelector:@selector(releasedMarker:)])
							[delegate releasedMarker:self ];
					}
					break;
					
                case 1:
					//[self pressEffect];
					if (delegate && [delegate respondsToSelector:@selector(clickedMarker:)])
						[delegate clickedMarker:self ];
						
					for (Callback *markerAction in markerActions) {
						[markerAction invoke];
					}
                    break;
					
                case 2: {
                } break;
            }
        } break;
    }

 }


-(void) show {
	if (mapView)
		[mapView showMarker:self];
}

-(void) dealloc {
	self.imageView = nil;
	self.data = nil;
	self.mapView = nil;
	[markerActions release];
	
	[super dealloc];
}

@end
