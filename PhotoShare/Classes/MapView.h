/*
 * Copyright (c) 2008, eSpace Technologies.
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

#import "MapWebView.h"
#import "MapMarker.h"

@interface MapView : UIView <MapWebViewDelegate> {
	
	id delegate;
	
@protected
    MapWebView *mMapWebView;
    int         mTouchMovedEventCounter;
    CGPoint     mLastTouchLocation;
    CGFloat     mLastTouchSpacing;
    SEL         mOnClickHandler;
	
	// Marker support
	NSMutableArray *markers;

}
@property (readonly, getter = map) MapWebView* mMapWebView;
@property (readwrite, getter = onClickHandler, setter = onClickHandler:) SEL mOnClickHandler;

// Marker support
@property (nonatomic,retain) id delegate;

-(void) addMarker:(MapMarker *) marker;
-(void) addMarkerWithImage:(UIImageView *) markerImage Lat:(double) lat Lng:(double) lng Anchor:(CGPoint) anchor;
-(void) clearMarkers;
-(void) moveMarker:(MapMarker *) marker toLat:(double) latitude Lng:(double) longitude;
-(void) zoomToShowMarkers:(NSArray *) markersArray;
-(void) showMarkers;
-(void) showMarker:(MapMarker *) marker;
-(void) positionMarkers;

@end

@interface MapView (MapViewDelegate)

//-- Touch Events Handling Methods ---------------------------------------------
- (void) mapTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
//------------------------------------------------------------------------------
- (void) mapTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
//------------------------------------------------------------------------------
- (void) mapTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;

@end
