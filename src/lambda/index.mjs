import { DynamoDBClient, UpdateItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({});
const TABLE_NAME = process.env.TABLE_NAME;

const respond = (statusCode, body) => ({
  statusCode,
  headers: {
    "content-type": "application/json",
    "cache-control": "no-store",
  },
  body: JSON.stringify(body),
});

export const handler = async (event) => {
  const method = event.requestContext?.http?.method;

  if (method !== "GET" || event.rawPath !== "/api/count") {
    return respond(404, { message: "Not Found" });
  }

  try {
    // ADD is atomic, so concurrent requests cannot lose increments. "count" is a reserved word.
    const result = await client.send(
      new UpdateItemCommand({
        TableName: TABLE_NAME,
        Key: { id: { S: "campaign" } },
        UpdateExpression: "ADD #count :increment",
        ExpressionAttributeNames: { "#count": "count" },
        ExpressionAttributeValues: { ":increment": { N: "1" } },
        ReturnValues: "UPDATED_NEW",
      })
    );

    return respond(200, { count: Number(result.Attributes.count.N) });
  } catch (error) {
    console.error("campaign counter update failed:", error.name, error.message);
    return respond(503, { message: "Service Unavailable" });
  }
};
