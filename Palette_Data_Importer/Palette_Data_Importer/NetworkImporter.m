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
                    //NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*)response;
                    /*NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResp allHeaderFields] forURL:[response URL]];
                    for (NSHTTPCookie *cookie in cookies) {
                        NSLog(@"cookies = %@",cookie);
                    }
                    NSLog(@"complete resp= %@, err= %@",response,error); */
                    self.authenticated = YES;
                    /*[self downloadInfoForPGid:53852
                          withCompBlock:^(NSDictionary *dict, NSError *err)
                                        { NSLog(@"art info= %@",dict); }]; */
                    [self pgidsForIndex:0 withCompBlock:^(NSArray *pgids, NSError *err) {
                        NSLog(@"pgids = %@",pgids);
                    }];
    }];
    [task resume];
}

-(void) pgidsForIndex:(int)index withCompBlock:(void (^)(NSArray *pgids, NSError *err))compBlk {
    NSURL *url = [NSURL URLWithString:@"http://palette-dev.pacegallery.com/palette/search/filter/ajax/get"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postString = [NSString stringWithFormat:@"index=%d&sortType=SORT_TYPE_RELEVANCY_DESC",index];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    NSError *err = nil;
                    NSMutableArray *pgidList = [[NSMutableArray alloc] init];
                    NSDictionary *ajaxResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                    //NSLog(@"ajaxResults = %@",ajaxResults);
                    NSArray *results = ajaxResults[@"data"][@"results"];
                    //NSLog(@"results= %@",results);
                    for (NSDictionary *d in results) {
                        //NSLog(@"pgid= %@",d[@"artworkPgNumber"]);
                        [pgidList addObject:d[@"artworkPgNumber"]];
                    }
                    compBlk(pgidList,error);

                                                    
                                                    
    }];
    [task resume];
    
    
}

-(void) downloadInfoForPGid:(int)pgid
        withCompBlock:(void (^)(NSDictionary*dict, NSError *err))compBlk
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://palette-dev.pacegallery.com/palette/artwork/infofragment?pgNumber=%d",pgid]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"url = %@",url);
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        //NSLog(@"response= %@, err= %@",response,error);
                        NSError *err = nil;
                        NSDictionary *artInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                        //NSLog(@"art info= %@",artInfo);
                                                    
                        compBlk(artInfo,error);
    }];
    [task resume];
}

@end
