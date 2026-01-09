import { randomUUID } from "crypto";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, PutCommand } from "@aws-sdk/lib-dynamodb";

const ddb = DynamoDBDocumentClient.from(new DynamoDBClient({}));

export async function putItemHandler(event) {
  try {
    const table = process.env.TRANSACTIONS_TABLE;

    const userId =
      event.headers?.["x-user-id"] ||
      event.headers?.["X-User-Id"];

    if (!userId) {
      return json(400, { error: "Missing x-user-id header" });
    }

    const body = event.body ? JSON.parse(event.body) : null;
    if (!body?.name || body?.amount == null || !body?.date) {
      return json(400, { error: "Missing required fields: name, amount, date" });
    }

    // Recommended: YYYY-MM-DD
    const date = body.date;
    const txnId = randomUUID();

    const item = {
      userId,
      sortKey: `txn#${date}#${txnId}`,
      txnId,
      name: body.name,
      amount: Number(body.amount),
      date,
      category: body.category ?? "Other",
      createdAt: new Date().toISOString(),
    };

    await ddb.send(new PutCommand({ TableName: table, Item: item }));

    return json(201, { transaction: item });
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
