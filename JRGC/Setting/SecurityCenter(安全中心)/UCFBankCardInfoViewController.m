
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",self.fromSite,@"fromSite",nil];
    [[NetworkModule sharedNetworkModule]newPostReq:strParameters tag:kSXTagBankInfoNew owner:self signature:YES Type:self.accoutType];
    return 1;
}

@end
