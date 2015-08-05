//
//  NetworkImporter.m
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "NetworkImporter.h"

@implementation NetworkImporter

-(instancetype) init {
    self = [super init];
    if (self) {
        self.urlsession = [NSURLSession sharedSession];
        self.authenticated = NO;
    }
    return self;
}

-(void) authenticate {
    NSURL *url = [NSURL URLWithString:@"http://palette-dev.pacegallery.com/palette/j_spring_security_check"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postString = @"j_username=charnden&j_password=Palette3";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error){
                    NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
                    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResp allHeaderFields] forURL:[response URL]];
                    for (NSHTTPCookie *cookie in cookies) {
                        NSLog(@"cookies = %@",cookie);
                    }
                    NSLog(@"complete resp= %@, err= %@",response,error);
                    self.authenticated = YES;
                                                    [self downloadInfoForPGid:53852];
    }];
    [task resume];
}

-(void) downloadInfoForPGid:(int)pgid {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://palette-dev.pacegallery.com/palette/artwork/infofragment?pgNumber=%d",pgid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"url = %@",url);
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        NSLog(@"response= %@, err= %@",response,error);
                        NSError *err = nil;
                        NSDictionary *artInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                        NSLog(@"art info= %@",artInfo);
    }];
    [task resume];
}

@end
