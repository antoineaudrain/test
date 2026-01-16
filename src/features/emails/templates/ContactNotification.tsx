import { Time } from "@/lib/time";

type NotificationEmailProps = {
  name: string;
  email: string;
  message: string;
};

export function ContactNotification({
  name,
  email,
  message,
}: NotificationEmailProps) {
  const timestamp = Time().format("D MMMM YYYY, HH:mm");

  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta httpEquiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Nouveau message de contact</title>
      </head>
      <body
        style={{
          margin: 0,
          padding: 0,
          fontFamily:
            '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
          backgroundColor: "#f8fafc",
          lineHeight: 1.6,
        }}
      >
        <table
          cellPadding="0"
          cellSpacing="0"
          border={0}
          style={{
            width: "100%",
            maxWidth: "600px",
            margin: "0 auto",
            backgroundColor: "#ffffff",
          }}
        >
          <tr>
            <td
              style={{
                background: `linear-gradient(135deg, #155dfc 0%, #764ba2 100%)`,
                padding: "40px 30px",
                textAlign: "center",
              }}
            >
              <div
                style={{
                  width: "60px",
                  height: "60px",
                  backgroundColor: "rgba(255,255,255,0.2)",
                  borderRadius: "50%",
                  margin: "0 auto 20px",
                  display: "flex",
                  alignItems: "center",
                  justifyContent: "center",
                  fontSize: "24px",
                  color: "#ffffff",
                }}
              >
                🔥
              </div>
              <h1
                style={{
                  margin: 0,
                  color: "#ffffff",
                  fontSize: "28px",
                  fontWeight: 600,
                }}
              >
                Nouveau Lead !
              </h1>
              <p
                style={{
                  margin: "12px 0 0",
                  color: "rgba(255,255,255,0.9)",
                  fontSize: "16px",
                }}
              >
                Un prospect vous a contacté
              </p>
            </td>
          </tr>

          <tr>
            <td style={{ padding: "40px 30px" }}>
              <table
                cellPadding="0"
                cellSpacing="0"
                border={0}
                style={{
                  width: "100%",
                  backgroundColor: "#f1f5f9",
                  borderRadius: "12px",
                  padding: "24px",
                  marginBottom: "30px",
                  borderLeft: `4px solid #155dfc`,
                }}
              >
                <tr>
                  <td>
                    <h2
                      style={{
                        margin: "0 0 16px 0",
                        color: "#1e293b",
                        fontSize: "18px",
                        fontWeight: 600,
                      }}
                    >
                      Informations de contact
                    </h2>

                    <table
                      cellPadding="0"
                      cellSpacing="0"
                      border={0}
                      style={{ width: "100%" }}
                    >
                      <tr>
                        <td style={{ paddingBottom: "12px" }}>
                          <div>
                            <span
                              style={{
                                color: "#64748b",
                                fontSize: "14px",
                                fontWeight: 500,
                                textTransform: "uppercase",
                                letterSpacing: "0.5px",
                              }}
                            >
                              NOM
                            </span>
                            <p
                              style={{
                                margin: "4px 0 0 0",
                                color: "#1e293b",
                                fontSize: "16px",
                                fontWeight: 500,
                              }}
                            >
                              {name}
                            </p>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td style={{ paddingBottom: "12px" }}>
                          <div>
                            <span
                              style={{
                                color: "#64748b",
                                fontSize: "14px",
                                fontWeight: 500,
                                textTransform: "uppercase",
                                letterSpacing: "0.5px",
                              }}
                            >
                              EMAIL
                            </span>
                            <p
                              style={{
                                margin: "4px 0 0 0",
                                color: "#1e293b",
                                fontSize: "16px",
                              }}
                            >
                              <a
                                href={`mailto:${email}`}
                                style={{
                                  color: "#155dfc",
                                  textDecoration: "none",
                                }}
                              >
                                {email}
                              </a>
                            </p>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>

              <div>
                <h2
                  style={{
                    margin: "0 0 16px 0",
                    color: "#1e293b",
                    fontSize: "18px",
                    fontWeight: 600,
                  }}
                >
                  Message
                </h2>
                <div
                  style={{
                    backgroundColor: "#ffffff",
                    border: "1px solid #e2e8f0",
                    borderRadius: "8px",
                    padding: "20px",
                    color: "#374151",
                    fontSize: "15px",
                    whiteSpace: "pre-wrap",
                  }}
                >
                  {message}
                </div>
              </div>
            </td>
          </tr>

          <tr>
            <td
              style={{
                backgroundColor: "#f8fafc",
                padding: "20px 30px",
                textAlign: "center",
                borderTop: "1px solid #e2e8f0",
              }}
            >
              <p
                style={{
                  margin: 0,
                  color: "#64748b",
                  fontSize: "13px",
                }}
              >
                Envoyé depuis votre formulaire de contact • {timestamp}
              </p>
            </td>
          </tr>
        </table>
      </body>
    </html>
  );
}
