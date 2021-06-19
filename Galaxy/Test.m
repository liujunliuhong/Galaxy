//
//  Test.m
//  Galaxy
//
//  Created by galaxy on 2021/6/19.
//

#import "Test.h"

@implementation Test

- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSMutableData *scriptData = [NSMutableData data];
//        NSString *str = @"1";
//        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        uint8_t len = (uint8_t)data.length;
//        [scriptData appendBytes:&len length:sizeof(len)];
//        NSLog(@"%@", scriptData);
        
        NSString *str = @"abcdef";
        NSData *scriptData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        const uint8_t *bytes = ((const uint8_t*)[scriptData bytes]);
        uint8_t opcode = 0x4c;
        NSInteger offset = 2;
        
        uint8_t dataLength;
        const unsigned char *value = bytes + offset + sizeof(opcode);
        NSLog(@"%s", value);
//        memcpy(&dataLength, value, sizeof(dataLength));
//        NSLog(@"%d", dataLength);
        NSLog(@"22");
    }
    return self;
}
@end
