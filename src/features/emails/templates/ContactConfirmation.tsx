type ConfirmationEmailProps = {
  name: string;
};

export function ContactConfirmation({ name }: ConfirmationEmailProps) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta httpEquiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Message reçu !</title>
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
                background: `linear-gradient(135deg, #10b981 0%, #059669 100%)`,
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
                  fontSize: "30px",
                  color: "#ffffff",
                }}
              >
                ✓
              </div>
              <h1
                style={{
                  margin: 0,
                  color: "#ffffff",
                  fontSize: "28px",
                  fontWeight: 600,
                }}
              >
                Message reçu !
              </h1>
              <p
                style={{
                  margin: "12px 0 0",
                  color: "rgba(255,255,255,0.9)",
                  fontSize: "16px",
                }}
              >
                Nous répondrons sous 24h
              </p>
            </td>
          </tr>

          <tr>
            <td style={{ padding: "40px 30px" }}>
              <p
                style={{
                  margin: "0 0 20px",
                  color: "#374151",
                  fontSize: "18px",
                  fontWeight: 500,
                }}
              >
                Bonjour <strong>{name}</strong>,
              </p>

              <p
                style={{
                  margin: "0 0 20px",
                  color: "#374151",
                  fontSize: "16px",
                }}
              >
                Merci de nous avoir contactés ! Nous avons bien reçu votre
                message et nous vous répondrons dans les 24 heures.
              </p>

              <p
                style={{
                  margin: "0 0 30px",
                  color: "#374151",
                  fontSize: "16px",
                }}
              >
                Nous apprécions votre intérêt et avons hâte d'échanger avec vous
                très bientôt.
              </p>
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
                Cordialement,
                <br />
                L'équipe TDS
              </p>
            </td>
          </tr>
        </table>
      </body>
    </html>
  );
}
