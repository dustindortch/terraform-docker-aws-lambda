// using System;
using System.Net;
using System.Collections.Generic;
using Amazon.Lambda.Core;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Annotations;
using Amazon.Lambda.Annotations.APIGateway;
using Newtonsoft.Json;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace HelloWorld;

public class Handler
{
    /// <summary>
    /// Default constructor that Lambda will invoke.
    /// </summary>
    public Handler()
    {
    }


    /// <summary>
    /// A Lambda function to respond to HTTP Get methods from API Gateway
    /// </summary>
    /// <remarks>
    /// This uses the <see href="https://github.com/aws/aws-lambda-dotnet/blob/master/Libraries/src/Amazon.Lambda.Annotations/README.md">Lambda Annotations</see> 
    /// programming model to bridge the gap between the Lambda programming model and a more idiomatic .NET model.
    /// 
    /// This automatically handles reading parameters from an APIGatewayProxyRequest
    /// as well as syncing the function definitions to serverless.template each time you build.
    /// 
    /// If you do not wish to use this model and need to manipulate the API Gateway 
    /// objects directly, see the accompanying Readme.md for instructions.
    /// </remarks>
    /// <param name="context">Information about the invocation, function, and execution environment</param>
    /// <returns>The response as an implicit <see cref="APIGatewayProxyResponse"/></returns>
    // [LambdaFunction]
    // [RestApi(LambdaHttpMethod.Get, "/")]
    public APIGatewayProxyResponse Hello(APIGatewayProxyRequest request, ILambdaContext context)
    {
        context.Logger.LogLine("context: " + context);
        if (request.HttpMethod != "POST")
        {
            return new APIGatewayProxyResponse
            {
                StatusCode = (int)HttpStatusCode.MethodNotAllowed,
                Body = "Method Not Allowed"
            };
        }

        APIGatewayProxyResponse response;


        Dictionary<string, string> dict = new Dictionary<string, string>();
        context.Logger.LogLine("Request: " + JsonConvert.SerializeObject(request));
        context.Logger.LogLine($"Body: {request}");

        var greeting = "World";
        var message = $"Hello, {greeting}!";

        dict.Add("message", message);

        response = CreateResponse(dict);

        return response;
    }

    APIGatewayProxyResponse CreateResponse(IDictionary<string, string> result)
    {
        int statusCode = (result != null) ?
            (int)HttpStatusCode.OK :
            (int)HttpStatusCode.InternalServerError;

        string body = (result != null) ?
            JsonConvert.SerializeObject(result) : string.Empty;

        var response = new APIGatewayProxyResponse
        {
            StatusCode = statusCode,
            Body = body,
            Headers = new Dictionary<string, string>
            {
                { "Content-Type", "application/json" }
            }
        };

        return response;
    }
}
