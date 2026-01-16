export class EmailSendError extends Error {
  constructor(
    message: string,
    public cause?: unknown,
  ) {
    super(message);
    this.name = "EmailSendError";
  }
}
