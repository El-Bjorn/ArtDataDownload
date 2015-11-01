- (void)sendRequest:(id)sender
{
    /* Configure session, choose between:
       * defaultSessionConfiguration
       * ephemeralSessionConfiguration
       * backgroundSessionConfigurationWithIdentifier:
     And set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];

    /* Create the Request:
       Sale Create (POST http://palette-dev.pacegallery.com/palette/sale/create)
     */

    NSURL* URL = [NSURL URLWithString:@"http://palette-dev.pacegallery.com/palette/sale/create"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";

    // Headers

    [request addValue:@"JSESSIONID=BCDD27867925BDFDFCB8FE3E973FD5F4" forHTTPHeaderField:@"Cookie"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    // JSON Body

    NSDictionary* bodyObject = @{
        @"dealers": @[
            @{
                @"paceContact": @{
                    @"id": @"73"
                },
                @"percentage": @1
            }
        ],
        @"soldForPrice": @2750000,
        @"retailPrice": @2750000,
        @"shippingOptionCode": @1,
        @"saleOrder": @{
            @"id": @571
        },
        @"soldDate": @"2015-10-04T07:03:04.912Z",
        @"commissions": @[
            @{
                @"amount": @0,
                @"currency": @"USD"
            }
        ],
        @"needReceipt": @NO,
        @"partnerIsSeller": @NO,
        @"charges": @[

        ],
        @"acquisitionId": @33269,
        @"invoiceComments": @"Invoice comments.",
        @"taxRate": @0.08875,
        @"taxAmount": @"244062.50",
        @"pgExhibitionSale": @NO,
        @"paymentRequiredCode": @1,
        @"retailPriceCurrency": @"USD",
        @"client": @{
            @"id": @4057
        },
        @"showDiscountOnInvoice": @NO,
        @"attachments": @[

        ],
        @"billingEntity": @{
            @"id": @"2"
        },
        @"alreadyDelivered": @NO,
        @"paidInFull": @NO,
        @"soldForPriceCurrency": @"USD",
        @"clientAddress": @{
            @"id": @547
        },
        @"paymentScheduleComment": @"Payment schedule commend.",
        @"payments": @[
            @{
                @"amount": @0,
                @"currency": @"USD",
                @"dueDate": @"2015-10-04T07:03:04.912Z"
            }
        ],
        @"taxStatus": @{
            @"id": @"14",
            @"active": @YES,
            @"name": @"NY Sales Tax - NYC",
            @"paceEntity": @{
                @"id": @2,
                @"value": @"The Pace Gallery LLC"
            },
            @"rate": @0.08875
        },
        @"displayPerItemPrice": @NO,
        @"shippingComments": @"Here are shipping comments",
        @"notes": @"Notes...comments...",
        @"paymentDueCode": @"0",
        @"paceContactId": @"73",
        @"shippingContactCode": @1,
        @"clientContact": @{
            @"id": @2031
        },
        @"provenanceAcquiredDirectFromArtist": @NO
    };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:NULL];

    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
