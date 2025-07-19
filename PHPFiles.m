//
//  PHPIncludedObjects.m
//  noobtest
//
//  Created by siggi jokull on 19.1.2023.
//

#import "PHPFiles.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import "ContentLayout.h"
#import "FolderOperations.h"
#import "PHPSearch.h"

@implementation PHPFiles
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    PHPSearch* search = [[PHPSearch alloc] init];
    [search setInterpretation:[self interpretation]];
    //NSLog(@"setsearch : %@ %@ - %@", [self interpretation], self, [search interpretation]);
    [search init:context];


    [self setDictionaryValue:@"search" value:search];
    
    PHPScriptFunction* read_text = [[PHPScriptFunction alloc] init];
    [read_text initArrays];
    [self setDictionaryValue:@"read_text" value:read_text];
    [read_text setPrototype:self];
    [read_text setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSString* fileType = @"txt";
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        if([values[0] count] > 1) {
            fileType = [self_instance makeIntoString:[self_instance parseInputVariable:values[0][1]]];
        }
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            path = [[NSBundle mainBundle] pathForResource:path ofType:fileType];
            if([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
                NSString* stringValue = [NSString stringWithContentsOfFile:path
            encoding:NSUTF8StringEncoding
               error:NULL];
                return stringValue;
            }
            return @false; //[[self_instance interpretation] makeIntoObjects:@(is_dir_value)];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    PHPScriptFunction* open_folder = [[PHPScriptFunction alloc] init];
    [open_folder initArrays];
    [self setDictionaryValue:@"open_folder" value:open_folder];
    [open_folder setPrototype:self];
    [open_folder setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction *self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        if([input isKindOfClass:[NSString class]]) {
            /*NSString* path = (NSString*)input;
            path = [path stringByDeletingLastPathComponent];
            NSLog(@"path : %@", path);
            return path;*/
            NSURL* url = [[NSURL alloc] initFileURLWithPath:(NSString*)input];
            NSArray* fileUrls = @[url];
            [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileUrls];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    /*GERA PHPFiles klasa og setja oll videigandi foll sem scriptfunction fyrir noobscript
     
     NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath
     error:NULL];
    NSMutableArray *mp3Files = [[NSMutableArray alloc] init];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *filename = (NSString *)obj;
    NSString *extension = [[filename pathExtension] lowercaseString];
    if ([extension isEqualToString:@"mp3"]) {
    [mp3Files addObject:[sourcePath stringByAppendingPathComponent:filename]];
    }
    }];*/
    PHPScriptFunction* listFiles = [[PHPScriptFunction alloc] init];
    [listFiles initArrays];
    [self setDictionaryValue:@"list_files" value:listFiles];
    [listFiles setPrototype:self];
    [listFiles setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        //NSLog(@"list_files : %@", values);
        ////////////NSLog(@"input listfiles: %@", input);
        ////////////NSLog(@"input listfiles: %@", values);
        input = [self_instance parseInputVariable:input];
        ////////////NSLog(@"input listfiles: %@", input);
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            NSMutableArray* dirs = [[NSMutableArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL]];
            //NSLog(@"dirs : %@", dirs);
            //////////NSLog(@"dirs: %@", dirs);
            /*NSMutableArray* dirsParsed = [[NSMutableArray alloc] init];
            for(NSString* path in dirs) {
                ////////NSLog(@"path: %@", path);
                [dirsParsed addObject:@([path UTF8String])];
            }*/
            //////////NSLog(@"dirsparsed: %@", dirs);
            return [[self_instance getInterpretation] makeIntoObjects:dirs];
        }
        return [[PHPScriptObject alloc] init];
    } name:@"main"];
    
    PHPScriptFunction* get_extension = [[PHPScriptFunction alloc] init];
    [get_extension initArrays];
    [self setDictionaryValue:@"get_extension" value:get_extension];
    [get_extension setPrototype:self];
    [get_extension setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        //////////NSLog(@"get extension input: %@", input);
        //input = [[self_instance interpretation] toJSON:input];
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            /*NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
            return [[self_instance interpretation] makeIntoObjects:dirs];*/
            path = [path pathExtension];
            return [[self interpretation] makeIntoObjects:path];
        }
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* exists = [[PHPScriptFunction alloc] init];
    [exists initArrays];
    [self setDictionaryValue:@"exists" value:exists];
    [exists setPrototype:self];
    [exists setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        //input = [[self_instance interpretation] toJSON:input];
        //////////NSLog(@"exists value: %@", input);
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            /*NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
            return [[self_instance interpretation] makeIntoObjects:dirs];*/
            NSNumber* results = @(false);
            if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                //////////NSLog(@"exists");
                results = @(true);
            }
            //////////NSLog(@"not exists");
            return results;//[[self_instance interpretation] makeIntoObjects:results];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    
    
    PHPScriptFunction* is_dir = [[PHPScriptFunction alloc] init];
    [is_dir initArrays];
    [self setDictionaryValue:@"is_dir" value:is_dir];
    [is_dir setPrototype:self];
    [is_dir setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        //////////NSLog(@"input %@", input);
        //input = [[self interpretation] toJSON:input];
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            bool is_dir_value = false;
            if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&is_dir_value]) {
            }
            return @(is_dir_value); //[[self_instance interpretation] makeIntoObjects:@(is_dir_value)];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    PHPScriptFunction* partition_by_parent_folder = [[PHPScriptFunction alloc] init];
    [partition_by_parent_folder initArrays];
    [self setDictionaryValue:@"partition_by_parent_folder" value:partition_by_parent_folder];
    [partition_by_parent_folder setPrototype:self];
    [partition_by_parent_folder setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSObject* inputKey = values[0][1];
        inputKey = [self_instance parseInputVariable:inputKey];
        
        ToJSON* toJSON = [[ToJSON alloc] init];
        
        NSMutableArray* arrValue = [toJSON toJSON:input];
        NSString* keyValue = [toJSON toJSON:inputKey];
        
        FolderOperations* folderOperations = [[FolderOperations alloc] init];
        
        return [[self interpretation] makeIntoObjects:[folderOperations partitionByParentFolder:arrValue key:keyValue]];
    } name:@"main"];
    
    
    PHPScriptFunction* is_readable = [[PHPScriptFunction alloc] init];
    [is_readable initArrays];
    [self setDictionaryValue:@"is_readable" value:is_readable];
    [is_readable setPrototype:self];
    [is_readable setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            if([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
                return @true;
            }
            return @false; //[[self_instance interpretation] makeIntoObjects:@(is_dir_value)];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    PHPScriptFunction* append_path = [[PHPScriptFunction alloc] init];
    [append_path initArrays];
    [self setDictionaryValue:@"append_path" value:append_path];
    [append_path setPrototype:self];
    [append_path setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSObject* input_append = values[0][1];
        input_append = [self_instance parseInputVariable:input_append];
        if([input isKindOfClass:[NSString class]] && [input_append isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            NSString* path_append = (NSString*)input_append;
            return [path stringByAppendingPathComponent:path_append];
            /*if([[NSFileManager defaultManager] isReadableFileAtPath:path]) {
                return @true;
            }
            return @false;*/ //[[self_instance interpretation] makeIntoObjects:@(is_dir_value)];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    PHPScriptFunction* remove_path_component = [[PHPScriptFunction alloc] init];
    [remove_path_component initArrays];
    [self setDictionaryValue:@"remove_path_component" value:remove_path_component];
    [remove_path_component setPrototype:self];
    [remove_path_component setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        //NSLog(@"input : %@", input);
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            NSString* lastComponent = [path lastPathComponent];
            path = [path stringByDeletingLastPathComponent];
            //NSLog(@"path : %@", path);
            return [[self interpretation] makeIntoObjects:@{
                @"path": path,
                @"last_component": lastComponent
            }];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    PHPScriptFunction* first_path_component = [[PHPScriptFunction alloc] init];
    [first_path_component initArrays];
    [self setDictionaryValue:@"path_components" value:first_path_component];
    [first_path_component setPrototype:self];
    [first_path_component setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        //NSLog(@"input : %@", input);
        if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            return [[self interpretation] makeIntoObjects:[path pathComponents]];
        }
        return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    //[[NSFileManager defaultManager] isReadableFileAtPath:path]
    
    PHPScriptFunction* picker = [[PHPScriptFunction alloc] init];
    [picker initArrays];
    [self setDictionaryValue:@"picker" value:picker];
    [picker setPrototype:self];
    [picker setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSLog(@"picker : %@", values);
        NSObject* input = values[0][0];
        input = [self_instance resolveValueReferenceVariableArray:input];
        //input = [[self_instance interpretation] toJSON:input];
        
        //NSLog(@"values : %@",  values[0]);
        NSObject* input_directories = values[0][1];
        input_directories = [self_instance resolveValueReferenceVariableArray:input_directories];
        
        NSObject* multiple_files = values[0][2];
        multiple_files = [self_instance resolveValueReferenceVariableArray:multiple_files];
        
        NSObject* callback = values[0][3];
        callback = [self_instance resolveValueReferenceVariableArray:callback];
        
        /*NSNumber* skipWarning = @false;
        if(values[0][4] != nil) {
            skipWarning = values[0][4];
        }*/
        
        PHPScriptFunction* function = (PHPScriptFunction*)callback;
        /*if([input isKindOfClass:[NSString class]]) {
            NSString* path = (NSString*)input;
            bool is_dir_value = false;
            if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&is_dir_value]) {
            }
            return [[self_instance interpretation] makeIntoObjects:@(is_dir_value)];
        }*/
        dispatch_async(dispatch_get_main_queue(), ^{
            NSOpenPanel* openPanel = [[NSOpenPanel alloc] init];
            //[openPanel setCanChooseFiles:true];
            NSString* path = (NSString*)input;
            NSURL* directoryUrl = [[NSURL alloc] initFileURLWithPath:path];
            directoryUrl = [directoryUrl URLByDeletingLastPathComponent];
            //if([directoryUrl ])
            BOOL isDir = NO;
            if([[NSFileManager defaultManager]
                fileExistsAtPath:[directoryUrl path] isDirectory:&isDir] && isDir){
                [openPanel setDirectoryURL:directoryUrl];
            }
            [openPanel setCanChooseDirectories:[(NSNumber*)input_directories boolValue]];
            [openPanel setAllowsMultipleSelection:[(NSNumber*)multiple_files boolValue]];
            [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
                NSURL* url = [openPanel URL];
                //NSLog(@"selectedURL: %@", url);
                //PHPScriptVariable* stringResult = (PHPScriptVariable*)[[self interpretation] makeIntoObjects:@([url fileSystemRepresentation])];
                //NSLog(@"stringResult: %@ - %@", stringResult, [stringResult get]);
                NSMutableArray* valueArr = [[NSMutableArray alloc] initWithArray:@[@([url fileSystemRepresentation])]];
                NSMutableArray* arr = [[NSMutableArray alloc] initWithArray:@[valueArr]];
                [function callScriptFunctionSub:arr parameterValues:nil awaited:nil returnObject:nil interpretation:nil callback:nil];
            }];
        });
        return nil;
    } name:@"main"];
    
    PHPScriptFunction* write_to_file = [[PHPScriptFunction alloc] init];
    [write_to_file initArrays];
    [self setDictionaryValue:@"write_to_file" value:write_to_file];
    [write_to_file setPrototype:self];
    [write_to_file setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSString* part = (NSString*)values[0][1];
        part = (NSString*)[self_instance parseInputVariable:part];
        
        NSString* filePath = (NSString*)input;
        
        NSFileManager* manager = [NSFileManager defaultManager];
        if(![manager fileExistsAtPath:filePath]) {
            [manager createFileAtPath:filePath
                                            contents:[[NSData alloc] init]
                                            attributes:nil];
        }
        
        NSError *error;
        BOOL succeed = [part writeToFile:filePath
              atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!succeed){
            return @true;
        }
        
        return @"NULL";
        //return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    PHPScriptFunction* get_file_part = [[PHPScriptFunction alloc] init];
    [get_file_part initArrays];
    [self setDictionaryValue:@"get_file_part" value:get_file_part];
    [get_file_part setPrototype:self];
    [get_file_part setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSNumber* part = (NSNumber*)values[0][1];
        part = (NSNumber*)[self_instance parseInputVariable:part];
        
        NSString* filePath = (NSString*)input;
        
        long part_size = 2048*8*8;
        long offset = [part longLongValue]*part_size;
        
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        [fileHandle seekToFileOffset:offset];
        NSError* error;
        NSData* data = [fileHandle readDataUpToLength:part_size error:&error];
        NSString* encoded = [data base64EncodedStringWithOptions:0];
        return encoded;
        //return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    
    PHPScriptFunction* set_file_part = [[PHPScriptFunction alloc] init];
    [set_file_part initArrays];
    [self setDictionaryValue:@"set_file_part" value:set_file_part];
    [set_file_part setPrototype:self];
    [set_file_part setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSNumber* part = (NSNumber*)values[0][1];
        part = (NSNumber*)[self_instance parseInputVariable:part];
        
        NSString* partvalue = (NSString*)[self_instance makeIntoString:values[0][2]];
        
        NSString* filePath = (NSString*)input;
        
        NSFileManager* manager = [NSFileManager defaultManager];
        if(![manager fileExistsAtPath:filePath]) {
            [manager createFileAtPath:filePath
                                            contents:[[NSData alloc] init]
                                            attributes:nil];
        }
        long part_size = 2048*8*8;
        long offset = [part longLongValue]*part_size;
        
        NSFileHandle* fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        //[fileHandle seekToFileOffset:offset];
        [fileHandle seekToEndOfFile];
        NSError* error;
        /*NSData* data = [fileHandle readDataUpToLength:part_size error:&error];
        NSString* encoded = [data base64EncodedStringWithOptions:0];*/
        NSString* base64EncodedValue = partvalue;
        NSData* data = [[NSData alloc] initWithBase64EncodedString:base64EncodedValue options:0];
        [fileHandle writeData:data];
        
        //NSData* data = [base64EncodedValue dataUsingEncoding:NSUTF8StringEncoding];
        return nil;
        //return @(false);//[[self_instance interpretation] makeIntoObjects:@(false)];
    } name:@"main"];
    /**/
}

@end
