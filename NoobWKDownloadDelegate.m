//
//  NoobWKDownloadDelegate.m
//  noobtest
//
//  Created by siggi jokull on 15.7.2023.
//


#import "NoobWKDownloadDelegate.h"
//#import "PHPInterpretation.h"

@interface NoobWKDownloadDelegate ()


@end

@implementation NoobWKDownloadDelegate

- (void) download:(WKDownload *)download decideDestinationUsingResponse:(NSURLResponse *)response suggestedFilename:(NSString *)suggestedFilename completionHandler:(void (^)(NSURL * _Nullable))completionHandler {
    //NSURL* destination = [[NSURL alloc] initFileURLWithPath:""]
    //completionHandler(destination);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSURL* containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.noob.player"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library"];
    containerURL = [containerURL URLByAppendingPathComponent:@"Documents"];
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSURL* destination = [containerURL URLByAppendingPathComponent:suggestedFilename];
    completionHandler(destination);
}

- (void) downloadDidFinish:(WKDownload *)download {
    //////NSLog(@"did finish");
}


@end
