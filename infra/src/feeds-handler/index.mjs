export async function handler(event, context) {
  const body = JSON.stringify({ hello: "world" });
  const statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };

  return {
    statusCode,
    body,
    headers,
  };
}
