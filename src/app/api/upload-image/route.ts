import { type NextRequest, NextResponse } from "next/server";
import sharp from "sharp";
import { storage } from "@/lib/storage/r2";

export const POST = async (req: NextRequest) => {
  try {
    const arrayBuffer = await req.arrayBuffer().catch(() => {
      throw new Error("Invalid request body: must be a binary file");
    });

    const buffer = Buffer.from(arrayBuffer);

    const avif = await sharp(buffer)
      .resize(800, null, { withoutEnlargement: true })
      .avif({ quality: 45, effort: 4, chromaSubsampling: "4:2:0" })
      .toBuffer()
      .catch((err) => {
        throw new Error(`Image processing failed: ${err.message}`);
      });

    const url = await storage.uploadFile(avif, "avif").catch((err) => {
      throw new Error(`Storage upload failed: ${err.message}`);
    });

    return NextResponse.json({ url });
  } catch (err) {
    console.error("Image upload error:", err);
    return NextResponse.json(
      { error: err instanceof Error ? err.message : "Unknown error" },
      { status: 500 },
    );
  }
};
