import { randomUUID } from "node:crypto";
import { PutObjectCommand, S3Client } from "@aws-sdk/client-s3";

class StorageR2Client {
  private static instance: StorageR2Client;
  private s3: S3Client;
  private readonly bucket: string;

  private constructor() {
    const bucket = process.env.S3_BUCKET;
    const accountId = process.env.S3_ACCOUNT_ID;
    const accessKeyId = process.env.S3_ACCESS_KEY_ID;
    const secretAccessKey = process.env.S3_SECRET_ACCESS_KEY;
    const endpoint = process.env.S3_ENDPOINT;

    if (!bucket || !accessKeyId || !secretAccessKey) {
      throw new Error(
        "Missing required S3 environment variables: S3_BUCKET, S3_ACCESS_KEY_ID, S3_SECRET_ACCESS_KEY",
      );
    }

    // Use custom endpoint (MinIO) if provided, otherwise use R2
    if (endpoint) {
      // Local development with MinIO or custom S3-compatible storage
      this.bucket = bucket;
      this.s3 = new S3Client({
        region: "auto",
        endpoint,
        credentials: {
          accessKeyId,
          secretAccessKey,
        },
        forcePathStyle: true, // Required for MinIO
      });
    } else {
      // Production with Cloudflare R2
      if (!accountId) {
        throw new Error(
          "S3_ACCOUNT_ID is required when S3_ENDPOINT is not provided (for Cloudflare R2)",
        );
      }
      this.bucket = bucket;
      this.s3 = new S3Client({
        region: "auto",
        endpoint: `https://${accountId}.eu.r2.cloudflarestorage.com`,
        credentials: {
          accessKeyId,
          secretAccessKey,
        },
      });
    }
  }

  public static getInstance(): StorageR2Client {
    if (!StorageR2Client.instance)
      StorageR2Client.instance = new StorageR2Client();
    return StorageR2Client.instance;
  }

  public async uploadFile(file: Buffer, ext = "png"): Promise<string> {
    const key = `${randomUUID()}.${ext}`;
    await this.s3.send(
      new PutObjectCommand({
        Bucket: this.bucket,
        Key: key,
        Body: file,
        ACL: "public-read",
        ContentType: `image/${ext}`,
      }),
    );
    return `${process.env.S3_PUBLIC_ENDPOINT!}/${key}`;
  }
}

export const storage = StorageR2Client.getInstance();
