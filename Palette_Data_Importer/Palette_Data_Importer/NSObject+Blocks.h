//
//  NSObject+NSObject_Blocks.h
//  Palette
//
//  Created by BjornC on 8/19/15.
//  Copyright © 2015 Built Light. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

-(void) performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
