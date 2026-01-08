import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, QueryCommand } from "@aws-sdk/lib-dynamodb";

const ddb = DynamoDBDocumentClient.from(new DynamoDBClient({}));

export async function getAllItemsHandler(event) {
  try {
    const table = process.env.TRANSACTIONS_TABLE;

    // MVP auth: userId comes from header (replace later with JWT)
    const userId =
      event.headers?.["x-user-id"] ||
      event.headers?.["X-User-Id"];

    if (!userId) {
      return json(400, { error: "Missing x-user-id header" });
    }

    const limit = Number(event.queryStringParameters?.limit ?? 25);

    const cmd = new QueryCommand({
      TableName: table,
      KeyConditionExpression: "userId = :u",
      ExpressionAttributeValues: { ":u": userId },
      ScanIndexForward: false, // newest first
      Limit: limit,
    });

    const result = await ddb.send(cmd);

    return json(200, { transactions: result.Items ?? [] });
  } catch (err) {
    console.error(err);
    return json(500, { error: "Internal error" });
  }
}

function json(statusCode, body) {
  return {
    statusCode,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  };
}
