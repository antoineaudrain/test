import type { RedisClientType } from "redis";
import { createClient } from "redis";

let client: RedisClientType | null = null;
let connectionAttempted = false;

export const getRedisClient = (): RedisClientType | null => {
  if (!process.env.REDIS_URL) {
    return null;
  }

  if (!connectionAttempted) {
    connectionAttempted = true;

    // Don't attempt connection during build time
    if (typeof window === "undefined" && !process.env.NEXT_RUNTIME) {
      console.warn("Redis connection skipped during build");
      return null;
    }

    try {
      const tempClient = createClient({
        url: process.env.REDIS_URL,
        socket: {
          connectTimeout: 5000,
          reconnectStrategy: false, // Don't reconnect on failure
        },
      });

      // Set up error handler before connecting
      tempClient.on("error", (err) => {
        console.warn("Redis error, falling back to in-memory:", err.message);
        client = null;
        // Ensure the client is properly disconnected
        tempClient.disconnect().catch(() => {});
      });

      // Connect asynchronously, but don't block
      tempClient
        .connect()
        .then(() => {
          client = tempClient as RedisClientType;
          console.log("Redis connected successfully");
        })
        .catch((err) => {
          console.warn(
            "Redis connection failed, using in-memory rate limiting:",
            err.message,
          );
          client = null;
          // Make sure to clean up the client
          tempClient.disconnect().catch(() => {});
        });
    } catch (err) {
      console.warn(
        "Redis initialization failed, using in-memory rate limiting:",
        err,
      );
      client = null;
    }
  }

  // Return null while connecting or if connection failed
  return client;
};
