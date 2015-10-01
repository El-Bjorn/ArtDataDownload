//
//  NSObject+NSObject_Blocks.m
//  Palette
//
//  Created by BjornC on 8/19/15.
//  Copyright © 2015 Built Light. All rights reserved.
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)

-(void) performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    //dispatch_after(delayTime, dispatch_get_main_queue(), block);
    dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}


@end
