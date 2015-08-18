//
//  main.m
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStorage.h"
#import "NetworkImporter.h"

DataStorage *ds = nil;

// when we're done importing
dispatch_semaphore_t done_sema;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        done_sema = dispatch_semaphore_create(0);
        
        ds = [[DataStorage alloc] init];
        NetworkImporter *ni = [[NetworkImporter alloc] init];
        [ni authenticate];
        
        while (dispatch_semaphore_wait(done_sema, DISPATCH_TIME_NOW)) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        }
        NSLog(@"ok we're done");
        
    }
    return 0;
}
