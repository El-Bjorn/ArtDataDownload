//
//  NetworkImporter.m
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "NetworkImporter.h"
#import "Artwork.h"
#import "DataStorage.h"

extern DataStorage *ds;

@implementation NetworkImporter

-(instancetype) init {
    self = [super init];
    if (self) {
        self.urlsession = [NSURLSession sharedSession];
        self.authenticated = NO;
    }
    return self;
}

int num_artworks = 0;

-(void) authenticate {
    NSURL *url = [NSURL URLWithString:@"http://palette-dev.pacegallery.com/palette/j_spring_security_check"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *postString = @"j_username=charnden&j_password=Palette3";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionTask *task = [self.urlsession dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error)
    {
        // we're authenticated
        int i;
        for (i=0; i< 100 ; i++ ) {
            [self artArrayForIndex:i withCompBlock:^(NSArray *artDicts, NSError *err) {
                NSLog(@"got artwork array: %@",artDicts);
                for (NSDictionary *d in artDicts) {
                    Artwork *a = [self createArtworkFromArtDict:d];
                    NSLog(@"created artwork: %@",a);
                    printf("number of artworks created: %d\n",++num_artworks);
                }
                //NSLog(@"artDicts = %@",artDicts);
            }];

        }
        
    }];
    [task resume];
}


// retrieves array of 10 art piece dictionaries
-(void) artArrayForIndex:(int)index withCompBlock:(void (^)(NSArray *artDict, NSError *err))compBlk {
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
                        [pgidList addObject:d];
                    }
                    compBlk(pgidList,error);
    }];
    [task resume];
}

#define WIDTH_KEY @"artworkImageWidth"
#define HEIGHT_KEY @"artworkImageHeight"

-(Artwork*) createArtworkFromArtDict:(NSDictionary*)dict {
    NSLog(@"creating artwork....");
    Artwork *newArt = [NSEntityDescription insertNewObjectForEntityForName:@"Artwork" inManagedObjectContext:ds.context];
    newArt.paceID = dict[@"artworkPgNumber"];
    newArt.artistNames = dict[@"artistName"];
    newArt.title = dict[@"artworkTitle"];
    newArt.creationDate =  dict[@"artworkDate"];//dict[@"artworkYearTo"];
    newArt.statusLabel = dict[@"acquisitionStatusLabel"];
    if (![dict[WIDTH_KEY] isKindOfClass:[NSNull class]]) {
        newArt.artworkImageWidth = dict[WIDTH_KEY];
    }
    if (![dict[HEIGHT_KEY] isKindOfClass:[NSNull class]]) {
        newArt.artworkImageHeight = dict[HEIGHT_KEY];
    }
    NSError *savErr = nil;
    [ds.context save:&savErr];
    if (savErr) {
        NSLog(@"Error saving artwork to context: %@",savErr);
    }
    return newArt;
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
