//
//  MapMarker.h
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


#import <UIKit/UIKit.h>
@class MapView;

@interface MapMarker : UIView {
	UIImageView *imageView;
	UIImage *markerImage;
	double lat;
	double lng;
	int x;
	int y;
	CGPoint anchor;
	BOOL draggable;
	CGPoint dragPoint;
	NSMutableArray *markerActions;
	MapView *mapView;
	id data;
	id delegate;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImage *markerImage;
@property double lat;
@property double lng;
@property int x;
@property int y;
@property CGPoint anchor;
@property (nonatomic, retain) id data;
@property (nonatomic, assign) MapView *mapView;
@property BOOL draggable;
@property (nonatomic, assign) id delegate;

+(id) defaultCrosshairsWithLat:(double) latitude Lng:(double) longitude;

+(id) defaultBlueMarkerWithLat:(double) latitude Lng:(double) longitude;

+(id) defaultGreenMarkerWithLat:(double) latitude Lng:(double) longitude;

+(id) defaultRedMarkerWithLat:(double) latitude Lng:(double) longitude my_image:(UIImage *)myImage;

+(id) defaultYellowMarkerWithLat:(double) latitude Lng:(double) longitude;

-(id) initWithUIImageView:(UIImageView *) aImageView Lat:(double) lat Lng:(double) lng Anchor:(CGPoint) anchor;
-(void) addTarget:(id) receiver action:(SEL) selector;
-(void) show;
@end

@interface MapMarker (MapMarkerDelegate)
-(void) clickedMarker:(MapMarker *) marker;
-(void) pressedMarker:(MapMarker *) marker;
-(void) draggedMarker:(MapMarker *) marker;
-(void) releasedMarker:(MapMarker *) marker;
@end

