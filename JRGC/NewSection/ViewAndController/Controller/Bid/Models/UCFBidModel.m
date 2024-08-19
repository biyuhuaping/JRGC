//
//Created by ESJsonFormatForMac on 18/12/14.
//

#import "UCFBidModel.h"
@implementation UCFBidModel


@end

@implementation BidDataModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"contractMsg" : [ContractModel class]};
}


@end


@implementation PrdclaimModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation ContractModel


@end


