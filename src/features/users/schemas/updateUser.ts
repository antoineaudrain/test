import { z } from "zod";

const VerificationJSON = z.object({
  object: z.string(),
  status: z.string(),
  strategy: z.string(),
  attempts: z.number().nullable(),
  expire_at: z.number().nullable(),
  verified_at_client: z.string().optional(),
  external_verification_redirect_url: z.string().nullable().optional(),
  nonce: z.string().nullable().optional(),
  message: z.string().nullable().optional(),
});

const IdentificationLinkJSON = z.object({
  type: z.string(),
  object: z.string(),
  id: z.string(),
});

const EmailAddressJSON = z.object({
  object: z.literal("email_address"),
  id: z.string(),
  email_address: z.string().email(),
  verification: VerificationJSON.nullable(),
  linked_to: z.array(IdentificationLinkJSON),
});

const PhoneNumberJSON = z.object({
  object: z.literal("phone_number"),
  id: z.string(),
  phone_number: z.string(),
  reserved_for_second_factor: z.boolean(),
  default_second_factor: z.boolean(),
  reserved: z.boolean(),
  verification: VerificationJSON.nullable(),
  linked_to: z.array(IdentificationLinkJSON),
  backup_codes: z.array(z.string()),
});

const Web3WalletJSON = z.object({
  object: z.literal("web3_wallet"),
  id: z.string(),
  web3_wallet: z.string(),
  verification: VerificationJSON.nullable(),
});

const OrganizationMembershipPublicUserDataJSON = z.object({
  identifier: z.string(),
  first_name: z.string().nullable(),
  last_name: z.string().nullable(),
  image_url: z.string().url(),
  has_image: z.boolean(),
  user_id: z.string(),
});

const OrganizationJSON = z.object({
  object: z.literal("organization"),
  id: z.string(),
  name: z.string(),
  slug: z.string(),
  image_url: z.string().optional(),
  has_image: z.boolean(),
  members_count: z.number().optional(),
  pending_invitations_count: z.number().optional(),
  max_allowed_memberships: z.number(),
  admin_delete_enabled: z.boolean(),
  public_metadata: z.record(z.string(), z.unknown()).nullable(),
  private_metadata: z.record(z.string(), z.unknown()).optional(),
  created_by: z.string().optional(),
  created_at: z.number(),
  updated_at: z.number(),
});

const OrganizationMembershipJSON = z.object({
  object: z.literal("organization_membership"),
  id: z.string(),
  public_metadata: z.record(z.string(), z.unknown()),
  private_metadata: z.record(z.string(), z.unknown()).optional(),
  role: z.string(),
  permissions: z.array(z.string()),
  created_at: z.number(),
  updated_at: z.number(),
  organization: OrganizationJSON,
  public_user_data: OrganizationMembershipPublicUserDataJSON,
});

const ExternalAccountJSON = z.object({
  object: z.literal("external_account"),
  id: z.string(),
  provider: z.string(),
  identification_id: z.string(),
  provider_user_id: z.string(),
  approved_scopes: z.string(),
  email_address: z.string().email(),
  first_name: z.string(),
  last_name: z.string(),
  image_url: z.string().url().optional(),
  username: z.string().nullable(),
  phone_number: z.string().nullable(),
  public_metadata: z.record(z.string(), z.unknown()).nullable().optional(),
  label: z.string().nullable(),
  verification: VerificationJSON.nullable(),
});

const SamlAccountJSON = z.object({
  object: z.literal("saml_account"),
  id: z.string(),
  provider: z.string(),
  provider_user_id: z.string().nullable(),
  active: z.boolean(),
  email_address: z.string().email(),
  first_name: z.string(),
  last_name: z.string(),
  verification: VerificationJSON.nullable(),
  saml_connection: z.record(z.string(), z.unknown()).nullable(),
});

export const UpdateUserSchema = z.object({
  object: z.literal("user"),
  id: z.string(),
  username: z.string().nullable(),
  first_name: z.string().nullable(),
  last_name: z.string().nullable(),
  image_url: z.string().url(),
  has_image: z.boolean(),
  primary_email_address_id: z.string().nullable(),
  primary_phone_number_id: z.string().nullable(),
  primary_web3_wallet_id: z.string().nullable(),
  password_enabled: z.boolean(),
  two_factor_enabled: z.boolean(),
  totp_enabled: z.boolean(),
  backup_code_enabled: z.boolean(),
  email_addresses: z.array(EmailAddressJSON),
  phone_numbers: z.array(PhoneNumberJSON),
  web3_wallets: z.array(Web3WalletJSON),
  organization_memberships: z.array(OrganizationMembershipJSON).nullable(),
  external_accounts: z.array(ExternalAccountJSON),
  saml_accounts: z.array(SamlAccountJSON),
  password_last_updated_at: z.number().nullable(),
  public_metadata: z.record(z.string(), z.unknown()),
  private_metadata: z.record(z.string(), z.unknown()),
  unsafe_metadata: z.record(z.string(), z.unknown()),
  external_id: z.string().nullable(),
  last_sign_in_at: z.number().nullable(),
  banned: z.boolean(),
  locked: z.boolean(),
  lockout_expires_in_seconds: z.number().nullable(),
  verification_attempts_remaining: z.number().nullable(),
  created_at: z.number(),
  updated_at: z.number(),
  last_active_at: z.number().nullable(),
  create_organization_enabled: z.boolean(),
  create_organizations_limit: z.number().nullable(),
  delete_self_enabled: z.boolean(),
  legal_accepted_at: z.number().nullable(),
});

export type UpdateUserInput = z.infer<typeof UpdateUserSchema>;
