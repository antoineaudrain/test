import { Time } from "@/lib/time";

type DeliveryCreatedNotificationProps = {
  clientName: string;
  requestedDate: Date;
};

export function DeliveryCreatedNotification({
  clientName,
  requestedDate,
}: DeliveryCreatedNotificationProps) {
  const timestamp = Time().format("D MMMM YYYY, HH:mm");

  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta httpEquiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Nouvelle demande de livraison</title>
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
                background: `linear-gradient(135deg, #155dfc 0%, #22c55e 100%)`,
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
                📦
              </div>
              <h1
                style={{
                  margin: 0,
                  color: "#ffffff",
                  fontSize: "28px",
                  fontWeight: 600,
                }}
              >
                Nouvelle demande de livraison
              </h1>
              <p
                style={{
                  margin: "12px 0 0",
                  color: "rgba(255,255,255,0.9)",
                  fontSize: "16px",
                }}
              >
                Un client a fait une demande
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
                  borderLeft: `4px solid #22c55e`,
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
                      Détails de la demande
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
                              CLIENT
                            </span>
                            <p
                              style={{
                                margin: "4px 0 0 0",
                                color: "#1e293b",
                                fontSize: "16px",
                                fontWeight: 500,
                              }}
                            >
                              {clientName}
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
                              DATE DEMANDÉE
                            </span>
                            <p
                              style={{
                                margin: "4px 0 0 0",
                                color: "#1e293b",
                                fontSize: "16px",
                                fontWeight: 500,
                              }}
                            >
                              {Time(requestedDate).format("D MMMM YYYY, HH:mm")}
                            </p>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
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
                Notification automatique • {timestamp}
              </p>
            </td>
          </tr>
        </table>
      </body>
    </html>
  );
}
