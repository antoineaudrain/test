type AccountActivationNotificationProps = {
  firstName: string;
  lastName: string;
  companyName: string;
  activationUrl: string;
};

export function AccountActivationNotification({
  firstName,
  lastName,
  companyName,
  activationUrl,
}: AccountActivationNotificationProps) {
  return (
    <html lang="fr">
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta httpEquiv="Content-Type" content="text/html; charset=UTF-8" />
        <title>Activez votre compte</title>
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
                🎉
              </div>
              <h1
                style={{
                  margin: 0,
                  color: "#ffffff",
                  fontSize: "28px",
                  fontWeight: 600,
                }}
              >
                Bienvenue sur TDS Transports
              </h1>
              <p
                style={{
                  margin: "12px 0 0",
                  color: "rgba(255,255,255,0.9)",
                  fontSize: "16px",
                }}
              >
                Votre compte administrateur a été créé
              </p>
            </td>
          </tr>

          <tr>
            <td style={{ padding: "40px 30px" }}>
              <p
                style={{
                  margin: "0 0 20px 0",
                  color: "#1e293b",
                  fontSize: "16px",
                }}
              >
                Bonjour {firstName} {lastName},
              </p>

              <p
                style={{
                  margin: "0 0 20px 0",
                  color: "#475569",
                  fontSize: "16px",
                }}
              >
                Un compte administrateur a été créé pour vous sur la plateforme
                TDS Transports pour l'entreprise <strong>{companyName}</strong>.
              </p>

              <p
                style={{
                  margin: "0 0 30px 0",
                  color: "#475569",
                  fontSize: "16px",
                }}
              >
                Pour activer votre compte et définir votre mot de passe, cliquez
                sur le bouton ci-dessous :
              </p>

              <table
                cellPadding="0"
                cellSpacing="0"
                border={0}
                style={{ width: "100%", marginBottom: "30px" }}
              >
                <tr>
                  <td style={{ textAlign: "center" }}>
                    <a
                      href={activationUrl}
                      style={{
                        display: "inline-block",
                        padding: "16px 40px",
                        backgroundColor: "#155dfc",
                        color: "#ffffff",
                        textDecoration: "none",
                        borderRadius: "8px",
                        fontSize: "16px",
                        fontWeight: 600,
                      }}
                    >
                      Activer mon compte
                    </a>
                  </td>
                </tr>
              </table>

              <table
                cellPadding="0"
                cellSpacing="0"
                border={0}
                style={{
                  width: "100%",
                  backgroundColor: "#fef3c7",
                  borderRadius: "8px",
                  padding: "16px",
                  marginBottom: "20px",
                  borderLeft: "4px solid #f59e0b",
                }}
              >
                <tr>
                  <td>
                    <p
                      style={{
                        margin: 0,
                        color: "#92400e",
                        fontSize: "14px",
                      }}
                    >
                      <strong>Note importante :</strong> Ce lien d'activation
                      expire dans 24 heures. Si le bouton ne fonctionne pas,
                      copiez et collez cette URL dans votre navigateur :
                    </p>
                    <p
                      style={{
                        margin: "8px 0 0 0",
                        color: "#92400e",
                        fontSize: "13px",
                        wordBreak: "break-all",
                      }}
                    >
                      {activationUrl}
                    </p>
                  </td>
                </tr>
              </table>

              <p
                style={{
                  margin: "0 0 10px 0",
                  color: "#475569",
                  fontSize: "14px",
                }}
              >
                En tant qu'administrateur, vous pourrez :
              </p>

              <ul
                style={{
                  margin: "0 0 20px 0",
                  padding: "0 0 0 20px",
                  color: "#475569",
                  fontSize: "14px",
                }}
              >
                <li style={{ marginBottom: "8px" }}>
                  Gérer les utilisateurs de votre entreprise
                </li>
                <li style={{ marginBottom: "8px" }}>
                  Créer et suivre vos demandes de livraison
                </li>
                <li style={{ marginBottom: "8px" }}>
                  Accéder aux rapports et statistiques
                </li>
              </ul>
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
                  margin: "0 0 8px 0",
                  color: "#64748b",
                  fontSize: "13px",
                }}
              >
                Si vous n'avez pas demandé ce compte, vous pouvez ignorer cet
                email.
              </p>
              <p
                style={{
                  margin: 0,
                  color: "#64748b",
                  fontSize: "13px",
                }}
              >
                © 2025 TDS Transports - Tous droits réservés
              </p>
            </td>
          </tr>
        </table>
      </body>
    </html>
  );
}
