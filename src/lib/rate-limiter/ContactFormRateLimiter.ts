import { createHash } from "node:crypto";
import { headers } from "next/headers";
import { Time } from "@/lib/time";
import { getRedisClient } from "./redisClient";

interface Result {
  allowed: boolean;
  remaining: number;
  reset: number;
  used: number;
}

class ContactFormRateLimiter {
  private static instance: ContactFormRateLimiter;
  private client: ReturnType<typeof getRedisClient> = null;
  private clientInitialized = false;
  private prefix = "rl:contactForm";
  private memoryStore = new Map<string, { timestamp: number }>();
  private cleanupInterval?: NodeJS.Timeout;

  private constructor() {
    // Don't initialize client in constructor
  }

  private getClient() {
    if (!this.clientInitialized) {
      this.clientInitialized = true;
      this.client = getRedisClient();
      if (!this.client) {
        console.warn("Redis not available, using in-memory rate limiting");
        // Only set up cleanup interval if we're using in-memory storage
        if (typeof setInterval !== "undefined") {
          this.cleanupInterval = setInterval(
            () => this.cleanupMemoryStore(),
            3600000,
          );
        }
      }
    }
    return this.client;
  }

  static getInstance(): ContactFormRateLimiter {
    if (!ContactFormRateLimiter.instance) {
      ContactFormRateLimiter.instance = new ContactFormRateLimiter();
    }
    return ContactFormRateLimiter.instance;
  }

  private async generateVisitorId(): Promise<string> {
    try {
      const headersList = await headers();

      const ip =
        headersList.get("x-forwarded-for") ||
        headersList.get("cf-connecting-ip") ||
        "unknown-ip";

      const ua = headersList.get("user-agent") || "unknown-ua";

      return createHash("sha256")
        .update(ip + ua)
        .digest("hex")
        .slice(0, 16);
    } catch (_err) {
      // During build time, headers() is not available
      return "build-time-visitor";
    }
  }

  private key(id: string, dateKey: string) {
    return `${this.prefix}:${id}:${dateKey}`;
  }

  private cleanupMemoryStore() {
    const now = Date.now();
    const dayInMs = 86400000;
    for (const [key, value] of this.memoryStore.entries()) {
      if (now - value.timestamp > dayInMs) {
        this.memoryStore.delete(key);
      }
    }
  }

  async submit(points = 1): Promise<Result> {
    const visitorId = await this.generateVisitorId();
    const dateKey = Time().toISOString().slice(0, 10);
    const redisKey = this.key(visitorId, dateKey);

    const client = this.getClient();

    if (!client) {
      const exists = this.memoryStore.has(redisKey);
      if (!exists) {
        this.memoryStore.set(redisKey, { timestamp: Date.now() });
      }
      return {
        allowed: !exists,
        remaining: exists ? 0 : points - 1,
        reset: Math.floor(Date.now() / 1000) + 86400,
        used: exists ? points : 1,
      };
    }

    try {
      const success = await client.set(redisKey, "1", {
        NX: true,
        EX: 86400,
      });
      const allowed = success === "OK";

      return {
        allowed,
        remaining: allowed ? points - 1 : 0,
        reset: Math.floor(Date.now() / 1000) + 86400,
        used: allowed ? 1 : points,
      };
    } catch (err) {
      console.warn("Redis operation failed, falling back to in-memory:", err);
      this.client = null;
      this.clientInitialized = false;
      // Fallback to memory store
      const exists = this.memoryStore.has(redisKey);
      if (!exists) {
        this.memoryStore.set(redisKey, { timestamp: Date.now() });
      }
      return {
        allowed: !exists,
        remaining: exists ? 0 : points - 1,
        reset: Math.floor(Date.now() / 1000) + 86400,
        used: exists ? points : 1,
      };
    }
  }

  async peek(): Promise<Result> {
    const visitorId = await this.generateVisitorId();
    const dateKey = Time().toISOString().slice(0, 10);
    const redisKey = this.key(visitorId, dateKey);

    if (!this.client) {
      const exists = this.memoryStore.has(redisKey);
      return {
        allowed: !exists,
        remaining: exists ? 0 : 1,
        reset: Math.floor(Date.now() / 1000) + 86400,
        used: exists ? 1 : 0,
      };
    }

    try {
      const exists = await this.client.exists(redisKey);
      const allowed = exists === 0;

      return {
        allowed,
        remaining: allowed ? 1 : 0,
        reset: Math.floor(Date.now() / 1000) + 86400,
        used: allowed ? 0 : 1,
      };
    } catch (err) {
      console.warn("Redis operation failed, falling back to in-memory:", err);
      this.client = null;
      // Fallback to memory store
      const exists = this.memoryStore.has(redisKey);
      return {
        allowed: !exists,
        remaining: exists ? 0 : 1,
        reset: Math.floor(Date.now() / 1000) + 86400,
        used: exists ? 1 : 0,
      };
    }
  }
}

export const contactFormRateLimiter = ContactFormRateLimiter.getInstance();
